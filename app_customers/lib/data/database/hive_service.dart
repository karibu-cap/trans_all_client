import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../../config/environement_conf.dart';
import '../../util/constant.dart';
import '../../util/preferences_keys.dart';
import '../../util/request_reponse.dart';
import 'fake_hive_data.dart';

/// Database type.
enum HiveServiceType {
  /// Local hive database.
  hive,

  /// Fake database implementation for testing.
  fake,
}

/// Local hive service.
abstract class HiveService {
  /// Builds an [HiveService] implementation
  /// for the specified [HiveServiceType].
  factory HiveService(HiveServiceType type) {
    switch (type) {
      case HiveServiceType.hive:
        return HiveServiceImpl();
      default:
        return FakeHiveService();
    }
  }

  /// Create local credit transaction.
  Future<void> createLocalTransaction(
    TransferInfo localCreditTransaction, {
    String? transactionId,
  });

  /// Retrieve all local credit transaction.
  List<TransferInfo> getAllLocalTransaction();

  /// Retrieve local credit transaction with id.
  TransferInfo? getLocalTransaction(String transactionId);

  /// Delete local credit transaction with id.
  Future<void> deleteLocalTransaction(
    String transactionId,
  );

  /// Edit local credit transaction with id.
  Future<void> updateLocalTransaction(
    String transactionId,
    TransferInfo localCreditTransaction,
  );

  /// Stream all local credit transaction.
  Stream<BoxEvent> streamAllLocalTransaction();

  /// Stream all contact.
  Stream<BoxEvent> streamUserContact();

  /// Lists oll the supported payment gateways.
  Future<ListPaymentGatewaysResponse> listPaymentGateways();

  /// Lists oll the supported operation gateways.
  Future<ListOperationGatewaysResponse> listOperationGateways();

  /// Lists oll the supported payment gateways.
  Future<List<PaymentGateways>> listLocalPaymentGateways();

  /// Lists oll the supported operation gateways.
  Future<List<OperationGateways>> listLocalOperationGateways();

  /// Creates remote credit  transaction.
  Future<CreateRemoteTransactionResponse> createRemoteTransaction({
    required String buyerPhoneNumber,
    required String receiverPhoneNumber,
    required num amountToPay,
    required String buyerGatewayId,
    required String featureReference,
    required String receiverOperator,
  });

  /// Gets the transaction by id.
  Future<TransferInfo?> getTheTransaction({
    required String transactionId,
  });

  /// Synchronizes the local operator and payment.
  void synchronizeLocalRemoteGateways();

  /// Lists all local forfeit.
  Future<List<Forfeit>?> getAllForfeit();

  /// Gets contact list.
  Set<Contact> getAllLocalContact();

  /// Gets contact list.
  Set<Contact> getAllLocalBuyerContact();

  /// Creates a user contact.
  Future<void> createUserContact(
    Contact contactInFo, {
    String? contactId,
  });

