import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../util/preferences_keys.dart';

/// The [ContactServiceModel].
class ContactServiceModel extends GetxController {
  /// Checks if we can display tooltip message.
  bool displayTooltip = true;

  /// The top position.
  double top = -1;

  /// The left position.
  double left = -1;

  /// Is in dragging state.
  bool isDragging = false;

  /// The auto align.
  final bool autoAlign = true;

  /// The auto align.
  bool isRemoved = false;

  /// The floating widget width.
  final double floatingWidgetWidth = 60;

  /// The floating widget height.
  final double floatingWidgetHeight = 60;

  /// The on button collapsed.
  Future<bool> onButtonCollapsed() async {
    final pref = await SharedPreferences.getInstance();

    return pref.getBool(
          PreferencesKeys.isCustomerServiceFloatingButtonCollapsed,
        ) ??
        false;
  }

  bool _hasCollision(
    GlobalKey<State<StatefulWidget>> key1,
    GlobalKey<State<StatefulWidget>> key2,
  ) {
    final RenderBox? box1 =
        key1.currentContext?.findRenderObject() as RenderBox?;
    final RenderBox? box2 =
        key2.currentContext?.findRenderObject() as RenderBox?;
    if (box1 == null || box2 == null) {
      return false;
    }
    final pos1 = box1.localToGlobal(Offset.zero);
    final pos2 = box2.localToGlobal(Offset.zero);

    final size1 = box1.size;
    final size2 = box2.size;

    final left = pos1.dx < pos2.dx + size2.width;
    final right = pos1.dx + size1.width > pos2.dx;
    final top = pos1.dy < pos2.dy + size2.height;
    final bottom = pos1.dy + size1.height > pos2.dy;

    return left && right && top && bottom;
  }

  /// On draggable start.
  void onPanStart() {
    isDragging = true;
    update();
  }

  /// On draggable update.
  void onPanUpdate({
    required DragUpdateDetails details,
    required BuildContext context,
  }) {
    top = _getDy(
      details.globalPosition.dy,
      MediaQuery.of(context).size.height,
    );
    left = _getDx(details.globalPosition.dx, MediaQuery.of(context).size.width);

    if (autoAlign && !isDragging) {
      final width = MediaQuery.of(context).size.width;
      left = left >= width / 2 ? width - floatingWidgetWidth : 0;
    }
    update();
  }

  /// On draggable end.
  Future<void> onPanEnd({
    required DragEndDetails details,
    required BuildContext context,
    required GlobalKey floatingWidgetKey,
    required GlobalKey deleteWidgetKey,
  }) async {
    isDragging = false;

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    final velocity = details.velocity.pixelsPerSecond;

    left = _getDx(left + velocity.dx / 50.0, width);
    top = _getDy(top + velocity.dy / 50.0, height);

    if (autoAlign) {
      left = left >= width / 2 ? width - floatingWidgetWidth : 0;
    }

    final isColliding = _hasCollision(deleteWidgetKey, floatingWidgetKey);
    if (isColliding) {
      await _disableFloatingButton();
    }
    update();
  }

  Future<void> _disableFloatingButton() async {
    final pref = await SharedPreferences.getInstance();
    await pref.setBool(
      PreferencesKeys.isCustomerServiceFloatingButtonCollapsed,
      true,
    );
  }

  double _getDy(double dy, double height) {
    return dy
        .clamp(
          floatingWidgetHeight,
          height - floatingWidgetHeight,
        )
        .toDouble();
  }

  double _getDx(double dx, double width) {
    return dx.clamp(1, width - floatingWidgetWidth);
  }

  /// Cancels displaying of the tooltip button.
  void cancelDisplayOfTooltip() {
    displayTooltip = false;
    update();
  }
}
