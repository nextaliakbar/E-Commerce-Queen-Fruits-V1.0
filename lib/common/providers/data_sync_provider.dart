import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:flutter/foundation.dart';

class DataSyncProvider with ChangeNotifier {
  Future<void> fetchAndSyncData({
    required Future<ApiResponseModel<CacheResponseData>> Function() fetchFromLocal,
    required Future<ApiResponseModel<Response>> Function() fetchFromClient,
    required Function(dynamic, DataSourceEnum source) onResponse
  }) async {
    final localResponse = await fetchFromLocal();

    // Coba load data dari lokal
    if(localResponse.isSuccess) {
      onResponse(jsonDecode(localResponse.response!.response), DataSourceEnum.local);
    }

    // Coba load data dari client and perbarui jika berhasil
    final clientResponse = await fetchFromClient();
    if(clientResponse.isSuccess) {
      onResponse(clientResponse.response?.data, DataSourceEnum.client);
    } else {
      ApiCheckerHelper.checkApi(clientResponse);
    }

    notifyListeners();
  }
}