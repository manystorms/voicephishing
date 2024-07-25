import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final notifications = FlutterLocalNotificationsPlugin();

initNotification() async {
  var androidSetting = const AndroidInitializationSettings('main_icon');

  var iosSetting = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  var initalizationSettings = InitializationSettings(
    android: androidSetting,
    iOS: iosSetting,
  );
  await notifications.initialize(
    initalizationSettings,
  );
}

NotificationDetails _details = const NotificationDetails(
  android: AndroidNotificationDetails('alarm 1', '1번 푸시'),
  iOS: DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  ),
);

Future<void> showPushAlarm(String title, String context) async {
  FlutterLocalNotificationsPlugin _localNotification =
  FlutterLocalNotificationsPlugin();

  await _localNotification.show(0,
      title,
      context,
      _details,
      payload: 'deepLink');
}