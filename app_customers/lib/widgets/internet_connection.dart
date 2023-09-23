import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../themes/app_colors.dart';
import '../util/preferences_keys.dart';

/// Displays a message indicating the internet connection status.
class InternetConnectivityView extends StatelessWidget {
  /// Constructs an [InternetConnectivityView].
  InternetConnectivityView();

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final Widget defaultWidget = SizedBox();

    final ValueNotifier<Widget> _widgetSwitcher = ValueNotifier(defaultWidget);

    return StreamBuilder<InternetConnectionStatus>(
      stream: InternetConnectionCheckerPlus.createInstance().onStatusChange,
      builder: (context, snapshot) {
        final theme = Theme.of(context);

        final connectionStatus = snapshot.data;
        final Widget noConnection = Container(
          color: theme.secondaryHeaderColor,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.noInternetConnection,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );

        final Widget connectionRestored = Container(
          color: AppColors.lightGreen,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localization.connectionRestore,
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );

        if (connectionStatus == null) {
          return SizedBox.shrink();
        }

        if (connectionStatus == InternetConnectionStatus.connected) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            _widgetSwitcher.value = connectionRestored;

            final pref = await SharedPreferences.getInstance();
            await pref.setBool(PreferencesKeys.isConnected, true);
            Future.delayed(Duration(seconds: 5), () {
              _widgetSwitcher.value = defaultWidget;
            });
          });
        }
        if (connectionStatus == InternetConnectionStatus.disconnected) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final pref = await SharedPreferences.getInstance();
            await pref.setBool(PreferencesKeys.isConnected, false);
            Future.delayed(Duration(seconds: 5), () {
              _widgetSwitcher.value = noConnection;
            });
          });
        }

        return ValueListenableBuilder(
          valueListenable: _widgetSwitcher,
          builder: (context, value, child) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: Offset(0, -1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
              child: value,
            );
          },
        );
      },
    );
  }
}
