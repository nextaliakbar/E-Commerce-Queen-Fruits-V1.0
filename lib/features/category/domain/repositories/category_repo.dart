import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';

class CategoryRepo extends DataSyncRepo {
  CategoryRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getCategoryList<T>({required DataSourceEnum source}) async {
    return await fetchData(AppConstants.categoryUri, source);
  }

  Future<ApiResponseModel> getSubCategoryList(String parentID) async {
    try {
      final response = await dioClient.get('${AppConstants.subCategoryUri}$parentID');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel> getCategoryProductList({
    required String? categoryID, required int offset,
    int limit = 10, required String type,
    String? name
  }) async {
    try {
      final response = await dioClient.get('${AppConstants.categoryProductUri}$categoryID?offset=$offset&limit=$limit&product_type$type${name != null ? '&search=$name' : ''}');
      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}