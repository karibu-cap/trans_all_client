import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

import '../../../themes/app_colors.dart';

/// Question mask view.
class QuestionMaskView extends StatelessWidget {
  /// The index of the question overlay.
  final int index;

  /// Constructor of new [QuestionMaskView].
  const QuestionMaskView({required this.index});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: 15,
      child: InkWell(
        child: CircleAvatar(
          backgroundColor: AppColors.purple,
          child: Icon(
            size: 10,
            Icons.question_mark,
            color: AppColors.white,
          ),
        ),
        onTap: () =>
            OverlayTooltipScaffold.of(context)?.controller.start(index),
      ),
    );
  }
}
