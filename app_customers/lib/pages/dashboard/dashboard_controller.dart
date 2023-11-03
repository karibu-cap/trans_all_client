import 'package:flutter/material.dart';

import 'dashboard_view_model.dart';

/// Controller for the dashboard page.
class DashboardController extends ChangeNotifier {
  /// The dashboard view model.
  final DashboardViewModel dashboardViewModel;

  /// The duration.
  ValueNotifier<Duration> duration = ValueNotifier(
    Duration.zero,
  );

  /// Returns the active index.
  int get activeIndex => dashboardViewModel.activeIndex;

  /// Constructs a new [DashboardController].
  DashboardController({required this.dashboardViewModel});

  /// The handle press.
  void handlePress(
    int index,
  ) {
    dashboardViewModel.activeIndex = index;

    notifyListeners();
  }
}
