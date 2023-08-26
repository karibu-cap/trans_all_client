import 'package:app_customer/config/environement_conf.dart';
import 'package:app_customer/routes/app_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';

/// Generates a screenshot of the widget in the original locale.
/// Then generates the screenshot for each additional locale.
Future<void> multiScreenMultiLocaleGolden(
  WidgetTester tester,
  Widget widget,
  String name,
) async {
  final AppInternationalization _appInternationalization =
      AppInternationalization(Get.deviceLocale ?? Locale('en'));

  Get.lazyPut(() => _appInternationalization);

  // Wrap the widget with the localization provider.

  final routerProvider = GoRouter(
    initialLocation: '/defaultRoute',
    routes: <RouteBase>[
      GoRoute(
        path: '/defaultRoute',
        builder: (context, state) => AppPage(
          child: widget,
        ),
      ),
    ],
  );

  await tester.pumpWidgetBuilder(GetMaterialApp.router(
    routerDelegate: routerProvider.routerDelegate,
    routeInformationParser: routerProvider.routeInformationParser,
    routeInformationProvider: routerProvider.routeInformationProvider,
    backButtonDispatcher: routerProvider.backButtonDispatcher,
    debugShowCheckedModeBanner: false,
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: AppInternationalization.supportedLocales,
    title: AppEnvironment.appName,
    translations: AppInternationalization(Get.deviceLocale ?? Locale('en')),
    locale: Get.deviceLocale,
    fallbackLocale: Locale('en', ''),
  ));

  // // Screenshot the widget in each supported locale.
  for (final locale in AppInternationalization.supportedLocales) {
    _appInternationalization.setLocale(locale);
    await tester.pumpAndSettle();
    await multiScreenGolden(tester, '$name.${locale.languageCode}');
  }
}
