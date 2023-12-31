import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
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
  HiveServiceImpl();

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
    final localPaymentGateways = _databasePaymentGateways.values.toList();

    if (localPaymentGateways.isNotEmpty) {
      return ListPaymentGatewaysResponse(
        listPaymentGateways: localPaymentGateways,
      );
    }
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
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(Duration(seconds: 10));

      final List<dynamic> data = jsonDecode(response.body);
      final List<Map<String, dynamic>> convertData =
          data.map((e) => e as Map<String, dynamic>).toList();
      payments.addAll(
        convertData.map<PaymentGateways>(PaymentGateways.fromJson).toList(),
      );

      await _databasePaymentGateways.clear();
      await _databasePaymentGateways.addAll(payments);

      return ListPaymentGatewaysResponse(listPaymentGateways: payments);
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of payment gateway got at $url. the response body received is $e',
      );
      final localOperator = _databasePaymentGateways.values.toList();

      if (localOperator.isEmpty) {
        if (e is SocketException || e is TimeoutException) {
          return ListPaymentGatewaysResponse(error: RequestError.internetError);
        }
        return ListPaymentGatewaysResponse(listPaymentGateways: []);
      }

      return ListPaymentGatewaysResponse(listPaymentGateways: localOperator);
    }
  }

  @override
  Future<ListOperationGatewaysResponse> listOperationGateways() async {
    final localOperator = _databaseOperatorGateway.values.toList();
    if (localOperator.isNotEmpty) {
      return ListOperationGatewaysResponse(
        listOperationGateways: localOperator,
      );
    }
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
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(Duration(seconds: 10));
      final dynamic bodyResponse = jsonDecode(response.body);

      final responseData = ResponseBody.fromJson(
        bodyResponse as Map<String, dynamic>,
      );

      if (responseData.code == 2000 || responseData.code == 2001) {
        final data = responseData.data as List<dynamic>;
        final List<Map<String, dynamic>> convertData =
            data.map((e) => e as Map<String, dynamic>).toList();
        operations.addAll(
          convertData
              .map<OperationGateways>(OperationGateways.fromJson)
              .toList(),
        );
        await _databaseOperatorGateway.clear();
        await _databaseOperatorGateway.addAll(operations);

        return ListOperationGatewaysResponse(listOperationGateways: operations);
      }
      final localOperator = _databaseOperatorGateway.values.toList();

      return ListOperationGatewaysResponse(
        listOperationGateways: localOperator,
      );
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of operator gateway got at $url. the response body received is $e',
      );
      final localOperator = _databaseOperatorGateway.values.toList();

      if (localOperator.isEmpty) {
        if (e is SocketException || e is TimeoutException) {
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
    });
    final url = Uri.parse(
      AppRoute.createTransferRoute,
    );
    try {
      final response = await http.post(url, headers: headers, body: body);

      final dynamic bodyResponse = jsonDecode(response.body);

      final responseData = ResponseBody.fromJson(
        bodyResponse as Map<String, dynamic>,
      );
      if (responseData.code == 2001 || responseData.code == 2000) {
        return CreateRemoteTransactionResponse(
          transactionId: (responseData.data as Map<String, dynamic>)['id'],
        );
      }

      final errorCode = requestErrorMessage(responseData.code);

      return CreateRemoteTransactionResponse(
        errorMessage: errorCode == RequestError.unknown
            ? localization.anErrorOccurred
            : responseData.errorMessage,
      );
    } catch (e) {
      _logger.severe(
        'Failed to create remote credit transaction with status code $e',
      );
      if (e is SocketException || e is TimeoutException) {
        return CreateRemoteTransactionResponse(
          errorMessage: localization.troubleInternetConnection,
        );
      }

      return CreateRemoteTransactionResponse(
        errorMessage: localization.anErrorOccurred,
      );
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
      final response = await http
          .get(
            url,
            headers: headers,
          )
          .timeout(Duration(seconds: 10));

      final result = jsonDecode(response.body);

      final List<dynamic> data = result['data'];
      final List<Map<String, dynamic>> convertData =
          data.map((e) => e as Map<String, dynamic>).toList();
      forfeits.addAll(
        convertData.map<Forfeit>(Forfeit.fromJson).toList(),
      );

      await _forfeitRow.clear();
      await _forfeitRow.addAll([...forfeits]);

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
  Forfeit? getForfeitByReference(String reference) {
    final localForfeit = _forfeitRow.values.toList();

    return localForfeit.toList().firstWhereOrNull(
          (element) => element.reference == reference,
        );
  }
}
