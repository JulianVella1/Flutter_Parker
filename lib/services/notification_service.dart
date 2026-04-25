import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(android: androidSettings);

    await _notifications.initialize(settings);
  }

  static Future<void> showParkingSavedNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'parking_channel',
      'Parking Notifications',
      channelDescription: 'Notifications for parking reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      1,
      'Parking saved',
      'Your parking spot was saved successfully.',
      details,
    );
  }

  static Future<void> showParkingEndedNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'parking_channel',
      'Parking Notifications',
      channelDescription: 'Notifications for parking reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      2,
      'Parking ended',
      'This parking session has been marked as ended.',
      details,
    );
  }
}
