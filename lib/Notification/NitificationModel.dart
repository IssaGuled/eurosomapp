import 'dart:convert';

import 'package:http/http.dart' as http;

class NotificationService {
  Future sendNotification(String token, String title, String body,
      String recieverid, String chatRoomId) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAA87qa99Q:APA91bH2frsjnRNsiT25LaFLbch1zjOfyPhQ4Xz7numpfT1kE487W3FoYBnT7Bnys8AJuRf_McBd1VXjTiBnMbD8Y0E5XXSlRMGhcVXZvfTu7d3PvnglD6ydyypzfBpw7T_c_nthUtMd'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': "linker_click",
                'body': body,
                'title': title,
                'chatroomid': chatRoomId,
                'reciverid': recieverid,
              },
              "notification": <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'linker',
              },
              "to": token
            },
          ));
    } catch (e) {
      print(e);
    }
  }

  Future sendOfferNotification(
      String token,
      String title,
      String body,
      String reqId,
      ) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAA87qa99Q:APA91bH2frsjnRNsiT25LaFLbch1zjOfyPhQ4Xz7numpfT1kE487W3FoYBnT7Bnys8AJuRf_McBd1VXjTiBnMbD8Y0E5XXSlRMGhcVXZvfTu7d3PvnglD6ydyypzfBpw7T_c_nthUtMd'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': "offer_click",
                'body': body,
                'title': title,
                'reqId': reqId,
              },
              "notification": <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'linker',
              },
              "to": token
            },
          ));
    } catch (e) {
      print(e);
    }
  }

  Future newOrderNotification(
      String token,
      ) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAA87qa99Q:APA91bH2frsjnRNsiT25LaFLbch1zjOfyPhQ4Xz7numpfT1kE487W3FoYBnT7Bnys8AJuRf_McBd1VXjTiBnMbD8Y0E5XXSlRMGhcVXZvfTu7d3PvnglD6ydyypzfBpw7T_c_nthUtMd'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': "new_order_click",
                'body': "You have a new order.",
                'title': "New Order",
              },
              "notification": <String, dynamic>{
                'title': "New Order",
                'body': "You have a new order.",
                'android_channel_id': 'linker',
              },
              "to": token
            },
          ));
    } catch (e) {
      print(e);
    }
  }

  Future completeOrderNotification(
      String token,
      ) async {
    try {
      await http.post(Uri.parse("https://fcm.googleapis.com/fcm/send"),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization':
            'key=AAAA87qa99Q:APA91bH2frsjnRNsiT25LaFLbch1zjOfyPhQ4Xz7numpfT1kE487W3FoYBnT7Bnys8AJuRf_McBd1VXjTiBnMbD8Y0E5XXSlRMGhcVXZvfTu7d3PvnglD6ydyypzfBpw7T_c_nthUtMd'
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': "complete_order_click",
                'body': "Good news!. Your order has been completed.",
                'title': "Order Completed",
              },
              "notification": <String, dynamic>{
                'body': "Good news!. Your order has been completed.",
                'title': "Order Completed",
                'android_channel_id': 'linker',
              },
              "to": token
            },
          ));
    } catch (e) {
      print(e);
    }
  }
}
