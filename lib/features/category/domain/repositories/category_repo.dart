import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';

class CategoryRepo extends DataSyncRepo {
  CategoryRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getCategoryList<T>({required DataSourceEnum source}) async {
    return await fetchData(AppConstants.categoryUri, source);
  }
}