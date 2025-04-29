import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class NotificationHelper {

  static Future<void> initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationPlugin) async {
    var androidInitialize = const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings = InitializationSettings(android: androidInitialize, iOS: iOSInitialize);

    flutterLocalNotificationPlugin.initialize(
      initializationsSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {

        PayloadModel payload = PayloadModel.fromJson(jsonDecode('${notificationResponse.payload}'));
        try {
          if(notificationResponse.payload!.isNotEmpty) {
            RouterHelper.getOrderDetailsRoute(payload.orderId);
          } else if(payload.type == 'general') {
            RouterHelper.getNotificationRoute();
          }
        } catch(e) {
          debugPrint('error ===> $e');
        }
        return;
      });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
      debugPrint("-------------- Notification message app background -----------------------");

      try {
        if(message.notification!.titleLocKey != null && message.notification!.titleLocKey!.isNotEmpty) {
          RouterHelper.getOrderDetailsRoute(message.notification!.titleLocKey);
        }
      } catch(e) {
        debugPrint('error ===> $e');
      }
    });
  }
}

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async {
  debugPrint('onBackground: ${message.notification!.title}/${message.notification!.body}/${message.notification!.titleLocKey}');
}

class PayloadModel {
  String? title;
  String? body;
  String? orderId;
  String? image;
  String? type;

  PayloadModel({
    required this.title,
    required this.body,
    required this.orderId,
    required this.image,
    required this.type
  });

  factory PayloadModel.fromJson(Map<String, dynamic> json) => PayloadModel(
    title: json['title'],
    body: json['body'],
    orderId: json['order_id'],
    image: json['image'],
    type: json['type']
  );
}