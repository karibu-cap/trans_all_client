import 'dart:async';

import 'package:clock/clock.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../util/key_internationalization.dart';

enum LoadingState {
  loading,
  initiate,
  processToTransfer,
  failed,
  succeeded,
}

/// The InitTransaction view model.
class InitTransactionViewModel {
  final TransferRepository _transferRepository;

  /// The current forfeit to transfers.
  Forfeit? forfeit;

  /// Returns the error message.
  Rx<String?> errorMessage = Rx<String?>(null);

  /// The transaction id.
  Rx<String?> transactionId = Rx<String?>(null);

  /// The number who make the payment.
  final String buyerPhoneNumber;

  /// The buyer gateway.
  final String buyerGatewayId;

  /// The receive operator.
  final String receiverOperator;

  /// The reference.
  final String featureReference;

  /// The receiver number.
  final String receiverPhoneNumber;

  /// The amount of transaction.
  final num amountToPay;

  /// The init loading state.
  Rx<LoadingState> loadingState = Rx(LoadingState.loading);

  /// Constructor of new [InitTransactionViewModel].
  InitTransactionViewModel({
    required this.buyerPhoneNumber,
    required this.receiverPhoneNumber,
    required this.amountToPay,
    required this.buyerGatewayId,
    required this.featureReference,
    required this.receiverOperator,
    required TransferRepository transferRepository,
    required ForfeitRepository forfeitRepository,
    String? existedTransactionId,
    String? forfeitId,
  })  : _transferRepository = transferRepository,
        forfeit = getCurrentForfeit(
          forfeitId,
          forfeitRepository,
        ) {
    if (existedTransactionId != null) {
      retrieveTransaction(existedTransactionId);
    } else {
      init();
    }
  }

  /// Retrieves the current forfeit.
  static Forfeit? getCurrentForfeit(
    String? forfeitId,
    ForfeitRepository forfeitRepository,
  ) {
    if (forfeitId == null || forfeitId.isEmpty) {
      return null;
    }

    return forfeitRepository.getForfeitById(forfeitId);
  }

  /// Retrieves transaction.
  Future<void> retrieveTransaction(String idOfTransaction) async {
    final transfer = _transferRepository.getLocalTransaction(idOfTransaction);
    if (transfer == null) return;
    transactionId.value = idOfTransaction;
    updateLoadingState(transfer);
  }

  /// The init function.
  Future<void> init() async {
    // Init the transaction.
    final transactionIdResult =
        await _transferRepository.createRemoteTransaction(
      amountToPay: amountToPay,
      buyerGatewayId: buyerGatewayId,
      buyerPhoneNumber: buyerPhoneNumber,
      featureReference: featureReference,
      receiverOperator: receiverOperator,
      receiverPhoneNumber: receiverPhoneNumber,
    );
    final error = transactionIdResult.error;
    if (transactionIdResult.transactionId == null && error != null) {
      errorMessage.value = requestErrorTranslate(
        requestError: error,
        buyerPhoneNumber: buyerPhoneNumber,
        receiverNumber: receiverPhoneNumber,
      );
      loadingState.value = LoadingState.failed;

      return null;
    }

    loadingState.value = LoadingState.initiate;
    transactionId.value ??= transactionIdResult.transactionId;
    errorMessage.value = null;

    final transfers = TransferInfo.fromJson(json: {
      TransferInfo.keyAmountXAF: amountToPay,
      TransferInfo.keyBuyerGateway: buyerGatewayId,
      TransferInfo.keyBuyerPhoneNumber: buyerPhoneNumber,
      TransferInfo.keyId: transactionId.value,
      TransferInfo.keyCreatedAt: clock.now().toString(),
      TransferInfo.keyFeature: featureReference,
      TransferInfo.keyReason: null,
      TransferInfo.keyReceiverOperator: receiverOperator,
      TransferInfo.keyReceiverPhoneNumber: receiverPhoneNumber,
      TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
      TransferInfo.keyPayments: [
        {
          TransTuPayment.keyGateway: buyerGatewayId,
          TransTuPayment.keyPhoneNumber: buyerPhoneNumber,
          TransTuPayment.keyStatus: PaymentStatus.initialized.key,
        },
      ],
    });

    await _transferRepository.createLocalTransaction(
      transactionId: transactionId.value,
      transfers,
    );

    return;
  }

  /// Update the loading state depending on transfer.
  void updateLoadingState(TransferInfo transfer) {
    final newPaymentTransactionStatus = transfer.payments.last.status;
    final newTransferStatus = transfer.status;

    if (newPaymentTransactionStatus.key == PaymentStatus.failed.key ||
        newTransferStatus.key == TransferStatus.failed.key ||
        newTransferStatus.key == TransferStatus.paymentFailed.key) {
      loadingState.value = LoadingState.failed;

      return;
    }
    if (newTransferStatus.key == TransferStatus.completed.key ||
        newTransferStatus.key == TransferStatus.succeeded.key) {
      loadingState.value = LoadingState.succeeded;

      return;
    }
    if (transfer.status.key == TransferStatus.requestSend.key) {
      loadingState.value = LoadingState.processToTransfer;

      return;
    }
    loadingState.value = LoadingState.initiate;
  }
}
