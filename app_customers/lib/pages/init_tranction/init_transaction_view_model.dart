import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_models/models.dart';

import '../../data/repository/forfeitRepository.dart';
import '../../data/repository/tranferRepository.dart';
import '../../routes/pages_routes.dart';

/// The transaction loading state.
enum LoadingState {
  load,
  initiated,
  proceeded,
  failed,
  succeeded,
  retryTransfer,
}

/// The InitTransaction view model.
class InitTransactionViewModel {
  final TransferRepository _transferRepository;
  final ForfeitRepository _forfeitRepository;
  final _logger = Logger('InitTransactionController');

  /// The progressive timer.
  Timer progressiveTimer = Timer(Duration.zero, () {});

  /// The current forfeit to transfers.
  Rx<Forfeit?> forfeit = Rx<Forfeit?>(null);

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

  /// The transfer progress indicator.
  ValueNotifier<double> transferProgress = ValueNotifier(1);

  /// Completes the transfer state.
  Completer<void> transferCompleter = Completer<void>();

  /// Constructor of new [InitTransactionViewModel].
  InitTransactionViewModel({
    required this.creditTransactionParams,
    required TransferRepository transferRepository,
    required ForfeitRepository forfeitRepository,
  })  : _transferRepository = transferRepository,
        _forfeitRepository = forfeitRepository {
    _initTransferData().then((_) {
      transferCompleter.complete();
      _initTransfer();
    });
  }

  Future<void> _initTransferData() async {
    if (creditTransactionParams.category != Category.unit.key) {
      forfeit.value = _forfeitRepository.getForfeitByReference(
        creditTransactionParams.featureReference,
      );
    }

    return;
  }

  Future<void> _initTransfer() async {
    final transactionId = creditTransactionParams.transactionId;
    watchTransaction();

    if (transactionId != null) {
      await retrieveTransaction(transactionId);
    } else {
      await initTransfer();
    }
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
    updateTransferProgression(transfer);
    updateLoadingState(transfer);
  }

  /// The init function.
  Future<void> initTransfer() async {
    final amountFromParam = creditTransactionParams.amountInXaf;
    final buyerGatewayIdFromParam = creditTransactionParams.buyerGatewayId;
    final buyerPhoneNumberFromParam = creditTransactionParams.buyerPhoneNumber;
    final featureReferenceFromParam = creditTransactionParams.featureReference;
    final operatorNameFromParam = creditTransactionParams.operatorName;
    final categoryFromParam = creditTransactionParams.category;
    final receiverPhoneNumberFromParam =
        creditTransactionParams.receiverPhoneNumber;

    amountToPay.value = num.parse(amountFromParam);
    receiverPhoneNumber.value = receiverPhoneNumberFromParam;
    buyerPhoneNumber.value = buyerPhoneNumberFromParam;
    buyerGatewayId.value = buyerGatewayIdFromParam;

    // Initiate the transaction.
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
      TransferInfo.keyCategory: categoryFromParam,
      TransferInfo.keyOperatorName: operatorNameFromParam,
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
    transferProgress.value = 12;

    return;
  }

  /// Watches the transaction with id.
  void watchTransaction() {
    _transferRepository.streamAllLocalTransaction().listen((event) async {
      final transfertId = transactionId.value;
      if (transfertId == null ||
          transfertId.isEmpty ||
          loadingState.value == LoadingState.failed ||
          loadingState.value == LoadingState.succeeded) {
        return;
      }
      final TransferInfo? transferInfo =
          _transferRepository.getLocalTransaction(transfertId);
      _logger.info(
        'Transfer $transactionId retrieve with status: ${transferInfo?.status.key}',
      );
      if (transferInfo == null) {
        return;
      }

      updateTransferProgression(transferInfo);
      updateLoadingState(transferInfo);
    });

    return;
  }

  /// Updates the transfer progression.
  void updateTransferProgression(TransferInfo transfer) {
    final paymentStatus = transfer.payments.last.status;
    final transferStatus = transfer.status;
    final isPaymentSuccess =
        transfer.payments.last.status == PaymentStatus.succeeded;

    if (paymentStatus == PaymentStatus.failed ||
        transferStatus == TransferStatus.paymentFailed) {
      transferProgress.value = 25;

      return;
    }
    if (paymentStatus == PaymentStatus.pending) {
      if (transferProgress.value < 50) {
        transferProgress.value = 50;
      }

      return;
    }
    if (paymentStatus == PaymentStatus.initialized) {
      if (transferProgress.value < 12) {
        transferProgress.value = 12;
      }

      return;
    }
    if ((transferStatus == TransferStatus.succeeded ||
            transferStatus == TransferStatus.completed) &&
        isPaymentSuccess) {
      transferProgress.value = 100;

      return;
    }
    if (transferStatus == TransferStatus.waitingRequest && isPaymentSuccess) {
      progressiveTimer.cancel();
      if (transferProgress.value < 75) {
        transferProgress.value = 75;
      }

      progressiveTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (transferProgress.value >= 90) {
          progressiveTimer.cancel();
        } else {
          transferProgress.value += 0.5;
        }
      });

      return;
    }
    if ((transferStatus == TransferStatus.requestSend ||
            transferStatus == TransferStatus.retryLaterRequest) &&
        isPaymentSuccess) {
      progressiveTimer.cancel();
      if (transferProgress.value < 90) {
        transferProgress.value = 90;
      }

      progressiveTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (transferProgress.value >= 98) {
          progressiveTimer.cancel();
        } else {
          transferProgress.value += 0.5;
        }
      });

      return;
    }
    if (transferStatus == TransferStatus.failed && isPaymentSuccess) {
      progressiveTimer.cancel();
      transferProgress.value = 75;

      return;
    }
  }

  /// Updates the loading state depending on transfer.
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
    if (transfer.status.key == TransferStatus.retryLaterRequest.key) {
      loadingState.value = LoadingState.retryTransfer;

      return;
    }
    loadingState.value = LoadingState.initiated;
  }
}
