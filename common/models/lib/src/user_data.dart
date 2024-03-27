import 'base_document.dart';

/// Represents the additional data generated for the some users.
/// Note: The id of each document should match the id of the user.
class UsersData extends BaseDocument {
  /// The stored key ref for the [token] property.
  static const keyToken = 'token';

  /// The stored key ref for the [systemLocale] property.
  static const keySystemLocale = 'systemLocale';

  /// The stored key ref for the [deviceId] property.
  static const keyDeviceId = 'deviceId';

  /// The stored key ref for the [updatedAt] property.
  static const keyUpdatedAt = 'updatedAt';

  /// A token of the user.
  final String token;

  /// The date of last update of this token.
  final DateTime? updatedAt;

  /// The mobile device id.
  final String deviceId;

  /// The system local of device on which the application is running.
  final String? systemLocale;

  /// Constructs a new [UserToken].
  UsersData.fromJson({
    required String path,
    required Map<String, dynamic> json,
  })  : token = json[keyToken],
        updatedAt = DateTime.tryParse(json[keyUpdatedAt] ?? ''),
        systemLocale = json[keySystemLocale],
        deviceId = json[keyDeviceId],
        super.fromJson(path);

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        keyToken: token,
        keyUpdatedAt: updatedAt?.toUtc().toIso8601String(),
        keySystemLocale: systemLocale,
        keyDeviceId: deviceId,
      };
}
