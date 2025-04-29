import 'dart:developer';
import 'dart:io';

import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/logging_interceptor.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  Dio? dio;
  String? token;

  DioClient(this.baseUrl, Dio? dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences
  }) {
    token = sharedPreferences.getString(AppConstants.token);
    dio = dioC ?? Dio();

    updateHeader(getToken: token, dioC: dioC);
  }

  final _logger = Logger("dio_client.dart");

  Future<void> updateHeader({String? getToken, Dio? dioC}) async {
    dio
    ?..options.baseUrl = baseUrl
        ..options.connectTimeout = const Duration(seconds: 30)
        ..options.receiveTimeout = const Duration(seconds: 30)
        ..httpClientAdapter
        ..options.headers = {
          'Content-Type' : 'application/json; charset=UTF-8',
          'branch_id' : '${sharedPreferences.getInt(AppConstants.branch)}',
          'Authorization' : 'Bearer $getToken'
        };

    dio?.interceptors.add(loggingInterceptor);
  }

  Future<Response> get(String uri, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress
  }) async {
    try {
      debugPrint('apiCall ===> url => $uri \nparams ---> $queryParameters \nheader => ${dio!.options.headers}');
      var response = await dio!.get(
        uri,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress
      );

      return response;
    } on SocketException catch(e) {
      throw SocketException(e.toString());
    } on FormatException catch(_) {
      throw const FormatException("Unable to process the data");
    } catch(e) {
      rethrow;
    }
  }

  Future<Response> post(String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiverProgress
  }) async {
    try {
      debugPrint('apiCall ===> url => $uri \nparamas ----> $queryParameters\nheaders => ${dio!.options.headers} \nbody ---> $data');

      var response = await dio!.post(
          uri,
          data: data,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiverProgress
      );

      return response;
    } on FormatException catch(_) {
      throw const FormatException("Unable to prosess data");
    } catch (e) {
      rethrow;
    }
  }
}