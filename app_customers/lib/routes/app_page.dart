import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../themes/app_colors.dart';
import '../util/preferences_keys.dart';
import '../util/user_contact.dart';
import '../widgets/alert_box.dart';
import '../widgets/app_release_notification/in_app_update.dart';

/// Wrapper for app pages.
class AppPage extends StatelessWidget {
  /// The widget to display under the page.
  final Widget child;

  /// The route to redirect the user to, incase of login.
  final String? locationOfNextPageRoute;

  /// Request the contact permission.
  final bool requestContactPermission;

  /// Constructs a new [AppPage].
  AppPage({
    Key? key,
    this.locationOfNextPageRoute,
    this.requestContactPermission = false,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = Get.find<AppInternationalization>();
    if (requestContactPermission) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        final pref = await SharedPreferences.getInstance();

        final canRequestToContactPermission =
            (await SharedPreferences.getInstance())
                .getBool(PreferencesKeys.requestContactPermission);
        if (canRequestToContactPermission == null && !kIsWeb) {
          showAlertBoxView(
            context: context,
            icon: Icon(
              Icons.people,
              color: AppColors.white,
              size: 30,
            ),
            topBackgroundColor: AppColors.darkBlack,
            negativeBtnText: intl.noThank,
            positiveBtnText: intl.allowAccess,
            negativeBtnPressed: () {
              pref.setBool(PreferencesKeys.requestContactPermission, false);

              Navigator.of(context, rootNavigator: true).pop();
            },
            positiveBtnPressed: () async {
              Navigator.of(context, rootNavigator: true).pop();
              await pref.setBool(
                  PreferencesKeys.requestContactPermission, true);
              await UserContactConfig.init();
            },
            title: intl.allowContactAccess,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${intl.advantages}: '),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Icon(Icons.check, color: AppColors.purple, size: 20),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Text(
                        intl.contactAccessAdvantage1,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(Icons.check, color: AppColors.purple, size: 20),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(child: Text(intl.contactAccessAdvantage2)),
                  ],
                ),
              ],
            ),
          );
        }
      });
    }

    return InAppUpdateCheck(child: Center(child: child));
  }
}

/// Page displayed when users navigate to an invalid page.
class AppPageNotFound extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppPage(
      child: Container(
        child: Center(
          child: Text(
            '404',
            style: TextStyle(fontSize: 36),
          ),
        ),
      ),
    );
  }
}
