import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Controller for the dashboard page.
class DashboardController extends GetxController {
  /// The duration.
  ValueNotifier<Duration> duration = ValueNotifier(
    Duration.zero,
  );

  /// Returns the active navigation page index.
  Rx<int> activeIndex = 0.obs;

  /// Updates the active index.
  void updateActiveIndex(int index) {
    activeIndex.value = index;
  }

  /// Constructs a new [DashboardController].
  DashboardController();
}
