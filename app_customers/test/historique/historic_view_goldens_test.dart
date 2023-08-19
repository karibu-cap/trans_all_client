import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/historiques_transaction/history_view.dart';
import 'package:app_customer/routes/app_page.dart';
import 'package:app_customer/routes/pages_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

class HistoryViewWidget extends StatelessWidget {
  final Locale locale;

  HistoryViewWidget({required this.locale});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppInternationalization(locale));
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    initializeDateFormatting(locale.countryCode);
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));

    final routerProvider = GoRouter(
      initialLocation: PagesRoutes.historic.pattern,
      routes: <RouteBase>[
        GoRoute(
          path: PagesRoutes.historic.pattern,
          builder: (context, state) => AppPage(
            child: HistoryView(displayInternetMessage: false),
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
    testGoldens('history us view', (tester) async {
      await tester
          .pumpWidgetBuilder(HistoryViewWidget(locale: Locale('en', 'US')));
      await multiScreenGolden(tester, 'history_us_view');
    });
    testGoldens('history fr view', (tester) async {
      await tester
          .pumpWidgetBuilder(HistoryViewWidget(locale: Locale('fr', 'FR')));
      await multiScreenGolden(tester, 'history_fr_view_fr');
    });
  });
}
