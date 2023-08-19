import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../../routes/app_router.dart';
import '../../routes/pages_routes.dart';
import '../../themes/app_button_styles.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../util/preferences_keys.dart';

/// The welcome view.
class WelcomeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localizations = Get.find<AppInternationalization>();

    return Scaffold(
      backgroundColor: AppColors.darkBlack,
      body: Stack(
        children: [
          Container(
            color: AppColors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PlayAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    curve: Curves.easeIn,
                    duration: const Duration(seconds: 2),
                    builder: (context, value, child) {
                      return Opacity(
                        opacity: value,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image(
                              image:
                                  AssetImage('assets/icons/transTu_dark.png'),
                              height: value * 200,
                            ),
                            Text(
                              localizations.appName,
                              style: AppTextStyles.commonTitleLabel.copyWith(
                                color: AppColors.darkBlack,
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text(
                              localizations.welcome,
                              style: AppTextStyles.commonTitleLabel.copyWith(
                                color: AppColors.darkBlack,
                                fontSize: 16,
                                height: 2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: PlayAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: Duration(seconds: 1),
                curve: Curves.easeOut,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: ElevatedButton(
                      style: roundedBigButton(
                        context,
                        AppColors.darkBlack,
                        AppColors.darkBlack,
                      ),
                      onPressed: () async {
                        final pref = await SharedPreferences.getInstance();
                        await pref.setBool(
                            PreferencesKeys.isFirstOpenWelcomeScreen, false);
                        AppRouter.go(
                          context,
                          PagesRoutes.creditTransaction.pattern,
                        );
                      },
                      child: Text(
                        localizations.getStart,
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
                delay: Duration(milliseconds: 500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
