import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:karibu_core_crash_reporting/crash_reporting.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils.dart';

/// Initializes the firebase core sdk.
Future<void> initFirebaseCore() async {
  await Future<void>.microtask(WidgetsFlutterBinding.ensureInitialized);
  final environment = EnvironmentCommon.environment.isEmpty
      ? 'dev'
      : EnvironmentCommon.environment;
  await Future<void>.value(Firebase.initializeApp(
    options: FirebaseOptionsInterface.create(environment).getOptions(),
  ));
}

/// Initializes the crash reporting package.
Future<void> initFirebaseCoreAndCrashReporting() async {
  await initFirebaseCore();
  CrashReporting.init(service: CrashReporterType.firebase);
  final packageInfo = await PackageInfo.fromPlatform();
  final packageName = packageInfo.packageName;
  final version = packageInfo.version;
  final build = packageInfo.buildNumber;
  // Log all messages in the format 'level: name: message'.
  // Eventually we may choose the log level based on the build
  // type (debug vs. release).
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    if (record.level == Level.SEVERE) {
      CrashReporting()
        ..recordError(ErrorRecordParam(
          exception: record.object,
          stack: record.stackTrace,
          reason: record.message,
        ))
        ..sendUnsentReports();
    } else if (record.level == Level.WARNING) {
      CrashReporting().log(record.message);
    }
    if (kDebugMode || record.level == Level.SEVERE) {
      print('$packageName@$version:$build [${record.level.name}]'
          ' ${record.time}; ${record.loggerName}; ${record.message}');
    }
  }).resume();
}
