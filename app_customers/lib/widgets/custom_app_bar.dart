import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../themes/app_colors.dart';

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

    return Container(
      color: AppColors.darkGray,
      height: 80,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                  child: Icon(
                    Icons.sunny,
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
