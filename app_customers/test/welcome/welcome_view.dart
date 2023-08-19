import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/welcome/welcome_view.dart';
import 'package:app_customer/routes/app_page.dart';
import 'package:app_customer/routes/pages_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

class WelcomeViewWidget extends StatelessWidget {
  final Locale locale;

  WelcomeViewWidget({required this.locale});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppInternationalization(locale));
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    initializeDateFormatting(locale.countryCode);
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));

    final routerProvider = GoRouter(
      initialLocation: PagesRoutes.welcome.pattern,
      routes: <RouteBase>[
        GoRoute(
          path: PagesRoutes.welcome.pattern,
          builder: (context, state) => AppPage(
            child: WelcomeView(),
          ),
        ),
      ],
    );

    return GetMaterialApp.router(
      routerDelegate: routerProvider.routerDelegate,
      routeInformationParser: routerProvider.routeInformationParser,
      routeInformationProvider: routerProvider.routeInformationProvider,
      backButtonDispatcher: routerProvider.backButtonDispatcher,
      debugShowCheckedModeBanner: false,
      locale: locale,
      fallbackLocale: Locale('en', 'US'),
      translations: AppInternationalization(locale),
    );
  }
}

void main() {
  group('Goldens', () {
    testGoldens('welcome us view', (tester) async {
      await tester
          .pumpWidgetBuilder(WelcomeViewWidget(locale: Locale('en', 'US')));
      await multiScreenGolden(tester, 'welcome_us_view');
    });
    testGoldens('welcome fr view', (tester) async {
      await tester
          .pumpWidgetBuilder(WelcomeViewWidget(locale: Locale('fr', 'FR')));
      await multiScreenGolden(tester, 'welcome_fr_view_fr');
    });
  });
}
