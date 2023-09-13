import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../util/constant.dart';
import '../../util/preferences_keys.dart';
import '../../util/request_response.dart';
import 'hive_service.dart';
import 'utils/constants.dart';

/// Live hive implementation.
class HiveServiceImpl implements HiveService {
  final _logger = Logger('HiveServiceImpl');
  final _databaseTransferInfo = Hive.box<TransferInfo>(
    Constant.creditTransactionTable,
  );
  final _databaseOperatorGateway = Hive.box<OperationGateways>(
    Constant.operatorTable,
  );
  final _databasePaymentGateways =
      Hive.box<PaymentGateways>(Constant.paymentGatewaysTable);

  final _databaseContact = Hive.box<Contact>(Constant.contactTable);
  final _forfeitRow = Hive.box<Forfeit>(Constant.forfeitTable);

  final _databaseDefaultBuyerContacts =
      Hive.box<Contact>(Constant.defaultBuyerContactsTable);

  /// New constructor of [HiveServiceImpl].
  HiveServiceImpl() {
    /// Schedule the synchronization every 1 hour.
    Timer.periodic(Duration(hours: 1), (timer) {
      synchronizeLocalRemoteGateways();
    });
  }

  @override
  Future<void> createLocalTransaction(
    TransferInfo localCreditTransaction, {
    String? transactionId,
  }) async {
    if (transactionId == null || transactionId.isEmpty) {
      await _databaseTransferInfo.add(localCreditTransaction);

      return;
    }

    return await _databaseTransferInfo.put(
      transactionId,
      localCreditTransaction,
    );
  }

  @override
  Future<void> createUserContact(
    Contact contactInfo, {
    String? contactId,
  }) async {
    if (contactId == null || contactId.isEmpty) {
      await _databaseContact.add(contactInfo);

      return;
    }

    return await _databaseContact.put(
      contactId,
      contactInfo,
    );
  }

  @override
  Future<void> addUserBuyerContact(
    Contact contactInfo, {
    String? contactId,
  }) async {
    if (contactId == null || contactId.isEmpty) {
      await _databaseDefaultBuyerContacts.add(contactInfo);
      return;
    }

    await _databaseDefaultBuyerContacts.put(
      contactId,
      contactInfo,
    );

    return;
  }

  @override
  Set<Contact> getAllLocalBuyerContact() {
    return _databaseDefaultBuyerContacts.values.toSet();
  }

  @override
  List<TransferInfo> getAllLocalTransaction() {
    return _databaseTransferInfo.values.toList();
  }

  @override
  Set<Contact> getAllLocalContact() {
    return _databaseContact.values.toSet();
  }

  @override
  TransferInfo? getLocalTransaction(String transactionId) {
    return _databaseTransferInfo.get(transactionId);
  }

  @override
  Future<void> deleteLocalTransaction(
    String transactionId,
  ) async {
    return await _databaseTransferInfo.delete(transactionId);
  }

  @override
  Future<void> updateLocalTransaction(
    String transactionId,
    TransferInfo localCreditTransaction,
  ) async {
    return await _databaseTransferInfo.put(
        transactionId, localCreditTransaction);
  }

  @override
  Stream<BoxEvent> streamAllLocalTransaction() => _databaseTransferInfo.watch();
  @override
  Stream<BoxEvent> streamUserContact() => _databaseContact.watch();

