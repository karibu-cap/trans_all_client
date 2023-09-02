import 'dart:async';

import 'package:clock/clock.dart';
import 'package:hive/hive.dart';
import 'package:trans_all_common_models/models.dart';

import '../../util/request_reponse.dart';
import '../database/hive_service.dart';

/// The transfer repository.
class TransferRepository {
  final HiveService _hiveService;

  /// Constructs a new [TransferRepository].
  TransferRepository(this._hiveService);

  /// Create local credit transaction.
  Future<void> createLocalTransaction(
    TransferInfo transferInfo, {
    String? transactionId,
  }) async =>
      _hiveService.createLocalTransaction(
        transferInfo,
        transactionId: transactionId,
      );

  /// Retrieve all local credit transaction.
  List<TransferInfo> getAllLocalTransaction() =>
      _hiveService.getAllLocalTransaction();

  /// Stream all local credit transaction.
  Stream<BoxEvent> streamAllLocalTransaction() =>
      _hiveService.streamAllLocalTransaction();

  /// Retrieve local credit transaction with id.
  TransferInfo? getLocalTransaction(String transactionId) =>
      _hiveService.getLocalTransaction(transactionId);

  /// Edit local credit transaction with id.
  Future<void> updateLocalTransaction(
    String transactionId,
    TransferInfo transferInfo,
  ) async =>
      _hiveService.updateLocalTransaction(
        transactionId,
        transferInfo,
      );

  /// Updates the local transaction status retrieve with id.
  Future<void> updateLocalTransactionStatus(
    String transactionId,
    String status,
    bool isPaymentStatus,
  ) async {
    final localTransaction = _hiveService.getLocalTransaction(transactionId);

    if (localTransaction == null) {
      return;
    }
    if (isPaymentStatus) {
      return _hiveService.updateLocalTransaction(
        transactionId,
        TransferInfo.fromJson(json: {
          ...localTransaction.toJson(),
          TransferInfo.keyUpdateAt: clock.now().toString(),
          TransferInfo.keyCreatedAt: localTransaction.createdAt.toString(),
          TransferInfo.keyPayments: [
            {
              ...localTransaction.payments.last.toJson(),
              TransTuPayment.keyStatus: status,
            },
          ],
        }),
      );
    }

    return _hiveService.updateLocalTransaction(
      transactionId,
      TransferInfo.fromJson(json: {
        ...localTransaction.toJson(),
        TransferInfo.keyUpdateAt: clock.now().toString(),
        TransferInfo.keyCreatedAt: localTransaction.createdAt.toString(),
        TransferInfo.keyStatus: status,
      }),
    );
  }

  /// Delete local credit transaction with id.
  Future<void> deleteLocalTransaction(
    String transactionId,
  ) async =>
      _hiveService.deleteLocalTransaction(transactionId);

  /// Create remote credit  transaction.
  Future<CreateRemoteTransactionResponse> createRemoteTransaction({
    required String buyerPhoneNumber,
    required String receiverPhoneNumber,
    required num amountToPay,
    required String buyerGatewayId,
    required String featureReference,
    required String receiverOperator,
  }) async {
    return _hiveService.createRemoteTransaction(
      buyerPhoneNumber: buyerPhoneNumber,
      receiverPhoneNumber: receiverPhoneNumber,
      amountToPay: amountToPay,
      buyerGatewayId: buyerGatewayId,
      featureReference: featureReference,
      receiverOperator: receiverOperator,
    );
  }

  /// Get the transaction by id.
  Future<TransferInfo?> getTheTransaction({
    required String transactionId,
  }) async {
    return _hiveService.getTheTransaction(
      transactionId: transactionId,
    );
  }

  /// Lists of oll the supported payment gateways.
  Future<ListPaymentGatewaysResponse> listOfSupportedPaymentGateways() async =>
      _hiveService.listPaymentGateways();

  /// Lists oll the supported payment gateways.
  Future<List<PaymentGateways>> listOfLocalSupportedPaymentGateways() async =>
      _hiveService.listLocalPaymentGateways();

  /// Lists of oll the supported operation gateways.
  Future<ListOperationGatewaysResponse>
      listOfSupportedOperationGateways() async =>
          _hiveService.listOperationGateways();

  /// Lists of oll the supported operation gateways.
  Future<List<OperationGateways>>
      listOfLocalSupportedOperationGateways() async =>
          _hiveService.listLocalOperationGateways();

  /// Synchronize the local operator and payment.
  void synchronizeLocalRemoteGateways() async =>
      _hiveService.synchronizeLocalRemoteGateways();
}
