import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  ProfileRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getUserInfo() async {
    try {
      final response = await dioClient!.get(AppConstants.customerInfoUri);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}