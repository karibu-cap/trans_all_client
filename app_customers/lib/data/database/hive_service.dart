import 'dart:async';

import 'package:clock/clock.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

import '../../util/request_response.dart';
import 'fake_hive_implementation.dart';
import 'hive_implementation.dart';

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

  /// Lists all local forfeit.
  Forfeit? getForfeitById(String forfeitId);

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

/// The HiveBoxEvent.
class HiveBoxEvent extends BoxEvent {
  /// Hive box event constructor.
  HiveBoxEvent(super.key, super.value, super.deleted);
}
