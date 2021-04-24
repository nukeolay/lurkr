import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_native_timezone/flutter_native_timezone.dart';
//import 'package:timezone/data/latest_all.dart' as tz;
//import 'package:timezone/timezone.dart' as tz;

class LocalNotification {
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static late AndroidNotificationDetails androidSettings;

  static initializer() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    androidSettings = AndroidNotificationDetails('111', 'Local_Notification_Channel', 'Channel to send local notification',
        importance: Importance.high, priority: Priority.max);
    AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('notification_icon'); //todo проверить, может эта строчка и не нужна, если я настройке иконгок уже загрузил файл
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitialization);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static showOneTimeNotification({required String title, required String text}) async {
    NotificationDetails notificationDetails = NotificationDetails(android: androidSettings);
    // print('===begin of getting tz: yyyy-mm-dd hh:mm:ss');
    // tz.initializeTimeZones();
    // final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    // print('===tz: ${tz.TZDateTime.now(tz.getLocation(timeZoneName)).add(const Duration(seconds: 20))}');
    // await flutterLocalNotificationsPlugin.zonedSchedule(
    //     1, title, text, tz.TZDateTime.now(tz.getLocation(timeZoneName)).add(const Duration(seconds: 20)), notificationDetails,
    //     androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
    await flutterLocalNotificationsPlugin.show(1, title, text, notificationDetails);
  }

  static cancelNotification(int notificationId) async {
    await flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
