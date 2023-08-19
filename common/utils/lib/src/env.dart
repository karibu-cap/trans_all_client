/// Environment variables and shared app.
abstract class EnvironmentCommon {
  /// A static constant string that represents the environment variable.
  /// If the environment variable is not set, the default value is an
  /// empty string.
  static const String environment = String.fromEnvironment(
    'TRANSTU_APP_ENVIRONMENT',
    defaultValue: '',
  );

  /// A static constant string that represents the app name variable.
  /// If the environment variable is not set, the default value
  /// is an empty string.
  static const String appName = String.fromEnvironment(
    'TRANSTU_APP_NAME',
    defaultValue: '',
  );
}
