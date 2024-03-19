/// The common configuration for the app.
class EnvironmentConfig {
  /// The env name.
  static const environmentName =
      String.fromEnvironment('TRANSTU_APP_ENVIRONMENT');

  /// The app name.
  static const appName = String.fromEnvironment('TRANSTU_APP_NAME');

  /// Gets the app base address.
  static const appBaseAddress = String.fromEnvironment('APP_BASE_ADDRESS');

  /// Environment this application is running in.
  static EnvironmentType get environmentType {
    if (environmentName == 'prod') {
      return EnvironmentType.prod;
    } else if (environmentName == 'staging') {
      return EnvironmentType.staging;
    } else {
      return EnvironmentType.dev;
    }
  }

  /// Get the app base url.
  static String get appBaseUrl {
    if (appBaseAddress.isEmpty) {
      switch (environmentName) {
        case 'prod':
          return 'https://transtu.karibu-cap.com';
        case 'staging':
          return 'https://transtu-staging.karibu-cap.com';
        default:
          return 'https://transtu-dev.karibu-cap.com';
      }
    }

    return appBaseAddress;
  }
}

/// The environment type.
class EnvironmentType {
  /// The production environment.
  static const prod = EnvironmentType._('prod');

  /// The staging Environment.
  static const staging = EnvironmentType._('staging');

  /// The development environment.
  static const dev = EnvironmentType._('dev');

  /// The unique identifier of this environment.
  final String key;

  const EnvironmentType._(this.key);
}
