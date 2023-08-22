import 'package:karibu_capital_core_remote_config/remote_config.dart';

/// AppConfig defines services used by the application.
class AppConfig {
  /// Remote config service for the apps.
  final RemoteConfigType remoteConfigType;

  /// Constructs configurations for the Place apps.
  AppConfig({
    required this.remoteConfigType,
  });
}

AppConfig _appConfig = AppConfig(
  remoteConfigType: RemoteConfigType.firebase,
);

/// Returns the default app config.
AppConfig getAppConfigDefaults() {
  return _appConfig;
}
