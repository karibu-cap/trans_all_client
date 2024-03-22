import 'dart:async';
import 'dart:math';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

import '../themes/app_colors.dart';

/// The local notification api.
class LocalNotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future _notificationDetail() async {
    return const NotificationDetails(
        android: AndroidNotificationDetails(
            'default_notifications_channel_id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            priority: Priority.high,
            audioAttributesUsage: AudioAttributesUsage.notificationEvent,
            enableVibration: true,
            visibility: NotificationVisibility.public,
            category: AndroidNotificationCategory.alarm,
            colorized: true,
            color: AppColors.purple,
            largeIcon: DrawableResourceAndroidBitmap('ic_stat_ic_notification'),
            actions: [
              AndroidNotificationAction(
                'DISMISS',
                'dismiss',
              ),
            ]),
        iOS: DarwinNotificationDetails());
  }

  /// Clears all notification.
  static Future<void> clearAllNotification() async {
    await _notifications.cancelAll();

    return;
  }

  /// Shows notification.
  static Future<void> showNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    await _notifications.show(
      Random().nextInt(10000),
      title,
      body,
      await _notificationDetail(),
      payload: payload,
    );

    return;
  }

  /// Initializes the local notification.
  static Future init() async {
    final permissionResult = await Permission.notification.isDenied;

    if (!permissionResult) {
      await Permission.notification.request();
    }

    const androidSetting =
        AndroidInitializationSettings('@drawable/ic_stat_ic_notification');
    const iosSetting = DarwinInitializationSettings();
    final InitializationSettings settings = const InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );
    await _notifications.initialize(
      settings,
    );
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }
}
