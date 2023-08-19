import 'package:app_customer/data/database/hive_service.dart';
import 'package:app_customer/data/repository/contactRepository.dart';
import 'package:app_customer/data/repository/tranfersRepository.dart';
import 'package:app_customer/pages/transfer/transfer_view.dart';
import 'package:app_customer/routes/app_page.dart';
import 'package:app_customer/routes/pages_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

class CreditTransferViewWidget extends StatelessWidget {
  final Locale locale;

  CreditTransferViewWidget({required this.locale});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => AppInternationalization(locale));
    Get.put(TransferRepository(HiveService(HiveServiceType.fake)));
    Get.put(ContactRepository(HiveService(HiveServiceType.fake)));
    final routerProvider = GoRouter(
      initialLocation: PagesRoutes.creditTransaction.pattern,
      routes: <RouteBase>[
        GoRoute(
          path: PagesRoutes.creditTransaction.pattern,
          builder: (context, state) => AppPage(
            child: TransfersView(displayInternetMessage: false),
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
    testGoldens('Credit Transfer us view', (tester) async {
      await tester
          .pumpWidget(CreditTransferViewWidget(locale: Locale('en', 'US')));
      await multiScreenGolden(tester, 'credit_transfer_us_view');
    });

    testGoldens('Credit Transfer fr view', (tester) async {
      await tester
          .pumpWidget(CreditTransferViewWidget(locale: Locale('fr', 'FR')));
      await multiScreenGolden(tester, 'credit_transfer_fr_view_fr');
    });
  });
}
