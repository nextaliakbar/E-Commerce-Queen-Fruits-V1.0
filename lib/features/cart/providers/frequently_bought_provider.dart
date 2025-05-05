import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:flutter/foundation.dart';

class FrequentlyBoughtProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  FrequentlyBoughtProvider({required this.productRepo});

  ProductModel? _frequentlyBoughtProductModel;

  ProductModel? get frequentlyBoughtProductModel => _frequentlyBoughtProductModel;

  Future<void> getFrequentlyBoughtProduct(int offset, bool reload, {bool isUpdate = false}) async {
    if(reload) {
      _frequentlyBoughtProductModel = null;
    }

    if(isUpdate) {
      notifyListeners();
    }

    if(frequentlyBoughtProductModel == null || offset != 1) {
      ApiResponseModel? apiResponse = await productRepo?.getFrequentlyBoughtProduct(offset);

      if(apiResponse?.response?.data != null && apiResponse?.response?.statusCode == 200) {
        if(offset == 1) {
          _frequentlyBoughtProductModel = ProductModel.fromJson(apiResponse?.response?.data);
        } else {
          _frequentlyBoughtProductModel?.totalSize = ProductModel.fromJson(apiResponse?.response?.data).totalSize;
          _frequentlyBoughtProductModel?.offset = ProductModel.fromJson(apiResponse?.response?.data).offset;
          _frequentlyBoughtProductModel?.products = ProductModel.fromJson(apiResponse?.response?.data).products;
        }

        notifyListeners();
      } else {
        ApiCheckerHelper.checkApi(apiResponse!);
      }
    }
  }
}