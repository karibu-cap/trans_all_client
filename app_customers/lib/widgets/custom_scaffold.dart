import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
    final canPop = AppRouter.canPop(context);
    final localization = Get.find<AppInternationalization>();

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          title: Text(localization.transAll),
          backgroundColor: AppColors.darkGray,
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 750),
            child: Column(
              children: [
                if (displayInternetMessage)
                  FadedSlideAnimation(
                    beginOffset: Offset(0, -0.3),
                    endOffset: Offset(0, 0),
                    slideCurve: Curves.linearToEaseOut,
                    child: displayInternetMessage
                        ? InternetConnectivityView()
                        : SizedBox.shrink(),
                  ),
                SizedBox(
                  height: 7,
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
