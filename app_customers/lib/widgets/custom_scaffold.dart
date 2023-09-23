import 'package:animation_wrappers/animations/faded_slide_animation.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: canPop
          ? AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              elevation: 0.0,
              leading: InkWell(
                child: Container(
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.appBarTheme.backgroundColor,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color:
                            theme.textTheme.titleSmall?.color ?? AppColors.gray,
                      ),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Icon(
                    size: 15,
                    Icons.arrow_back_ios,
                  ),
                ),
                onTap: () => Navigator.of(context).pop(),
              ),
            )
          : null,
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
                title != null
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          title ?? '',
                          style: TextStyle(
                            color: theme.appBarTheme.titleTextStyle?.color,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : SizedBox.shrink(),
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
