import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

import '../data/database/hive_service.dart';

/// Internationalization of forfeit validity.
String forfeitValidityTranslate(String key) {
  final localization = Get.find<AppInternationalization>();
  final validity = Validity.fromKey(key);

  switch (validity) {
    case Validity.day:
      return localization.day;
    case Validity.month:
      return localization.month;
    case Validity.week:
      return localization.week;
    default:
      return '';
  }
}

/// Internationalization of forfeit category.
String forfeitCategoryTranslate(String key) {
  final localization = Get.find<AppInternationalization>();
  final category = Category.fromKey(key);

  switch (category) {
    case Category.call:
      return localization.call;
    case Category.data:
      return localization.data;
    case Category.sms:
      return localization.sms;
    default:
      return '';
  }
}

/// Internationalization of request error.
String requestErrorTranslate({
  required RequestError requestError,
  required String buyerPhoneNumber,
  required String receiverNumber,
}) {
  final localization = Get.find<AppInternationalization>();
  switch (requestError) {
    case RequestError.internetError:
      return localization.troubleInternetConnection;
    case RequestError.insufficientFund:
      return localization.insufficientFund.trParams({
        'number': buyerPhoneNumber,
      });
    case RequestError.transactionCancel:
      return localization.transactionCancelled;
    case RequestError.clientWithMultiplePendingTransfer:
      return localization.clientWithMultiplePendingTransfer.trParams({
        'receiverNumber': receiverNumber,
      });
    case RequestError.userNumberNotFound:
      return localization.userNumberNotFound.trParams({
        'number': buyerPhoneNumber,
      });
    case RequestError.troubleWithProvider:
      return localization.troubleWithProvider;
    case RequestError.unsupportedProvider:
      return localization.unsupportedProvider;
    case RequestError.invalidFeatureProvider:
      return localization.invalidFeatureProvider;
    default:
      return localization.anErrorOccurred;
  }
}
