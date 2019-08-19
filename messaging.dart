import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class Messaging {

  static final Client client = Client();


  static const String serverKey =
      'AAAAjzBFSwU:APA91bH5-iyZnHC0Y-5t0NwTEdW8CWyw79Uccl7Q9VvLwBJU0LG2Ddi5xpVZUf-puZlRbg9_OvnGDTc2IbrRCL_jSpyEiFmmaWByIPdSraMKkizr7SAKAogRIVAl4eVENZhaM0wlFX5f';

  static Future<Response> sendToAll({

    @required String title,

    @required String body,
    @required String topic,

  }) =>

      sendToTopic(title: title, body: body, topic: topic);


  static Future<Response> sendToTopic(

      {@required String title,

        @required String body,

        @required String topic}) =>

      sendTo(title: title, body: body, fcmToken: topic);



  static Future<Response> sendTo({

    @required String title,

    @required String body,

    @required String fcmToken,

  }) =>

      client.post(

        'https://fcm.googleapis.com/fcm/send',

        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),

        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );
}