  /// Creates a buyer user contact.
  Future<void> addUserBuyerContact(
    Contact contactInFo, {
    String? contactId,
  });
}

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

  final String _appBaseUrl = AppEnvironment.appBaseUrl;

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

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
    };
    final List<PaymentGateways> payments = [];
    final url = Uri.parse(
      '$_appBaseUrl/api/payment/methods/all',
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

      return ListPaymentGatewaysResponse(listPaymentGateways: payments);
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of payment gateway got at $url. the response body received is $e',
      );
      if (e is SocketException) {
        return ListPaymentGatewaysResponse(error: RequestError.internetError);
      }

      return ListPaymentGatewaysResponse(error: RequestError.unknown);
    }
  }

  @override
  Future<ListOperationGatewaysResponse> listOperationGateways() async {
    final List<OperationGateways> operations = [];
    final packageInfo = await PackageInfo.fromPlatform();

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
    };
    final url = Uri.parse(
      '$_appBaseUrl/api/transfer/providers/all',
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

      return ListOperationGatewaysResponse(listOperationGateways: operations);
    } catch (e) {
      _logger.severe(
        'Failed to parse the received list of operator gateway got at $url. the response body received is $e',
      );

      if (e is SocketException) {
        return ListOperationGatewaysResponse(error: RequestError.internetError);
      }

      return ListOperationGatewaysResponse(error: RequestError.unknown);
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

    final intl = Get.find<AppInternationalization>();
    final headers = {
      PreferencesKeys.contentType: 'application/json',
      PreferencesKeys.clientVersion: packageInfo.version,
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
      '$_appBaseUrl/api/transfer/create',
    );
    try {
      final response = await http.post(url, headers: headers, body: body);
      final dynamic data = jsonDecode(response.body);
      final Map<String, dynamic> convertData = data as Map<String, dynamic>;

      return CreateRemoteTransactionResponse(transactionId: convertData['id']);
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

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
    };
    final url = Uri.parse(
      '$_appBaseUrl/api/transfer/$transactionId',
    );
    final response = await http.get(url, headers: headers);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final dynamic data = jsonDecode(response.body);
      final Map<String, dynamic> convertData = data as Map<String, dynamic>;
      final TransferInfo transferInfo =
          TransferInfo.fromJson(json: convertData);

      return transferInfo;
    } else {
      _logger.severe(
        'Failed to retrieve the transaction $transactionId  got at $url. the response body received is ${response.body}',
      );

      return null;
    }
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
  List<Contact> getAllContact() {
    return _databaseContact.values.toList();
  }

  @override
  Future<List<Forfeit>?> getAllForfeit() async {
    final List<Forfeit> forfeits = [];
    final packageInfo = await PackageInfo.fromPlatform();

    final headers = {
      PreferencesKeys.clientVersion: packageInfo.version,
    };
    final url = Uri.parse(
      '$_appBaseUrl/api/forfeit/providers/all',
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
}

/// Fake hive implementation.
class FakeHiveService implements HiveService {
  final _database = fakeTransactions;

  @override
  Future<void> createLocalTransaction(
    TransferInfo localCreditTransaction, {
    String? transactionId,
  }) async {
    final _rand = Random();
    if (transactionId == null) {
      _database[_rand.nextInt(100000000).toString()] = localCreditTransaction;

      return;
    }
    _database[transactionId] = localCreditTransaction;

    return;
  }

  @override
  List<TransferInfo> getAllLocalTransaction() {
    return _database.values.toList();
  }

  @override
  TransferInfo? getLocalTransaction(String transactionId) {
    return _database[transactionId];
  }

  /// Delete local credit transaction with id.
  @override
  Future<void> deleteLocalTransaction(
    String transactionId,
  ) async {
    return _database.removeWhere(((key, value) => key == transactionId));
  }

  @override
  Future<void> updateLocalTransaction(
    String transactionId,
    TransferInfo localCreditTransaction,
  ) async {
    _database.update(transactionId, (value) => localCreditTransaction);

    return;
  }

  @override
  Future<void> updateUserContact(
    String contactId,
    Contact contactInfo,
  ) async {
    fakeUserContacts.update(contactId, (value) => contactInfo);

    return;
  }

  @override
  Stream<BoxEvent> streamAllLocalTransaction() async* {
    final controller = StreamController<HiveBoxEvent>();

    fakeTransactions.forEach((key, transaction) {
      controller.add(HiveBoxEvent(1, _database, false));
    });

    yield* controller.stream;
  }

  @override
  Stream<BoxEvent> streamUserContact() async* {
    final controller = StreamController<HiveBoxEvent>();

    fakeUserContacts.forEach((key, contact) {
      controller.add(HiveBoxEvent(1, fakeUserContacts, false));
    });

    yield* controller.stream;
  }

  @override
  Future<ListPaymentGatewaysResponse> listPaymentGateways() async {
    return ListPaymentGatewaysResponse(
      listPaymentGateways: fakeSupportedPayment,
    );
  }

  @override
  Future<ListOperationGatewaysResponse> listOperationGateways() async {
    return ListOperationGatewaysResponse(
      listOperationGateways: fakeOperatorGateWays,
    );
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
    final id = Random().nextInt(100000000).toString();
    _database[id] = TransferInfo.fromJson(json: {
      TransferInfo.keyAmountXAF: amountToPay,
      TransferInfo.keyBuyerGateway: buyerGatewayId,
      TransferInfo.keyBuyerPhoneNumber: buyerPhoneNumber,
      TransferInfo.keyId: id,
      TransferInfo.keyCreatedAt: DateTime.now().toString(),
      TransferInfo.keyFeature: featureReference,
      TransferInfo.keyReason: null,
      TransferInfo.keyReceiverOperator: receiverOperator,
      TransferInfo.keyReceiverPhoneNumber: receiverPhoneNumber,
      TransferInfo.keyStatus: TransferStatus.paymentFailed.key,
      TransferInfo.keyPayments: [
        {
          TransTuPayment.keyGateway: buyerGatewayId,
          TransTuPayment.keyPhoneNumber: buyerPhoneNumber,
          TransTuPayment.keyStatus: PaymentStatus.pending.key,
        },
      ],
    });

    return CreateRemoteTransactionResponse(transactionId: id);
  }

  @override
  Future<TransferInfo?> getTheTransaction({
    required String transactionId,
  }) async {
    return null;
  }

  @override
  Future<List<OperationGateways>> listLocalOperationGateways() async {
    return fakeOperatorGateWays;
  }

  @override
  Future<List<PaymentGateways>> listLocalPaymentGateways() async {
    return fakeSupportedPayment;
  }

  @override
  void synchronizeLocalRemoteGateways() {
    return;
  }

  @override
  Set<Contact> getAllLocalContact() {
    return fakeUserContacts.values.toSet();
  }

  @override
  Future<void> createUserContact(
    Contact contactInfo, {
    String? contactId,
  }) async {
    final _rand = Random();
    if (contactId == null) {
      fakeUserContacts[_rand.nextInt(100000000).toString()] = contactInfo;

      return;
    }
    fakeUserContacts[contactId] = contactInfo;

    return;
  }

  @override
  Future<void> addUserBuyerContact(Contact contactInFo,
      {String? contactId}) async {
    return;
  }

  @override
  Set<Contact> getAllLocalBuyerContact() {
    return {};
  }

  @override
  Future<List<Forfeit>?> getAllForfeit() async {
    return fakeForfeits;
  }
}

/// Hive constructor.
class HiveBoxEvent extends BoxEvent {
  /// Hive box event constructor.
  HiveBoxEvent(super.key, super.value, super.deleted);
}
