import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../../routes/pages_routes.dart';
import '../../themes/app_colors.dart';
import '../../util/drawer_controller.dart';
import '../../widgets/custum_bottom_nav.dart';
import '../historiques_transaction/history_view.dart';
import '../transfer/transfer_view.dart';
import 'dashboard_controller.dart';
import 'dashboard_view_model.dart';

/// The dashboard page types.
enum DashboardPageType {
  /// The credit transfer tab.
  creditTransaction,

  /// The money transfer tab.
  moneyTransaction,

  /// The historic tab.
  historical,
}

class _DashboardPage {
  final IconData iconData;
  final Widget child;
  final String title;
  final DashboardPageType dashboardPageType;

  _DashboardPage({
    required this.iconData,
    required this.child,
    required this.title,
    required this.dashboardPageType,
  });
}

/// The additional data of each page.
class AdditionalData {
  /// The local credit transaction.
  final CreditTransactionParams? localCreditTransaction;

  /// Check if we can display internet message of the app bar.
  final bool? displayInternetMessage;

  /// Constructs a new [AdditionalData].
  AdditionalData({
    this.localCreditTransaction,
    this.displayInternetMessage,
  });
}

/// Provides a navigation bar with various pages of the application.
class DashboardView extends StatelessWidget {
  /// The dashboard page types.
  final DashboardPageType dashboardPageType;

  /// The additional data of each page.
  final AdditionalData? additionalData;

  /// Constructs a new [DashboardView].
  const DashboardView({
    required this.dashboardPageType,
    this.additionalData,
    Key? key,
  }) : super(key: key);

  List<_DashboardPage> _initializePages(
    AppInternationalization localizations,
  ) {
    final List<_DashboardPage> pages = [];

    pages.add(
      _DashboardPage(
        iconData: Icons.swap_horiz,
        title: localizations.airtime,
        child: TransfersView(
          displayInternetMessage: additionalData?.displayInternetMessage,
          localCreditTransaction: additionalData?.localCreditTransaction,
        ),
        dashboardPageType: DashboardPageType.creditTransaction,
      ),
    );
    pages.add(
      _DashboardPage(
        iconData: Icons.history,
        title: localizations.history,
        child: HistoryView(),
        dashboardPageType: DashboardPageType.historical,
      ),
    );

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = Get.find<AppInternationalization>();
    final pages = _initializePages(localizations);
    final currentIndex = pages
        .indexWhere(
          (page) => page.dashboardPageType == dashboardPageType,
        )
        .clamp(0, pages.length - 1);

    final DashboardViewModel dashboardViewModel =
        DashboardViewModel(activeIndex: currentIndex);
    final controller =
        DashboardController(dashboardViewModel: dashboardViewModel);

    return ChangeNotifierProvider.value(
      value: controller,
      child: _DashboardBody(
        pages: pages,
        dashboardPageType: dashboardPageType,
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final autoSizeGroup = AutoSizeGroup();
  final List<_DashboardPage> pages;
  final StatefulNavigationShell navigationShell;
  bool isTransforming = false;
  final DashboardPageType dashboardPageType;

  _DashboardBody({
    required this.pages,
    required this.dashboardPageType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = Get.find<AppInternationalization>();

    /// variable for drawer control
    final customDrawerController = Get.find<CustomDrawerController>();
    void handlePress(
      int index,
    ) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
    final controller = context.watch<DashboardController>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      bottomNavigationBar: Obx(
        () => TweenAnimationBuilder(
          tween: Tween<double>(
            begin: 0,
            end: customDrawerController.value.toDouble(),
          ),
          duration: const Duration(milliseconds: 500),
          builder: (_, val, __) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..setEntry(0, 3, val * 200)
                ..rotateY((pi / 11) * val),
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 12,
                      spreadRadius: 0.5,
                      color: AppColors.black,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(
                      customDrawerController.raduis.toDouble(),
                    ),
                  ),
                  child: TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: 0,
                      end: customDrawerController.value.toDouble(),
                    ),
                    duration: const Duration(milliseconds: 500),
                    builder: (_, val, __) {
                      return AnimatedBottomNavigationBar.builder(
                        itemCount: pages.length,
                        tabBuilder: ((index, isActive) {
                          final color = isActive
                              ? theme.bottomNavigationBarTheme.selectedItemColor
                              : theme
                                  .bottomNavigationBarTheme.unselectedItemColor;

                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                pages[index].iconData,
                                size: 24,
                                color: color,
                              ),
                              const SizedBox(height: 4),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: AutoSizeText(
                                  pages[index].title,
                                  maxLines: 1,
                                  style: TextStyle(color: color),
                                  group: autoSizeGroup,
                                ),
                              ),
                            ],
                          );
                        }),
                        height: 80,
                        splashSpeedInMilliseconds: 300,
                        backgroundColor: theme.bottomAppBarTheme.color,
                        activeIndex: navigationShell.currentIndex,
                        gapLocation: GapLocation.end,
                        notchSmoothness: NotchSmoothness.defaultEdge,
                        onTap: handlePress,
                        shadow: BoxShadow(
                          offset: Offset(0, 1),
                          blurRadius: 12,
                          spreadRadius: 0.5,
                          color: AppColors.black,
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
            ],
          );
        }),
        height: 80,
        splashSpeedInMilliseconds: 300,
        backgroundColor: theme.bottomAppBarTheme.color,
        activeIndex: controller.activeIndex,
        gapLocation: GapLocation.end,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: controller.handlePress,
        shadow: BoxShadow(
          offset: Offset(0, 1),
          blurRadius: 12,
          spreadRadius: 0.5,
          color: AppColors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Obx(
        () => TweenAnimationBuilder(
          tween: Tween<double>(
            begin: 0,
            end: customDrawerController.value.toDouble(),
          ),
          duration: const Duration(milliseconds: 500),
          builder: (_, val, __) {
            return Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..setEntry(0, 3, val * 200)
                ..rotateY((pi / 11) * val),
              child: FloatingActionButton(
                backgroundColor:
                    theme.floatingActionButtonTheme.backgroundColor,
                child: Icon(
                  Icons.share,
                ),
                onPressed: () => Share.share(
                  '${localizations.shareTransAllLinkMessage} https://play.google.com/store/apps/details?id=com.karibu.transtu.prod',
                ),
              ),
            );
          },
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: IndexedStack(
          index: controller.activeIndex,
          children: pages.map((e) => e.child).toList(),
        ),
      ),
    );
  }
}
