import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/place_order_body.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    try {
      final response = await dioClient!.get('${AppConstants.distanceMatrixUri}'
          '?origin_lat=${originLatLng.latitude}&origin_lng=${originLatLng.longitude}'
          '&destination_lat=${destinationLatLng.latitude}&destination_lng=${destinationLatLng.longitude}');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiResponseModel.withError(ApiErrorHandler.getMessage(e)));
    }
  }

  Future<ApiResponseModel> placeOrder(PlaceOrderBody orderBody) async {
    try {
      Map<String, dynamic> data = orderBody.toJson();
      debugPrint("Json data $data");
      final response = await dioClient!.post(AppConstants.placeOrderUri, data: data);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOrderList() async {
    try {
      final response = await dioClient!.get(AppConstants.orderListUri);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> trackOrderWithPhoneNumber(String? orderId, String phoneNumber) async {
    try {
      final response = await dioClient!.post(AppConstants.trackOrderWithPhoneNumber, data: {
        'order_id' : orderId,
        'phone':phoneNumber
      });
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("Error post track order with phone number");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> trackOrder(String? orderId, {String? phoneNumber}) async {
    try {
      debugPrint("URI : ${AppConstants.trackUri}$orderId");
      final response = await dioClient!.get('${AppConstants.trackUri}$orderId');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("Error get track order without phone number");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOrderDetailsWithPhoneNumber(String? orderId, String phoneNumber) async {
    try {
      final response = await dioClient!.post(AppConstants.orderDetailsWithPhoneNumber, data: {
        'order_id':orderId,
        'phone':phoneNumber
      });
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("Error post order detail with phone number");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getOrderDetails(String orderId) async {
    try {
      debugPrint("URI : ${AppConstants.orderDetailsUri}$orderId");
      final response = await dioClient!.get('${AppConstants.orderDetailsUri}$orderId');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("Error get order detail without phone number");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getExpenses(int branchId, int year, int month) async {
    try {
      final response = await dioClient!.get('${AppConstants.expensesUri}?branch_id=$branchId'
          '&&year=$year&&month=$month');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }

  }
}