import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

/// Returns the valid client status.
String getValidStatus(
  TransferStatus transferStatus,
  PaymentStatus paymentStatus,
) {
  final localization = Get.find<AppInternationalization>();

  if (paymentStatus == PaymentStatus.failed ||
      transferStatus == TransferStatus.failed ||
      transferStatus == TransferStatus.paymentFailed) {
    return localization.cancelled;
  }
  if (transferStatus == TransferStatus.succeeded ||
      transferStatus == TransferStatus.completed) {
    return localization.succeed;
  }

  return localization.pending;
}
