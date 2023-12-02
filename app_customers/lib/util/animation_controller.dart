import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'drawer_controller.dart';

/// Transform controller.
class CustomTransformer extends StatelessWidget {
  final Widget child;
  const CustomTransformer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final customDrawerController = Get.put(CustomDrawerController());

    return Obx(
      () => TweenAnimationBuilder(
        tween: Tween<double>(
          begin: 0,
          end: customDrawerController.value(),
        ),
        duration: const Duration(milliseconds: 500),
        builder: (_, val, __) {
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..setEntry(0, 3, val * 200)
              ..rotateY((pi / 11) * val),
            child: child,
          );
        },
      ),
    );
  }
}
