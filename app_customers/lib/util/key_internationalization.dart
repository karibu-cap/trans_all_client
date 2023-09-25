import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';

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
