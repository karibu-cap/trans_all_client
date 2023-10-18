import 'dart:async';
import 'dart:math';

import 'package:clock/clock.dart';
import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

import '../../util/request_response.dart';
import 'fake_hive_data.dart';
import 'hive_service.dart';

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

  /// Deletes local credit transaction with id.
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
    String? forfeitReference,
  }) async {
    final id = Random().nextInt(100000000).toString();
    _database[id] = TransferInfo.fromJson(json: {
      TransferInfo.keyAmountXAF: amountToPay,
      TransferInfo.keyBuyerPhoneNumber: buyerPhoneNumber,
      TransferInfo.keyId: id,
      TransferInfo.keyCreatedAt: clock.now().toString(),
      TransferInfo.keyFeature: featureReference,
      TransferInfo.keyReason: null,
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
  Future<void> addUserBuyerContact(
    Contact contactInFo, {
    String? contactId,
  }) async {
    return;
  }

  @override
  Set<Contact> getAllLocalBuyerContact() {
    return {};
  }

  @override
  Future<List<Forfeit>?> getAllForfeit() async {
    return fakeForfeits['data'];
  }

  @override
  Forfeit? getForfeitByReference(String id) =>
      fakeForfeits['data']?.firstWhere((element) => element.reference == id);
}
