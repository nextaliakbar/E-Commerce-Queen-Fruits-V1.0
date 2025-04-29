import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';

class SplashRepo extends DataSyncRepo {
  SplashRepo({required super.dioClient, required super.sharedPreferences});

  Future<ApiResponseModel<T>> getConfig<T>({required DataSourceEnum source}) async{
    return await fetchData(AppConstants.configUri, source);
  }

  Future<bool> initSharedData() {
    if(!sharedPreferences!.containsKey(AppConstants.cartList)) {
      return sharedPreferences!.setStringList(AppConstants.cartList, []);
    }

    return Future.value(true);
  }

  int getBranchId() => sharedPreferences?.getInt(AppConstants.branch) ?? -1;

  Future<void> setBranchId(int id) async {
    await sharedPreferences!.setInt(AppConstants.branch, id);
    if(id != -1) {
      await dioClient.updateHeader(getToken: sharedPreferences!.getString(AppConstants.token));
    }
  }

  Future<ApiResponseModel<T>> getPolicyPage<T>({ required DataSourceEnum source}) async {
    return await fetchData<T>(AppConstants.policyPage, source);
  }

  Future<ApiResponseModel<T>> getDeliveryInfo<T>(int branchId, {required DataSourceEnum source}) async {
    return await fetchData<T>("${AppConstants.getDeliveryInfo}?branch_id=$branchId", source);
  }

}