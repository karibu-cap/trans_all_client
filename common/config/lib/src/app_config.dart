import 'package:karibu_capital_core_database/database.dart';
import 'package:karibu_capital_core_remote_config/remote_config.dart';

/// AppConfig defines services used by the application.
class AppConfig {
  /// Remote config service for the apps.
  final RemoteConfigType remoteConfigType;

  /// Database service for the apps.
  final DatabaseType databaseType;

  /// Constructs configurations for the Place apps.
  AppConfig({
    required this.remoteConfigType,
    required this.databaseType,
  });
}

AppConfig _appConfig = AppConfig(
  remoteConfigType: RemoteConfigType.firebase,
  databaseType: DatabaseType.firestore,
);

/// Returns the default app config.
AppConfig getAppConfigDefaults() {
  return _appConfig;
}
