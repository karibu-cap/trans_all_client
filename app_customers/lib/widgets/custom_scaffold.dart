import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../routes/app_router.dart';
import '../themes/app_colors.dart';
import 'internet_connection.dart';

/// The custom scaffold widget.
class CustomScaffold extends StatelessWidget {
  /// The first child of the silver list view.
  final Widget child;

  /// The leading widget of app bar.
  final Widget? leadingAppBar;

  /// The title of the app bar.
  final String? title;

  /// Check if we can display internet message of the app bar.
  final bool displayInternetMessage;

  /// Construct new custom scaffold.
  const CustomScaffold({
    Key? key,
    this.leadingAppBar,
    this.displayInternetMessage = true,
    this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();
    final canPop = AppRouter.canPop(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: canPop
          ? AppBar(
              backgroundColor: AppColors.white,
              elevation: 0.0,
              leading: InkWell(
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: const Border.fromBorderSide(
                      BorderSide(color: AppColors.lightGray),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Icon(
                    size: 15,
                    Icons.arrow_back_ios,
                    color: AppColors.black,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            )
          : null,
      body: SafeArea(
        bottom: false,
        top: true,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 750),
            child: Column(
              children: [
                FadedSlideAnimation(
                  beginOffset: Offset(0, -0.3),
                  endOffset: Offset(0, 0),
                  slideCurve: Curves.linearToEaseOut,
                  child: displayInternetMessage
                      ? InternetConnectivityView(
                          localization.noInternetConnection,
                        )
                      : SizedBox.shrink(),
                ),
                SizedBox(
                  height: 20,
                ),
                title != null
                    ? Text(
                        title ?? '',
                        style: TextStyle(
                          color: AppColors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : SizedBox(),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
