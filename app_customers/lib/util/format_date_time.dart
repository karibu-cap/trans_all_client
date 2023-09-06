import 'package:clock/clock.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

/// Format the date .
String dateFormatted(DateTime dateTime) {
  final localization = Get.find<AppInternationalization>();

  final DateTime now = clock.now();
  final DateFormat formatter =
      DateFormat.yMMMd(localization.locale.languageCode);
  if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day) {
    return localization.today;
  } else if (dateTime.year == now.year &&
      dateTime.month == now.month &&
      dateTime.day == now.day - 1) {
    return localization.yesterday;
  } else {
    return formatter.format(dateTime);
  }
}

/// Format the time.
String timeFormatted(DateTime time) {
  final localization = Get.find<AppInternationalization>();

  final DateFormat formatter = DateFormat.Hm(localization.locale.languageCode);

  return formatter.format(time);
}
