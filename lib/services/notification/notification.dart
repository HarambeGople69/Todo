import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:timezone/timezone.dart' as tz;

class OurNotification {
  displayNotification(String title, DateTime datetime, String body) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    tz.initializeTimeZones();
    AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('logo');
    var initializeSetting =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializeSetting);
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(datetime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            "channelId",
            "channelName",
            "channelDescription",
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
