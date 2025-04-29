import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/delivery_info_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/policy_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/domain/repositories/splash_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

class SplashProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;
  SplashProvider({required this.splashRepo});

  PolicyModel? _policyModel;
  DeliveryInfoModel? _deliveryInfoModel;
  ConfigModel? _configModel;
  BaseUrls? _baseUrls;

  Future<bool> initSharedData() {
    return splashRepo!.initSharedData();
  }

  PolicyModel? get policyModel => _policyModel;
  DeliveryInfoModel? get deliveryInfoModel => _deliveryInfoModel;
  ConfigModel? get configModel => _configModel;
  BaseUrls? get baseUrls => _baseUrls;

  Future<void> getPolicyPage() async {
    fetchAndSyncData(
        fetchFromLocal: ()=> splashRepo!.getPolicyPage<CacheResponseData>(source: DataSourceEnum.local),
        fetchFromClient: ()=> splashRepo!.getPolicyPage(source: DataSourceEnum.client),
        onResponse: (data, _) {
          _policyModel = PolicyModel.fromJson(data);
          notifyListeners();
        });
  }

  Future<void> getDeliveryInfo(int branchId) async {
    fetchAndSyncData(
        fetchFromLocal: ()=> splashRepo!.getDeliveryInfo<CacheResponseData>(branchId, source: DataSourceEnum.local),
        fetchFromClient: ()=> splashRepo!.getDeliveryInfo(branchId, source: DataSourceEnum.client),
        onResponse: (data, _) {
          _deliveryInfoModel = DeliveryInfoModel.fromJson(data);
          notifyListeners();
        });
  }

  Future<ConfigModel?> initConfig(BuildContext context, DataSourceEnum source) async {
    if(source == DataSourceEnum.local) {
      ApiResponseModel<CacheResponseData> responseModel = await splashRepo!.getConfig(source: DataSourceEnum.local);

      if(responseModel.isSuccess) {
        _configModel = ConfigModel.fromJson(jsonDecode(responseModel.response!.response));
        _baseUrls = _configModel?.baseUrls;

        if(context.mounted) {
          _onConfigAction(context);
        }
      }

      if(context.mounted) {
        await initConfig(context, DataSourceEnum.client);
      }
    } else {
        ApiResponseModel<Response> apiResponseModel = await splashRepo!.getConfig(source: DataSourceEnum.client);

        if(apiResponseModel.isSuccess) {
          _configModel = ConfigModel.fromJson(apiResponseModel.response?.data);
          _baseUrls = _configModel?.baseUrls;

          if(context.mounted) {
            await _onConfigAction(context);
          }
        }
    }
  }

  Future<void> _onConfigAction(BuildContext context) async {
    if(_configModel != null) {

      if(context.mounted) {
        if(!Provider.of<AuthProvider>(context, listen: false).isLoggedIn()) {
          await Provider.of<AuthProvider>(context, listen: false).updateToken();
        }
      }

      if(_configModel != null && _configModel?.branches != null && !isBranchSelectDisable()) {
        await splashRepo?.setBranchId(_configModel!.branches![0]!.id!);
        await getDeliveryInfo(_configModel!.branches![0]!.id!);
      }

      notifyListeners();
    }
  }

  int getActiveBranch() {
    int branchActiveCount = 0;

    for(int i = 0; i < _configModel!.branches!.length; i++) {
      if(_configModel!.branches![i]!.status ?? false) {
        branchActiveCount++;
        if(branchActiveCount > 1) {
          break;
        }
      }
    }

    if(branchActiveCount == 0) {
      splashRepo?.setBranchId(-1);
    }

    return branchActiveCount;
  }

  bool isBranchSelectDisable ()=> getActiveBranch() != 1;
}