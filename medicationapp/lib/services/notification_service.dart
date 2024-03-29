import 'package:cron/cron.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicationapp/services/reminder_service.dart';

class Notifications {
  static final _cron = Cron();
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize native android notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize native Ios Notifications
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    initCronSchedulerForNotifications();
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload}) async {
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
            'medication_app_reminder_id', 'medication_app_channel',
            playSound: true,
            importance: Importance.max,
            priority: Priority.high);

    var details = NotificationDetails(
        android: androidNotificationDetails,
        iOS: const DarwinNotificationDetails());
    await flutterLocalNotificationsPlugin.show(0, title, body, details);
  }

  static void initCronSchedulerForNotifications() {
    _cron.schedule(Schedule.parse('*/1 * * * *'), () {
      ReminderService.sendNotifications();
    });
  }
}
