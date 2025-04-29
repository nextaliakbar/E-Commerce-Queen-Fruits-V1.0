import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/error_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/foundation.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";

    if(error is Exception) {
      try {
        if (error is DioException) {
          switch(error.type) {
            case DioExceptionType.cancel:
              errorDescription = "Request to API server was canceled";
              break;

            case DioExceptionType.receiveTimeout:
              errorDescription = "Receive timeout in connection with API server";
              break;

            case DioExceptionType.badResponse:
              switch(error.response!.statusCode) {
                case 500:
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;

                  default:
                    ErrorResponseModel? errorResponse;

                    try {
                      errorResponse = ErrorResponseModel.fromJson(error.response!.data);
                    } catch(e) {
                      if(kDebugMode) {
                        debugPrint('error is ---> ${e.toString()}');
                      }
                    }

                    if(errorResponse != null && errorResponse.errors != null && errorResponse.errors!.isNotEmpty) {
                      if(kDebugMode) {
                        debugPrint('error ---------- = ${errorResponse.errors![0].message} || error : ${error.response!.requestOptions.uri}');
                      }

                      errorDescription = errorResponse.toJson();
                    } else {
                      errorDescription = "Failed to load data ${kDebugMode ? '- status code : ${error.response!.statusCode}' : ''}";
                    }
              }

              break;

            case DioExceptionType.sendTimeout:
            case DioExceptionType.connectionTimeout:
              errorDescription = "Send timeout with server ${Get.context!}";
              errorDescription = errorDescription = "Send timeout with server ${Get.context!}";
              break;
            case DioExceptionType.badCertificate:
              errorDescription = "Incorrect certificate ${Get.context!}";
              break;
            case DioExceptionType.connectionError:
              errorDescription = "Unavailable to process data ${Get.context!} ${error.response?.statusCode}";
              break;
            case DioExceptionType.unknown:
              debugPrint('error --------------- == ${error.response?.requestOptions.path} || ${error.response?.statusCode} ${error.response?.data}');
              errorDescription = "Unavailable to process data ${Get.context!}";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch(e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }

    return errorDescription;
  }
}