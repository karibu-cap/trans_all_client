import 'dart:async';

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
import 'themes/app_colors.dart';
import 'util/user_contact.dart';

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
  runApp(MyApp());
}

/// This is the main class of the app.
class MyApp extends StatelessWidget {
  final AppInternationalization _appInternationalization =
      AppInternationalization(Get.deviceLocale ?? Locale('en'));

  void _initGetProviders() {
    UserContactConfig.init();
    Get.lazyPut(() => _appInternationalization);
    Get.lazyPut(() => TransferRepository(HiveService(HiveServiceType.hive)));
    Get.lazyPut(() => ContactRepository(HiveService(HiveServiceType.hive)));
    Get.lazyPut(() => ForfeitRepository(HiveService(HiveServiceType.hive)));

    return;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    _initGetProviders();
    _streamPendingTransaction();

    return _BuildApp();
  }
}

class _BuildApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = Get.find<AppInternationalization>();

    return GetMaterialApp.router(
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
      translations: localization,
      locale: Get.deviceLocale,
      fallbackLocale: Locale('en', ''),
      builder: (context, child) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: AppBar(
              title: Text(localization.transAll),
              backgroundColor: AppColors.darkBlack,
            ),
          ),
          body: child,
        );
      },
    );
  }
}

void _streamPendingTransaction() {
  final Logger _logger = Logger('Schedule airtime transaction update');
  final TransferRepository transferRepository = Get.find<TransferRepository>();

  /// Schedule every 15 seconds.
  Timer.periodic(Duration(seconds: 15), (timer) async {
    /// Retrieve the pending  airtime transaction.
    final pendingTransaction =
        transferRepository.getAllLocalTransaction().where(
              (value) =>
                  (value.status.key == TransferStatus.waitingRequest.key &&
                      value.payments.first.status.key !=
                          PaymentStatus.failed.key) ||
                  value.status.key == TransferStatus.requestSend.key ||
                  value.payments.first.status.key == PaymentStatus.pending.key,
            );
    _logger.info(
      'There are ${pendingTransaction.length} transaction with pending status.',
    );
    if (pendingTransaction.isNotEmpty) {
      for (final transaction in pendingTransaction) {
        _logger.info(
          'the transaction id is ${transaction.id} are a '
          'transaction status ${transaction.status.key} and '
          'payment status ${transaction.payments.first.status.key}.',
        );

        /// Set to failed if the transaction status is pending since 1 week.
        final DateTime now = DateTime.now();
        final DateTime oneWeekAgo = now.subtract(Duration(days: 7));
        if (transaction.createdAt.isBefore(oneWeekAgo)) {
          _logger.info(
            'the transaction id ${transaction.id} with a '
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
          final canUpdate =
              (remoteTransaction?.status.key != transaction.status.key) ||
                  !(remoteTransaction?.payments.first.status.key ==
                          PaymentStatus.pending.key &&
                      (transaction.payments.last.status.key ==
                              PaymentStatus.pending.key ||
                          transaction.payments.last.status.key ==
                              PaymentStatus.initialized.key));
          if (remoteTransaction != null && canUpdate) {
            _logger.info(
              'New update of  transaction with id ${transaction.id} is received with data: ${remoteTransaction.toJson()}',
            );
            await transferRepository.updateLocalTransaction(
              transaction.id,
              remoteTransaction,
            );
          }
        }
      }
    }
  });
}
