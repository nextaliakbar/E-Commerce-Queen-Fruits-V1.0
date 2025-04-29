import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  AuthRepo({required this.dioClient, required this.sharedPreferences});

  Future<bool> clearSharedData() async {
    if(!kIsWeb) {
      Future.delayed(const Duration(milliseconds: 100)).then((value) async =>
      await FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic));
    }

    try {
      await dioClient!.post(
        AppConstants.tokenUri,
        data: {
          "_method": "put",
          "cm_firebase_token": "@"
        }
      );
    } catch(error) {
      debugPrint('error $error');
    }

    debugPrint('-------- (update device token) ------- from clearSharedData|repo');

    await updateDeviceToken(fcmToken: '@');
    await sharedPreferences!.remove(AppConstants.token);
    await sharedPreferences!.remove(AppConstants.cartList);
    await sharedPreferences!.remove(AppConstants.userAddress);
    await sharedPreferences!.remove(AppConstants.searchAddress);

    return true;
  }

  Future<ApiResponseModel> updateDeviceToken({String? fcmToken}) async {
    try {
      String? deviceToken = '@';

      if(defaultTargetPlatform == TargetPlatform.iOS) {
        FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true);
        NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
          alert: true, announcement: false, badge: true, carPlay: false,
          criticalAlert: false, provisional: false, sound: true
        );

        if(settings.authorizationStatus == AuthorizationStatus.authorized) {
          deviceToken = (await getDeviceToken());
        }
      } else {
        deviceToken = (await getDeviceToken());
        debugPrint("Device token $deviceToken");
      }

      if(!kIsWeb) {
        if(fcmToken != null) {
          FirebaseMessaging.instance.subscribeToTopic(AppConstants.topic);
        } else {
          FirebaseMessaging.instance.unsubscribeFromTopic(AppConstants.topic);
        }
      } else {
        await subscribeTokenToTopic(deviceToken, fcmToken ?? AppConstants.topic);
      }

      Map<String, dynamic> data = {"_method":"put", 'cm_firebase_toke': fcmToken ?? deviceToken};
      Response response = await dioClient!.post(AppConstants.tokenUri, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<String?> getDeviceToken() async {
    String? deviceToken = '@';

    try {
      deviceToken = (await FirebaseMessaging.instance.getToken())!;
    } catch(error) {
      debugPrint('error ===> $error');
    }

    if(deviceToken != null) {
      debugPrint('------ Device Token ------ $deviceToken');
    }

    return deviceToken;
  }

  Future<void> subscribeTokenToTopic(dynamic token, dynamic topic) async {
    await dioClient?.post(AppConstants.subscribeToTopic, data: {"token": '$token', "topic": '$topic'});
  }

  bool isLoggedIn() {
    return sharedPreferences!.containsKey(AppConstants.token);
  }
}