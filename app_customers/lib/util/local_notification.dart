import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:karibu_capital_core_cloud_messaging/cloud_messaging.dart';

/// The local notifications service.
class LocalNotificationsService {
  /// The flutter local notification plugin.
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initialize flutter local notification.
  Future<void> init(String icon) async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings(icon);
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    unawaited(
      flutterLocalNotificationsPlugin.initialize(initializationSettings),
    );
  }

  /// Shows a local notification when the app is in the foreground.
  static void showNotificationOnForeground(
    RemoteMessage message,
    LocalNotificationChannel channel,
  ) {
    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null) {
      AndroidNotificationDetails? androidNotificationDetails;
      DarwinNotificationDetails? iOSNotificationDetails;
      if (android != null) {
        androidNotificationDetails = AndroidNotificationDetails(
          channel.channelId,
          channel.channelName,
          importance: Importance.max,
          styleInformation: BigTextStyleInformation(
            notification.body ?? '',
            contentTitle: notification.title,
          ),
          priority: Priority.max,
          playSound: true,
          icon: channel.icon,
        );
      }
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: androidNotificationDetails,
          iOS: iOSNotificationDetails,
        ),
      );
    }
  }
}

/// Channel for local notifications.
class LocalNotificationChannel {
  /// The id of the channel.
  final String channelId;

  /// The name of the channel.
  final String channelName;

  /// The notification icon.
  final String icon;

  /// Constructs a [LocalNotificationChannel].
  const LocalNotificationChannel({
    required this.channelId,
    required this.channelName,
    required this.icon,
  });
}
