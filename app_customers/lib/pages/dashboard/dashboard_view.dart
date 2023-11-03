import 'dart:math';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../../themes/app_colors.dart';
import '../../util/drawer_controller.dart';
import '../../widgets/custum_bottom_nav.dart';

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
  final BottomNavyBarItem navigationBarItem;
  final IconData iconData;
  final String title;

  _DashboardPage(
    this.navigationBarItem,
    this.iconData,
    this.title,
  );
}

/// Provides a navigation bar with various pages of the application.
class DashboardView extends StatelessWidget {
  /// The navigation shell and container for the branch Navigators.
  final StatefulNavigationShell navigationShell;

  /// Constructs a new [DashboardView].
  const DashboardView({
    required this.navigationShell,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  List<_DashboardPage> _initializePages(
    AppInternationalization localizations,
  ) {
    final List<_DashboardPage> pages = [];

    pages.add(
      _DashboardPage(
        _createCreditTransferPageNavigationBarItem(localizations),
        Icons.swap_horiz,
        localizations.airtime,
      ),
    );

    pages.add(_DashboardPage(
      _createHistoricPageNavigationBarItem(localizations),
      Icons.history,
      localizations.history,
    ));

    return pages;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = Get.find<AppInternationalization>();
    final pages = _initializePages(localizations);

    return _DashboardBody(
      pages: pages,
      navigationShell: navigationShell,
    );
  }
}

class _DashboardBody extends StatelessWidget {
  final autoSizeGroup = AutoSizeGroup();
  final List<_DashboardPage> pages;
  final StatefulNavigationShell navigationShell;
  bool isTransforming = false;

  _DashboardBody({
    required this.pages,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final localizations = Get.find<AppInternationalization>();
    final customDrawerController = Get.find<CustomDrawerController>();
    void handlePress(
      int index,
    ) {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }

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
          backgroundColor: theme.floatingActionButtonTheme.backgroundColor,
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
      body: SafeArea(bottom: false, child: navigationShell),
    );
  }
}

BottomNavyBarItem _createNavigationBarItem(
  Widget icon,
  String label,
  Color activeColor,
) {
  return BottomNavyBarItem(
    icon: icon,
    title: label,
    activeColor: activeColor,
    inactiveColor: AppColors.gray.withOpacity(0.4),
    textAlign: TextAlign.center,
  );
}

BottomNavyBarItem _createCreditTransferPageNavigationBarItem(
  AppInternationalization localizations,
) {
  return _createNavigationBarItem(
    Icon(Icons.swap_horiz),
    localizations.airtime,
    AppColors.white,
  );
}

BottomNavyBarItem _createHistoricPageNavigationBarItem(
  AppInternationalization localizations,
) {
  return _createNavigationBarItem(
    Icon(Icons.history),
    localizations.history,
    AppColors.white,
  );
}
