/// The environment type.
enum EnvironmentType {
  /// The dev environment.
  dev,

  /// The dev environment.
  prod,

  /// The staging environment.
  staging,
}

/// The app environment config.
abstract class AppEnvironment {
  static const _environmentName =
      String.fromEnvironment('TRANSTU_APP_ENVIRONMENT');

  /// Get the app name.
  static const appName = String.fromEnvironment('TRANSTU_APP_NAME');

  /// Environment this application is running in.
  static EnvironmentType get environmentType {
    switch (_environmentName) {
      case 'prod':
        return EnvironmentType.prod;
      case 'staging':
        return EnvironmentType.staging;
      default:
        return EnvironmentType.dev;
    }
  }

  /// Get the app base url.
  static String get appBaseUrl {
    switch (_environmentName) {
      case 'prod':
        return 'https://transtu.karibu-cap.com';
      case 'staging':
        return 'https://transtu-staging.karibu-cap.com';
      default:
        return 'https://transtu-dev.karibu-cap.com';
    }
  }
}
