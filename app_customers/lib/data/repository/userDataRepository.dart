import 'package:clock/clock.dart';
import 'package:karibu_capital_core_database/database.dart';
import 'package:logging/logging.dart';
import 'package:trans_all_common_models/models.dart';

/// The repository that stores and retrieves additional user data.
class UsersDataRepository {
  final _log = Logger('UsersDataRepository');
  final Database _db;
  final String _collectionName = 'usersData';

  /// Constructs a new [UsersDataRepository].
  UsersDataRepository(this._db);

  /// Retrieve the [UsersData] of the given [userId].
  /// * [userId] The id of the user that we need to retrieve the generated data.
  Future<UsersData?> getGeneratedUserData(String deviceId) async {
    final Map<dynamic, dynamic>? usersDataCollection = await _db.getCollection(
      _collectionName,
      filters: [
        DocumentQuery(
          UsersData.keyDeviceId,
          deviceId,
          DocumentFieldCondition.isEqualTo,
        ),
      ],
      limit: 1,
    );

    try {
      if (usersDataCollection == null || usersDataCollection.keys.isEmpty) {
        return null;
      }
      final usersDataDoc = usersDataCollection[usersDataCollection.keys.first]
          ?.cast<String, dynamic>();
      if (usersDataDoc == null) {
        return null;
      }
      final data = UsersData.fromJson(
        path: DatabasePathUtils.getDatabasePath(
          _collectionName,
          usersDataCollection.keys.first,
        ),
        json: Map<String, dynamic>.from(usersDataDoc),
      );

      return data;

      // ignore: avoid_catching_errors
    } on TypeError catch (error) {
      _log.severe(
        'Failed to deserialize the model UsersData'
        ' of user $deviceId',
        error,
        error.stackTrace,
      );

      return null;
    }
  }

  /// Add a new notification token to the
  /// * [notificationToken] The device token that we need to add.
  /// * [userId] The id of the user that we need to update the token.
  Future<String?> addNotificationToken({
    required String notificationToken,
    required String deviceId,
    String? systemLocal,
  }) async {
    final Map<String, dynamic> documentData = {
      UsersData.keyDeviceId: deviceId,
      UsersData.keyToken: notificationToken,
      UsersData.keySystemLocale: systemLocal
    };

    return await _db.createRecord(
      _collectionName,
      documentData,
    );
  }

  /// updates a notification token to add the devise language.
  /// * [sysmLocal] the current devise language.
  /// * [userId] The id of the user that we need to update the token.
  Future<bool?> updateNotificationToken({
    required String token,
    required String systemLocal,
    required String deviceId,
  }) async {
    final userData = await getGeneratedUserData(deviceId);
    if (userData == null) {
      await addNotificationToken(
        deviceId: deviceId,
        notificationToken: token,
        systemLocal: systemLocal,
      );
      return null;
    }
    return await _db.setRecord(
      documentPath: '$_collectionName/${userData.id}',
      recordMap: {
        ...userData.toJson(),
        UsersData.keySystemLocale: systemLocal,
        UsersData.keyToken: token,
        UsersData.keyUpdatedAt: clock.now().toIso8601String()
      },
    );
  }
}
