import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

import '../../themes/app_colors.dart';
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

  _DashboardPage(
    this.navigationBarItem,
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

    pages.add(_DashboardPage(
      _createCreditTransferPageNavigationBarItem(localizations),
    ));
    // pages.add(_DashboardPage(
    //   DashboardPageType.moneyTransaction,
    //   _createMoneyTransferPageNavigationBarItem(localizations),
    //   PagesRoutes.moneyTransaction.pattern,
    //   MoneyTransferView(),
    // ));

    pages.add(_DashboardPage(
      _createHistoricPageNavigationBarItem(localizations),
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
  final List<_DashboardPage> pages;
  final StatefulNavigationShell navigationShell;

  _DashboardBody({
    required this.pages,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    // SchedulerBinding.instance.addPostFrameCallback((_) {
    //   controller.updateActiveIndex(currentIndex);
    // });

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
      bottomNavigationBar: CustomAnimatedBottomBar(
        containerHeight: 70,
        selectedIndex: navigationShell.currentIndex,
        showElevation: true,
        itemCornerRadius: 40,
        curve: Curves.easeIn,
        onItemSelected: handlePress,
        items: pages.map((e) => e.navigationBarItem).toList(),
      ),
      floatingActionButton: Stack(children: [
        Container(
          height: 70,
        ),
        Positioned(
          top: 0,
          width: MediaQuery.of(context).size.width,
          child: ConvexButton.fab(
            onTap: () => Share.share(
              'https://play.google.com/store/apps/details?id=com.karibu.transtu.prod',
            ),
            backgroundColor: AppColors.darkBlack,
            icon: Icons.share,
            color: AppColors.white,
            border: 0,
            thickness: 0,
            sigma: 0,
            top: 45,
            size: 52,
            iconSize: 35,
          ),
        ),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: navigationShell,
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

BottomNavyBarItem _createMoneyTransferPageNavigationBarItem(
  AppInternationalization localizations,
) {
  return _createNavigationBarItem(
    Icon(Icons.attach_money),
    localizations.moneyTransfer,
    AppColors.green,
  );
}
