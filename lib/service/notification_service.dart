import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channel_id = '123';

  Future<void> init() async {
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);

    tz.initializeTimeZones();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {}

  Future selectNotification(String payload) async {}

  void showNotification(String notificationMessage) async {
    await flutterLocalNotificationsPlugin.show(
        12345, // id
        'Test notification', // title
        notificationMessage, // body
        const NotificationDetails(
            android: AndroidNotificationDetails(channel_id, 'Birthday Calendar',
                'To remind you about upcoming birthdays'),
            iOS: IOSNotificationDetails()),
        payload: 'data');
  }

  void scheduleNotification(String notificationMessage) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        23456,
        'Test timed notification', // title
        notificationMessage, // body
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        const NotificationDetails(
            android: AndroidNotificationDetails(
                channel_id, 'Flag Calendar', 'Flag reminder'),
            iOS: IOSNotificationDetails()),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
