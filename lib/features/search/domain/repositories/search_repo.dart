import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/exception/api_error_handler.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';

class SearchRepo extends DataSyncRepo {
  SearchRepo({required super.dioClient, required super.sharedPreferences});

  List<String> getSearchAddress() {
    return sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
  }

  Future<ApiResponseModel> getSuggestionList(String? name) async {
    try {
      final response = await dioClient.get('${AppConstants.searchSuggestion}?name=$name');

      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponseModel<T>> getSearchRecommendedProduct<T>({required DataSourceEnum source}) async {
    return await fetchData(AppConstants.searchRecommended, source);
  }

  Future<void> saveSearchAddress(String searchAddress) async {
    try {
      List<String> searchKeywordList = sharedPreferences!.getStringList(AppConstants.searchAddress) ?? [];
      if(!searchKeywordList.contains(searchAddress)) {
        searchKeywordList.add(searchAddress);
      }
      await updateSearchData(searchKeywordList);
    } catch(e) {
      rethrow;
    }
  }

  Future<bool> updateSearchData(List<String> list) async {
    return sharedPreferences!.setStringList(AppConstants.searchAddress, list);
  }

  Future<ApiResponseModel> getSearchProductList({
    required String name,
    required int offset,
    String? minPrice,
    String? maxPrice,
    List<int>? categoriesId,
    double? rating,
    String? productType,
    String? sortBy
  }) async {
    final dynamic data = {
      if(name.isNotEmpty) 'name':name,
      if(minPrice != null) 'min_price':minPrice,
      if(maxPrice != null) 'max_price':maxPrice,
      if(categoriesId != null && categoriesId.isNotEmpty) 'category_id':categoriesId,
      if(rating != null) 'rating':rating,
      if(productType != null) 'product_type':productType,
      if(sortBy != null) 'sort_by':sortBy
    };

    try {
      final dynamic response = await dioClient.post('${AppConstants.searchUri}?limit=10&offset=$offset', data: data);

      return ApiResponseModel.withSuccess(response);
    } catch(e) {
      return ApiResponseModel.withError(ApiErrorHandler.getMessage(e));
    }
  }
}