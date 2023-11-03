import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Custom alert box.
class AlertBoxView extends StatelessWidget {
  /// The title of the alert box.
  final String? title;

  /// The positive Btn Text.
  final String? positiveBtnText;

  /// The negative Btn Text.
  final String? negativeBtnText;

  /// The content of the alert box.
  final Widget content;

  /// The action on positive button pressed.
  final GestureTapCallback? positiveBtnPressed;

  /// The action on negative button pressed.
  final GestureTapCallback? negativeBtnPressed;

  /// The icon to display on top.
  final Icon? icon;

  /// Icon top background color.
  final Color? topBackgroundColor;

  /// Icon top size.
  final double? topSize;

  /// Constructor of new [ContactTextFieldForm].
  const AlertBoxView({
    super.key,
    this.title,
    required this.content,
    this.positiveBtnText,
    this.negativeBtnText,
    this.positiveBtnPressed,
    this.negativeBtnPressed,
    this.icon,
    this.topBackgroundColor,
    this.topSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: theme.dialogBackgroundColor,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.only(top: 40, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      title ?? '',
                      style: const TextStyle(
                        fontSize: 17,
                        color: AppColors.purple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                content,
                FittedBox(
                  child: ButtonBar(
                    buttonMinWidth: 100,
                    children: <Widget>[
                      if (negativeBtnText != null)
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              negativeBtnText ?? '',
                            ),
                          ),
                          onPressed: negativeBtnPressed ??
                              () => Navigator.of(context).pop(),
                        ),
                      SizedBox(
                        height: 8,
                        width: 8,
                      ),
                      if (positiveBtnText != null)
                        FilledButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              positiveBtnText ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: positiveBtnPressed,
                          style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9)),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 70,
            child: CircleAvatar(
              maxRadius: topSize ?? 40.0,
              backgroundColor: theme.primaryColor,
              child: icon ??
                  Icon(
                    Icons.message,
                    color: AppColors.white,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Display the alert box view.
void showAlertBoxView({
  required BuildContext context,
  String? positiveBtnText,
  String? negativeBtnText,
  String? title,
  required Widget content,
  GestureTapCallback? positiveBtnPressed,
  GestureTapCallback? negativeBtnPressed,
  Icon? icon,
  Color? topBackgroundColor,
  double? topSize,
}) =>
    showGeneralDialog(
      barrierDismissible: false,
      context: context,
      barrierColor: AppColors.darkGray.withOpacity(0.6),
      transitionDuration: Duration(milliseconds: 700),
      transitionBuilder: (context, a1, a2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: a1,
            curve: Curves.elasticOut,
            reverseCurve: Curves.easeOutCubic,
          ),
          child: AlertBoxView(
            title: title,
            icon: icon,
            content: content,
            positiveBtnText: positiveBtnText,
            negativeBtnText: negativeBtnText,
            positiveBtnPressed: positiveBtnPressed,
            negativeBtnPressed: negativeBtnPressed,
            topBackgroundColor: topBackgroundColor,
            topSize: topSize,
          ),
        );
      },
      pageBuilder: (context, animation, secondaryAnimation) {
        return SizedBox();
      },
    );
