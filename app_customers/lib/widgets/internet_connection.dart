import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';

import '../themes/app_colors.dart';
import '../util/preferences_keys.dart';

/// Displays a message indicating the internet connection status.
class InternetConnectivityView extends StatelessWidget {
  /// Label of the message.
  final String noInternetConnectionLabel;

  /// Constructs an [InternetConnectivityView].
  InternetConnectivityView(this.noInternetConnectionLabel);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(InternetController());

    return StreamBuilder<InternetConnectionStatus>(
      stream: InternetConnectionCheckerPlus.createInstance().onStatusChange,
      builder: (context, snapshot) {
        final connectionStatus = snapshot.data;
        if (connectionStatus == null ||
            connectionStatus == InternetConnectionStatus.connected) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            final pref = await SharedPreferences.getInstance();
            await pref.setBool(PreferencesKeys.isConnected, true);
            controller.displayAnimation.value = false;
          });

          return SizedBox.shrink();
        }

        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final pref = await SharedPreferences.getInstance();
          await pref.setBool(PreferencesKeys.isConnected, false);
          Future.delayed(Duration(seconds: 5), () {
            controller.displayAnimation.value = true;
          });
        });

        return GetX<InternetController>(
          builder: (control) => !control.displayAnimation.value
              ? SizedBox.shrink()
              : MirrorAnimationBuilder<double>(
                  tween: Tween(begin: 0.2, end: 1.0),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOutSine,
                  builder: (context, value, _) {
                    return Container(
                      color: AppColors.red.withOpacity(value * 0.8),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              noInternetConnectionLabel,
                              style: TextStyle(
                                  color: AppColors.white, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        );
      },
    );
  }
}

/// The internet controller.
class InternetController extends GetxController {
  /// Checks if we can display the animation.
  Rx<bool> displayAnimation = false.obs;
}
