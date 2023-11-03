import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../../util/drawer_controller.dart';
import '../themes/app_colors.dart';
import '../util/themes.dart';

/// The custom app bar widget.
class CustomAppBar extends StatelessWidget {
  /// The child widget.
  final Widget child;

  /// Disable superposition.
  final bool disableSuperposition;

  /// Construct a new custom app bar.
  const CustomAppBar({
    super.key,
    required this.child,
    this.disableSuperposition = false,
  });

  @override
  Widget build(BuildContext context) {
    if (disableSuperposition) {
      return Expanded(
        child: Column(
          children: [
            _AppBarWidget(),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Stack(
      children: [
        SizedBox(
          height: 120,
        ),
        _AppBarWidget(),
        SizedBox(
          height: 20,
        ),
        Positioned(
          top: 50,
          child: Container(
            height: 80,
            width: MediaQuery.of(context).size.width,
            constraints: BoxConstraints(maxWidth: 750),
            child: Center(child: child),
          ),
        ),
      ],
    );
  }
}

class _AppBarWidget extends StatelessWidget {
  const _AppBarWidget();

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final addThemeData = Get.find<ThemeManager>();
    final theme = Theme.of(context);
    final customDrawerController = Get.find<CustomDrawerController>();
    int clickCount = 0;

  // function for display or close drawer with the button
    void showDrawer() {
      if (clickCount == 0) {
        customDrawerController.updateValue(1);
        clickCount = 1;
      } else if (clickCount == 1) {
        customDrawerController.updateValue(0);
        clickCount = 0;
      }
    }

    return Obx(
      () => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(customDrawerController.raduis.toDouble()),
          ),
          color: theme.appBarTheme.backgroundColor,
        ),
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: showDrawer,
                child: Icon(
                  Icons.menu,
                  color: AppColors.white,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    localization.appName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      fontSize: 19,
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (addThemeData.themeMode == ThemeMode.dark) {
                        addThemeData.updateCurrentTheme(ThemeMode.light);
                      } else {
                        addThemeData.updateCurrentTheme(ThemeMode.dark);
                      }
                    },
                    child: Icon(
                      addThemeData.themeMode != ThemeMode.dark
                          ? Icons.nightlight_round
                          : Icons.sunny,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
