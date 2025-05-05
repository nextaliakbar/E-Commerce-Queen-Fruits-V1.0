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
}