import 'package:firebase_core/firebase_core.dart';
import 'src/firebase_options_dev.dart';
import 'src/firebase_options_prod.dart';
import 'src/firebase_options_staging.dart';

/// Default [FirebaseOptions] for use with your Firebase apps.
abstract class FirebaseOptionsInterface {
  /// Creates a default [FirebaseOptions] for use with your Firebase apps.
  factory FirebaseOptionsInterface.create(String environment) {
    switch (environment) {
      case 'dev':
        return DefaultFirebaseOptionsDev();
      case 'prod':
        return DefaultFirebaseOptionsProd();
      case 'staging':
        return DefaultFirebaseOptionsStaging();
      default:
        throw UnsupportedError('Unsupported environment: $environment');
    }
  }

  /// Gets the default [FirebaseOptions] for use with your Firebase apps.
  FirebaseOptions getOptions();
}