  @override
  Future<ListPaymentGatewaysResponse> listPaymentGateways() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final localization = Get.find<AppInternationalization>();

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
      PreferencesKeys.acceptLanguage: localization.locale.languageCode,
    };
    final List<PaymentGateways> payments = [];
    final url = Uri.parse(
      AppRoute.paymentGatewaysRoute,
    );
    try {
      final response = await http.get(
        url,
        headers: headers,
      );

      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> convertData =
          data.map((e) => e as Map<String, dynamic>).toList();
      payments.addAll(
        convertData.map<PaymentGateways>(PaymentGateways.fromJson).toList(),
      );

      unawaited(_databasePaymentGateways.clear());
      unawaited(_databasePaymentGateways.addAll(payments));

      return ListPaymentGatewaysResponse(listPaymentGateways: payments);
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of payment gateway got at $url. the response body received is $e',
      );
      final localOperator = _databasePaymentGateways.values.toList();

      if (localOperator.isEmpty) {
        if (e is SocketException) {
          return ListPaymentGatewaysResponse(error: RequestError.internetError);
        }
        return ListPaymentGatewaysResponse(listPaymentGateways: []);
      }

      return ListPaymentGatewaysResponse(listPaymentGateways: localOperator);
    }
  }

  @override
  Future<ListOperationGatewaysResponse> listOperationGateways() async {
    final List<OperationGateways> operations = [];
    final packageInfo = await PackageInfo.fromPlatform();
    final localization = Get.find<AppInternationalization>();
    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
      PreferencesKeys.acceptLanguage: localization.locale.languageCode,
    };
    final url = Uri.parse(
      AppRoute.operatorGatewaysRoute,
    );
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> convertData =
          data.map((e) => e as Map<String, dynamic>).toList();
      operations.addAll(
        convertData.map<OperationGateways>(OperationGateways.fromJson).toList(),
      );
      unawaited(_databaseOperatorGateway.clear());
      unawaited(_databaseOperatorGateway.addAll(operations));

      return ListOperationGatewaysResponse(listOperationGateways: operations);
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of operator gateway got at $url. the response body received is $e',
      );
      final localOperator = _databaseOperatorGateway.values.toList();

      if (localOperator.isEmpty) {
        if (e is SocketException) {
          return ListOperationGatewaysResponse(
              error: RequestError.internetError);
        }
        return ListOperationGatewaysResponse(listOperationGateways: []);
      }

      return ListOperationGatewaysResponse(
          listOperationGateways: localOperator);
    }
  }

  @override
  Future<CreateRemoteTransactionResponse> createRemoteTransaction({
    required String buyerPhoneNumber,
    required String receiverPhoneNumber,
    required num amountToPay,
    required String buyerGatewayId,
    required String featureReference,
    required String receiverOperator,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final localization = Get.find<AppInternationalization>();

    final headers = {
      PreferencesKeys.contentType: 'application/json',
      PreferencesKeys.clientVersion: packageInfo.version,
      PreferencesKeys.acceptLanguage: localization.locale.languageCode,
    };
    final body = jsonEncode({
      'buyerGatewayId': buyerGatewayId,
      'amountToPay': amountToPay,
      'buyerPhoneNumber': buyerPhoneNumber,
      'featureReference': featureReference,
      'receiverPhoneNumber': receiverPhoneNumber,
      'receiverOperator': receiverOperator,
    });
    final url = Uri.parse(
      AppRoute.createTransferRoute,
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      final dynamic data = jsonDecode(response.body);
      final Map<String, dynamic> convertData = data as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateRemoteTransactionResponse(
          transactionId: convertData['id'],
        );
      }

      final ErrorResponseBody error = ErrorResponseBody.fromJson(convertData);

      return CreateRemoteTransactionResponse(
        error: requestErrorMessage(error.code),
      );
    } catch (e) {
      _logger.severe(
        'Failed to create remote credit transaction with status code $e',
      );
      if (e is SocketException) {
        return CreateRemoteTransactionResponse(
            error: RequestError.internetError);
      }

      return CreateRemoteTransactionResponse(error: RequestError.unknown);
    }
  }

  @override
  Future<TransferInfo?> getTheTransaction({
    required String transactionId,
  }) async {
    final packageInfo = await PackageInfo.fromPlatform();
    final localization = Get.find<AppInternationalization>();

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
      PreferencesKeys.acceptLanguage: localization.locale.languageCode,
    };
    final url = Uri.parse(
      '${AppRoute.getTheTransaction}/$transactionId',
    );
    final response = await http.get(url, headers: headers);
    final dynamic data = jsonDecode(response.body);
    final Map<String, dynamic> convertData = data as Map<String, dynamic>;
    if (response.statusCode == 200 || response.statusCode == 201) {
      final TransferInfo transferInfo =
          TransferInfo.fromJson(json: convertData);

      return transferInfo;
    }
    _logger.severe(
      'Failed to retrieve the transaction $transactionId  got at $url. the response body received is ${response.body}',
    );

    return null;
  }

  @override
  Future<List<OperationGateways>> listLocalOperationGateways() async {
    return _databaseOperatorGateway.values.toList();
  }

  @override
  Future<List<PaymentGateways>> listLocalPaymentGateways() async {
    return _databasePaymentGateways.values.toList();
  }

  @override
  void synchronizeLocalRemoteGateways() async {
    final localOperationGateways = _databaseOperatorGateway.values.toList();
    final localPaymentGateways = _databasePaymentGateways.values.toList();
    final remoteOperationGateways =
        (await listOperationGateways()).listOperationGateways;
    final remotePaymentGateways =
        (await listPaymentGateways()).listPaymentGateways;
    bool canUpdatePayment = false;
    bool canUpdateOperation = false;
    if (remoteOperationGateways == null || remotePaymentGateways == null) {
      return;
    }
    for (final operator in remoteOperationGateways) {
      final index = localOperationGateways.indexWhere(
        (element) => element.reference == operator.reference,
      );
      if (index == -1) {
        canUpdateOperation = true;
      }
    }
    for (final payment in remotePaymentGateways) {
      final index = localPaymentGateways.indexWhere(
        (element) => element.id == payment.id,
      );
      if (index == -1) {
        canUpdatePayment = true;
      }
    }
    if (canUpdateOperation || canUpdatePayment) {
      await _databaseOperatorGateway.clear();
      await _databasePaymentGateways.clear();
      await _databaseOperatorGateway.addAll(remoteOperationGateways);
      await _databasePaymentGateways.addAll(remotePaymentGateways);
    }

    return;
  }

  @override
  Future<List<Forfeit>?> getAllForfeit() async {
    final List<Forfeit> forfeits = [];
    final packageInfo = await PackageInfo.fromPlatform();
    final localization = Get.find<AppInternationalization>();

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
      PreferencesKeys.acceptLanguage: localization.locale.languageCode,
    };

    final url = Uri.parse(
      AppRoute.listOfForfeit,
    );
    try {
      final response = await http.get(
        url,
        headers: headers,
      );
      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> convertData =
          data.map((e) => e as Map<String, dynamic>).toList();
      forfeits.addAll(
        convertData.map<Forfeit>(Forfeit.fromJson).toList(),
      );

      await _forfeitRow.clear();
      await _forfeitRow.addAll(forfeits);

      return forfeits;
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of forfeit gateway got at $url. the response body received is $e',
      );

      /// Retrieves the local forfeit if exist.
      final local = _forfeitRow.values.toList();
      if (local.isNotEmpty) {
        return local;
      }
      return null;
    }
  }

  @override
  Forfeit? getForfeitById(String id) => _forfeitRow.get(id);
}
