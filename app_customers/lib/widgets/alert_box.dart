import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

/// Custom alert box.
class AlertBoxView extends StatelessWidget {
  /// The title of the alert box.
  final String title;

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
    required this.title,
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
    return Dialog(
      elevation: 0,
      backgroundColor: AppColors.transparent,
      child: Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(12)),
            ),
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    color: AppColors.purple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 16,
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
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: negativeBtnPressed ??
                              () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.purple,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(9)),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 8,
                        width: 8,
                      ),
                      if (positiveBtnText != null)
                        TextButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              positiveBtnText ?? '',
                              style: const TextStyle(
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onPressed: positiveBtnPressed,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.darkBlack,
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
          CircleAvatar(
            maxRadius: topSize ?? 40.0,
            backgroundColor: topBackgroundColor ?? AppColors.darkBlack,
            child: icon ?? Icon(Icons.message),
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
  required String title,
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
      barrierColor: AppColors.darkBlack.withOpacity(0.6),
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
