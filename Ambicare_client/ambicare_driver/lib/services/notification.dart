import 'package:ambicare_driver/secrets/secrets.dart';
import 'package:ambicare_driver/services/database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:dio/dio.dart';

class NotificationHandler {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final firebaseMessagingInstance = FirebaseMessaging.instance;

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  static Future<void> initializeChannel() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_channel);
  }

  static void initializeLocalNotificationPlugin() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> onMessageHandler() async {
    initializeLocalNotificationPlugin();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      if (notification == null) return;
      AndroidNotification? android = message.notification?.android;
      if (notification.title == 'New Message') return;
      if (android != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                _channel.id,
                _channel.name,
                channelDescription: _channel.description,
                icon: android.smallIcon,
                priority: Priority.high,
                importance: Importance.high,
                fullScreenIntent: true,
              ),
            ));
      }
    });
  }

  static Future<void> sendNotification({
    String? token,
    String? body,
    String? title,
  }) async {
    try {
      await Dio().post(
        'https://fcm.googleapis.com/fcm/send',
        data: {
          "notification": {
            "body": body,
            "title": title,
            "android_channel_id": "high_importance_channel"
          },
          "priority": "high",
          "data": {
            "click_action": "FLUTTER_NOTIFICATION_CLICK",
            "status": "done"
          },
          "to": token,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': API.messagingKey,
          },
        ),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  static Future<void> resolveToken() async {
    Map<String, dynamic> token = await Database.getToken();
    String? deviceToken = await firebaseMessagingInstance.getToken();
    if (token.isEmpty || token["token"] != deviceToken) {
      await Database.saveToken(deviceToken!);
    }
  }
}
