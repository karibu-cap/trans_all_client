import 'dart:async';

import 'package:clock/clock.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranfersRepository.dart';
import '../../routes/pages_routes.dart';

enum LoadingState {
  load,
  initiated,
  proceeded,
  failed,
  succeeded,
}

/// The InitTransaction view model.
class InitTransactionViewModel {
  final TransferRepository _transferRepository;

  /// The current forfeit to transfers.
  Rx<Forfeit?>? forfeit;

  /// Returns the error message.
  Rx<String?> errorMessage = Rx<String?>(null);

  /// The transaction id.
  Rx<String?> transactionId = Rx<String?>(null);

  /// The number who make the payment.
  Rx<String?> buyerPhoneNumber = Rx<String?>(null);

  /// The buyer gateway.
  Rx<String?> buyerGatewayId = Rx<String?>(null);

  /// The receiver number.
  Rx<String?> receiverPhoneNumber = Rx<String?>(null);

  /// The amount of transaction.
  Rx<num?> amountToPay = Rx<num?>(null);

  /// The credit transaction.
  final CreditTransactionParams creditTransactionParams;

  /// The init loading state.
  Rx<LoadingState> loadingState = Rx(LoadingState.load);

  /// Constructor of new [InitTransactionViewModel].
  InitTransactionViewModel({
    required this.creditTransactionParams,
    required TransferRepository transferRepository,
    required ForfeitRepository forfeitRepository,
  }) : _transferRepository = transferRepository {
    getCurrentForfeit(
      creditTransactionParams.forfeitId,
      forfeitRepository,
    );
    final transactionId = creditTransactionParams.transactionId;
    if (transactionId != null) {
      retrieveTransaction(transactionId);
    } else {
      init();
    }
  }

  /// Retrieves the current forfeit.
  Forfeit? getCurrentForfeit(
    String? forfeitId,
    ForfeitRepository forfeitRepository,
  ) {
    if (forfeitId == null || forfeitId.isEmpty) {
      return null;
    }

    forfeit?.value = forfeitRepository.getForfeitById(forfeitId);

    return null;
  }

  /// Retrieves transaction.
  Future<void> retrieveTransaction(String idOfTransaction) async {
    final transfer = _transferRepository.getLocalTransaction(idOfTransaction);
    if (transfer == null) return;
    transactionId.value = idOfTransaction;
    amountToPay.value = transfer.amount;
    receiverPhoneNumber.value = transfer.receiverPhoneNumber;
    buyerPhoneNumber.value = transfer.buyerPhoneNumber;
    buyerGatewayId.value = transfer.payments.last.gateway.key;

    updateLoadingState(transfer);
  }

  /// The init function.
  Future<void> init() async {
    final amountFromParam = creditTransactionParams.amountInXaf;
    final buyerGatewayIdFromParam = creditTransactionParams.buyerGatewayId;
    final buyerPhoneNumberFromParam = creditTransactionParams.buyerPhoneNumber;
    final featureReferenceFromParam = creditTransactionParams.featureReference;
    final receiverPhoneNumberFromParam =
        creditTransactionParams.receiverPhoneNumber;
    if (amountFromParam == null ||
        buyerGatewayIdFromParam == null ||
        buyerPhoneNumberFromParam == null ||
        featureReferenceFromParam == null ||
        receiverPhoneNumberFromParam == null) {
      return;
    }
    amountToPay.value = num.parse(amountFromParam);
    receiverPhoneNumber.value = receiverPhoneNumberFromParam;
    buyerPhoneNumber.value = buyerPhoneNumberFromParam;
    buyerGatewayId.value = buyerGatewayIdFromParam;

    // Init the transaction.
    final transactionIdResult =
        await _transferRepository.createRemoteTransaction(
      amountToPay: num.parse(amountFromParam),
      buyerGatewayId: buyerGatewayIdFromParam,
      buyerPhoneNumber: buyerPhoneNumberFromParam,
      featureReference: featureReferenceFromParam,
      receiverPhoneNumber: receiverPhoneNumberFromParam,
    );
    final errorMessageResponse = transactionIdResult.errorMessage;

    if (errorMessageResponse != null && errorMessageResponse.isNotEmpty) {
      errorMessage.value = errorMessageResponse;
      loadingState.value = LoadingState.failed;

      return null;
    }

    loadingState.value = LoadingState.initiated;
    transactionId.value ??= transactionIdResult.transactionId;
    errorMessage.value = null;

    final transfers = TransferInfo.fromJson(json: {
      TransferInfo.keyAmountXAF: num.parse(amountFromParam),
      TransferInfo.keyBuyerPhoneNumber: buyerPhoneNumberFromParam,
      TransferInfo.keyId: transactionId.value,
      TransferInfo.keyCreatedAt: clock.now().toString(),
      TransferInfo.keyFeature: featureReferenceFromParam,
      TransferInfo.keyReason: null,
      TransferInfo.keyReceiverPhoneNumber: receiverPhoneNumberFromParam,
      TransferInfo.keyStatus: TransferStatus.waitingRequest.key,
      TransferInfo.keyPayments: [
        {
          TransTuPayment.keyGateway: buyerGatewayIdFromParam,
          TransTuPayment.keyPhoneNumber: buyerPhoneNumberFromParam,
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
      loadingState.value = LoadingState.proceeded;

      return;
    }
    loadingState.value = LoadingState.initiated;
  }
}
