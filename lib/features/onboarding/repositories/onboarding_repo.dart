import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/onboarding/models/onboarding_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:flutter/material.dart';

class OnBoardingRepo {
  final DioClient? dioClient;

  OnBoardingRepo({required this.dioClient});

  Future<ApiResponseModel> getOnBoardingList(BuildContext context) async {
    try {
      List<OnBoardingModel> onBoardingList = [
        OnBoardingModel(Images.onBoardingOne, 'Temukan buah favoritmu', 'Silahkan masuk atau daftar terlebih dahulu untuk menemukan pesanan anda'),
        OnBoardingModel(Images.onBoardingTwo, 'Temukan buah favoritmu', 'Silahkan masuk atau daftar terlebih dahulu untuk menemukan pesanan anda'),
        OnBoardingModel(Images.onBoardingThree, 'Temukan buah favoritmu', 'Silahkan masuk atau daftar terlebih dahulu untuk menemukan pesanan anda')
      ];

      Response response = Response(requestOptions: RequestOptions(path: ''), data: onBoardingList, statusCode: 200);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}