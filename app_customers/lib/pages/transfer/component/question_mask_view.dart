import 'package:flutter/material.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';

/// Question mask view.
class QuestionMaskView extends StatelessWidget {
  /// The index of the question overlay.
  final int index;

  /// Constructor of new [QuestionMaskView].
  const QuestionMaskView({required this.index});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: 15,
      width: 15,
      child: InkWell(
        child: CircleAvatar(
          backgroundColor: theme.primaryColor,
          child: Icon(
            size: 10,
            Icons.question_mark,
            color: theme.scaffoldBackgroundColor,
          ),
        ),
        onTap: () =>
            OverlayTooltipScaffold.of(context)?.controller.start(index),
      ),
    );
  }
}
