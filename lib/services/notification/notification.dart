import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class OurNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  initializeSetting() async {
    var initializeAndroid = AndroidInitializationSettings("logo");
    var initializeSetting = InitializationSettings(android: initializeAndroid);
    flutterLocalNotificationsPlugin.initialize(initializeSetting);
  }

  OurNotification() {
    initializeSetting();
    tz.initializeTimeZones();
  }
  displayNotification(
      int id, String title, DateTime datetime, String body) async {
    flutterLocalNotificationsPlugin.zonedSchedule(
        id,
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
  cancelNotification(int taskID) async {
    await flutterLocalNotificationsPlugin.cancel(taskID);
  }
}
