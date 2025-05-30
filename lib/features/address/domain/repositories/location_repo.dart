import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocationRepo({required this.dioClient, required this.sharedPreferences});

  Future<ApiResponseModel> getAddressFromGeocode(LatLng latLng) async {
    try {
      Response response = await dioClient!.get('${AppConstants.geocodeUri}?lat=${latLng.latitude}&lng=${latLng.longitude}');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("error get map api geocode");
      debugPrint("Errors ${ApiErrorHandler.getMessage(e)}");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getAllAddress() async{
    try {
      final response = await dioClient!.get(AppConstants.addressListUri);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      debugPrint("Error get address");
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  List<String> getAllAddressType({BuildContext? context}) {
    return ['Home','Workplace','Other'];
  }

  Future<ApiResponseModel> addAddress(AddressModel addressModel) async {
    try {
      Map<String, dynamic> data = addressModel.toJson();
      Response response = await dioClient!.post(
        AppConstants.addAddressUri,
        data: data,
      );
      return ApiResponseModel.withSuccess(response);
    } catch (e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getDefaultAddress() async {
    try {
      final response = await dioClient!.get(AppConstants.lastOrderedAddress);
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> updateAddress(AddressModel addressModel, int? addressId) async {
    try {
      Response response =  await dioClient!.post(
        '${AppConstants.updateAddressUri}$addressId',
        data: addressModel.toJson()
      );
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> deleteUserAddressById(int? id) async {
    try {
      final response = await dioClient!.post(
        '${AppConstants.removeAddressUri}$id',
        data: {"_method":"delete"}
      );

      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}