import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:karibu_capital_core_cloud_messaging/cloud_messaging.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_utils/utils.dart';

import '../data/repository/userDataRepository.dart';

/// The helper that contains useful method to retrieve a notification
/// payload.
class GeneratedUserDataManager {
  final Logger _log = Logger('GeneratedUserDataManager');
  final CloudMessaging _messaging;
  final UsersDataRepository _repository;
  String? _languageCode;

  /// Constructs a new [GeneratedUserDataManager].
  GeneratedUserDataManager({
    required CloudMessagingType cloudMessagingType,
    required UsersDataRepository repository,
    String? languageCode,
  })  : _messaging = CloudMessaging(type: cloudMessagingType),
        _repository = repository,
        _languageCode = languageCode {
    _onUserLaunchApp();
  }

  String? _vapidKey() {
    if (!kIsWeb) {
      return null;
    }

    switch (EnvironmentConfig.environmentType) {
      case EnvironmentType.prod:
        return 'BBercPa3-9yJv3XCWwvAPhw8kvw8eBY4aiPRsmxntssc1u2ODJm1qMruEwvF2Z3C-MFNZBQ32Kruot94rjIkbn4';
      case EnvironmentType.staging:
        return 'BL34tzgiXvj8RT1_-8nFgc7d6IyzMznRkY7pJqmUBEBp-390oseN7lG7xzg7ERsPgvQ9sRkrOiFm5NOpU94K668';
      default:
        return 'BHO1bAApQI_hGFk85OBbwV7NDjSi43DaUAwPEWLIkQzg_GFO0aR6rV0RcyveSY_RfGnbv1eqYVifK2HU13PcQOo';
    }
  }

  void _onUserLaunchApp() async {
    final deviceId = await getDeviceId();
    await _updateToken(deviceId);
  }

  /// Updates the user token.
  /// * [userId] The id of the authenticated user.
  Future<bool?> _updateToken(String deviceId) async {
    final authorized = await _messaging.requestPermission();
    if (!authorized) {
      _log.warning('Notification permissions rejected');

      return false;
    }

    final token = await _messaging.getToken(vapidKey: _vapidKey());
    if (token == null) {
      _log.warning('Invalid default token');

      return false;
    }
    _log.info('device token: $token');

    _log.info('deviceId: $deviceId');

    return _repository.updateNotificationToken(
        token: token, deviceId: deviceId, systemLocal: _languageCode ?? 'fr');
  }

  /// Gets the devise id.
  Future<String> getDeviceId() async {
    final log = Logger('getDeviceId');

    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (kIsWeb) {
      // We allow only one instance for web.
      return 'web';
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      // If we can't find the ios device id, we set the default value to ios.
      return iosInfo.identifierForVendor ?? 'ios';
    } else if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // If we can't find the current android device id,
      // we set the default value to 'android'.

      return androidInfo.id;
    }

    log.warning('Unknown device Id during notifications setup');

    return 'unknown';
  }
}
