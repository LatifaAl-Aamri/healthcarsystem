import 'package:flutter_local_notifications/flutter_local_notifications.dart';
class LocalNotification{
  //plugin
  static final FlutterLocalNotificationsPlugin flnp = FlutterLocalNotificationsPlugin();
  //start
  static Future startNoti() async{
    final AndroidInitializationSettings andoSetting = const AndroidInitializationSettings("mipmap/ic_launcher");
    await flnp.initialize(InitializationSettings(android: andoSetting));
  }
  //show
  static Future showNoti({required int id, required String title, required String body}) async{
    var channelInfo = AndroidNotificationDetails("100", "myChannel");
    await flnp.show(id, title, body,
        NotificationDetails(android: channelInfo));
  }
}