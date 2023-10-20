import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

/// Returns the valid client status.
String retrieveValidStatusInternalized(
  TransferInfo transfer,
) {
  final localization = Get.find<AppInternationalization>();
  final paymentStatus = transfer.payments.last.status.key;
  final transferStatus = transfer.status.key;
  final isPaymentSuccess = paymentStatus == PaymentStatus.succeeded.key;

  if (paymentStatus == PaymentStatus.failed.key ||
      transferStatus == TransferStatus.paymentFailed.key) {
    return localization.paymentFailed;
  }
  if (paymentStatus == PaymentStatus.initialized.key) {
    return localization.paymentInitialized;
  }
  if (paymentStatus == PaymentStatus.pending.key) {
    return localization.paymentPending;
  }
  if ((transferStatus == TransferStatus.succeeded.key ||
          transferStatus == TransferStatus.completed.key) &&
      isPaymentSuccess) {
    return localization.succeedTransfer;
  }
  if (transferStatus == TransferStatus.waitingRequest.key && isPaymentSuccess) {
    return localization.waitingRequest;
  }
  if (transferStatus == TransferStatus.requestSend.key && isPaymentSuccess) {
    return localization.requestSend;
  }
  if (transferStatus == TransferStatus.failed.key && isPaymentSuccess) {
    return localization.failedTransfer;
  }

  return '';
}

/// Retrieve the operator Name by reference for.
/// Specially for all version where operatorName can't exit.
String getOperatorNameByReference(String reference) {
  if (reference == 'orangeUnitTransfer') {
    return Operator.orange.key;
  }
  if (reference == 'camtelUnitTransfer') {
    return Operator.camtel.key;
  }
  if (reference == 'mtnUnitTransfer') {
    return Operator.mtn.key;
  }

  return Operator.unknown.key;
}
