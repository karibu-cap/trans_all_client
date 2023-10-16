import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_config/config.dart';
import 'package:trans_all_common_internationalization/internationalization.dart';
import 'package:trans_all_common_models/models.dart';
import 'package:trans_all_common_utils/utils.dart';

import 'config/config.dart';
import 'config/environement_conf.dart';
import 'data/database/hive_service.dart';
import 'data/repository/contactRepository.dart';
import 'data/repository/forfeitRepository.dart';
import 'data/repository/tranfersRepository.dart';
import 'routes/app_router.dart';
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

    void _initGetProviders() {
      UserContactConfig.init();
      Get.lazyPut(() => _appInternationalization);
      Get.lazyPut(() => TransferRepository(hiveService));
      Get.lazyPut(() => ContactRepository(hiveService));
      Get.lazyPut(() => ForfeitRepository(hiveService));
      Get.lazyPut(() => appThemeData);
      Get.lazyPut(ContactServiceModel.new);

      return;
    }

    _initGetProviders();
    _streamPendingTransaction();

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
        title: AppEnvironment.appName,
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

Future<void> _streamPendingTransaction() async {
  final Logger _logger = Logger('Schedule airtime transaction update');
  final TransferRepository transferRepository = Get.find<TransferRepository>();

  /// Schedule every 15 seconds.
  Timer.periodic(Duration(seconds: 15), (timer) async {
    /// Retrieve the pending  airtime transaction.
    final pendingTransaction =
        transferRepository.getAllLocalTransaction().where(
              (value) =>
                  value.status.key != TransferStatus.completed.key &&
                  value.status.key != TransferStatus.succeeded.key &&
                  value.status.key != TransferStatus.failed.key &&
                  value.status.key != TransferStatus.paymentFailed.key &&
                  value.payments.first.status.key != PaymentStatus.failed.key,
            );
    _logger.info(
      'There are ${pendingTransaction.length} transaction with pending status.',
    );
    if (pendingTransaction.isNotEmpty) {
      for (final transaction in pendingTransaction) {
        _logger.info(
          'the transaction id ${transaction.id} have a '
          'transfer status ${transaction.status.key} and '
          'payment status ${transaction.payments.first.status.key}.',
        );

        /// Set to failed if the transaction status is pending since 1 week.
        if (transaction.isOlderThanAWeek()) {
          _logger.info(
            'the transaction id ${transaction.id} have a '
            'transaction status ${transaction.status.key} and '
            'payment status ${transaction.payments.first.status.key} is passed '
            '1 week; the transaction will be set to failed.',
          );
          await transferRepository.updateLocalTransactionStatus(
            transaction.id,
            TransferStatus.failed.key,
            false,
          );
        } else {
          final remoteTransaction = await transferRepository.getTheTransaction(
            transactionId: transaction.id,
          );

          if (remoteTransaction != null) {
            _logger.info(
              'New update of  transaction with id ${transaction.id} is received with data: ${remoteTransaction.toJson()}',
            );
            final newTransfer = TransferInfo.fromJson(
              json: {
                ...remoteTransaction.toJson(),
                TransferInfo.keyForfeitReference: transaction.forfeitReference,
              },
            );
            await transferRepository.updateLocalTransaction(
              transaction.id,
              newTransfer,
            );
          }
        }
      }
    }
  });
}
