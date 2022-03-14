import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationDetails androidSettings;

  static initializer() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidSettings = AndroidNotificationDetails('111', 'Local_Notification_Channel',
        importance: Importance.high, priority: Priority.max);
    AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('notification_icon');
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitialization);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showOneTimeNotification({required String title, required String text}) async {
    NotificationDetails notificationDetails = NotificationDetails(android: androidSettings);
    await flutterLocalNotificationsPlugin.show(1, title, text, notificationDetails);
  }

  static cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
