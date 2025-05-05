import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/product_sort_type.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/localization/app_localization.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';

class ProductRepo extends DataSyncRepo {
  ProductRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getLatestProductList<T>({required int offset, required ProductSortType type, required DataSourceEnum source}) async {
    return await fetchData<T>('${AppConstants.latestProductUri}?limit=15&&offset=$offset&sort_by${type.name.camelCaseToSnakeCase()}', source);
  }

  Future<ApiResponseModel<T>> getPopularProductList<T>({required int offset, required DataSourceEnum source}) async {
    return await fetchData('${AppConstants.popularProductUri}?limit=10&&offset=$offset&product_type=all', source);
  }

  Future<ApiResponseModel<T>> getImportProductList<T>({required int offset, required DataSourceEnum source}) async {
    return await fetchData('${AppConstants.importProductUri}?limit=12&&offset=$offset', source);
  }

  Future<ApiResponseModel<T>> getRecommendedProductList<T>({required int offset, required DataSourceEnum source}) async {
    return await fetchData('${AppConstants.recommendedProductUri}?limit=100&&offset=$offset', source);
  }

  Future<ApiResponseModel> getFrequentlyBoughtProduct(int offset) async {
    try {
      final response = await dioClient.get('${AppConstants.frequentlyBought}?limit=4&&offset=$offset');

      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}