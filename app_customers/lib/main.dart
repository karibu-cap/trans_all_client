import 'dart:async';

import 'package:app_customer/util/drawer_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_utils/utils.dart';

import 'config/config.dart';
import 'data/database/hive_service.dart';
import 'data/repository/contactRepository.dart';
import 'data/repository/forfeitRepository.dart';
import 'data/repository/tranferRepository.dart';
import 'routes/app_router.dart';
import 'util/check_transaction.dart';
import 'util/themes.dart';
import 'util/user_contact.dart';
import 'widgets/contact_service_button/contact_service_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initFirebaseCoreAndCrashReporting();
  await Hive.initFlutter();
  await appConfig();

  await AppRouter.init(
    AppRouterType.gorouter,
  );

  await RemoteConfig.init(
    service: getAppConfigDefaults().remoteConfigType,
    defaults: getRemoteConfigDefaults(),
  );
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (kDebugMode && record.level == Level.SEVERE) {
      print(
          ' 🆘 🆘 🆘[${record.level.name}] ${record.time}: ${record.message}');
    }
    if (record.level == Level.INFO) {
      print(' ✅ ✅ ✅[${record.level.name}]: ${record.message}');
    }
    if (record.level == Level.WARNING) {
      print('🚸 🚸 🚸 🚸 [${record.level.name}]: ${record.message}');
    }
  });
  runApp(MyApp());
}

/// This is the main class of the app.
class MyApp extends StatelessWidget {
  final AppInternationalization _appInternationalization =
      AppInternationalization(Get.deviceLocale ?? Locale('en'));

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final hiveService = HiveService(HiveServiceType.hive);
    final appThemeData = ThemeManager();
    final drawerController = CustomDrawerController();

    void _initGetProviders() {
      UserContactConfig.init();
      Get.lazyPut(() => _appInternationalization);
      Get.lazyPut(() => TransferRepository(hiveService));
      Get.lazyPut(() => ContactRepository(hiveService));
      Get.lazyPut(() => ForfeitRepository(hiveService));
      Get.lazyPut(() => appThemeData);
      Get.lazyPut(ContactServiceModel.new);
      Get.lazyPut(CustomDrawerController.new);

      return;
    }

    _initGetProviders();
    streamPendingTransaction();

    return _BuildApp();
  }
}

class _BuildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeManager>(
      builder: (controller) => GetMaterialApp.router(
        debugShowCheckedModeBanner: false,
        routeInformationProvider: AppRouter.getRouteInformationProvider(),
        routerDelegate: AppRouter.getRouterDelegate(),
        routeInformationParser: AppRouter.getRouteInformationParser(),
        backButtonDispatcher: AppRouter.getBackButtonDispatcher(),
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppInternationalization.supportedLocales,
        title: EnvironmentConfig.appName,
        translations: AppInternationalization(Get.deviceLocale ?? Locale('en')),
        locale: Get.deviceLocale,
        fallbackLocale: Locale('en', ''),
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: controller.themeMode,
      ),
    );
  }
}
