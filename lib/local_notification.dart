import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();

  static Future startNoti() async {
    const androidSettings = AndroidInitializationSettings("mipmap/ic_launcher");
    await flnp.initialize(InitializationSettings(android: androidSettings));

    // Ask for permission (important for Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future showNoti({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      "100", // Channel ID
      "myChannel", // Channel name
      importance: Importance.max,
      priority: Priority.high,
    );

    await flnp.show(id, title, body, NotificationDetails(android: androidDetails));
  }
}
