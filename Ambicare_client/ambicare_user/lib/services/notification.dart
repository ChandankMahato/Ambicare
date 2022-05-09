import 'package:ambicare_user/secrets/secrets.dart';
import 'package:dio/dio.dart';

class NotificationHandler {
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
}
