import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class ProductProvider extends DataSyncProvider {
  final ProductRepo? productRepo;

  ProductProvider({required this.productRepo});

  ProductModel? _latestProductModel;
  ProductModel? _popularLocalProductModel;
  ProductModel? _importProductModel;
  ProductModel? _recommendedProductModel;

  ProductModel? get latestProductModel => _latestProductModel;
  ProductModel? get popularLocalProductModel => _popularLocalProductModel;
  ProductModel? get importProductModel => _importProductModel;
  ProductModel? get recommendedProductModel => _recommendedProductModel;

  Future<void> getLatestProductList(int offset, bool reload, {bool isUpdate = true}) async {
    final ProductSortProvider productSortProvider = Provider.of<ProductSortProvider>(Get.context!, listen: false);

    if(reload) {
      _latestProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(offset == 1) {
      fetchAndSyncData(
          fetchFromLocal: ()=> productRepo!.getLatestProductList<CacheResponseData>(offset: offset, type: productSortProvider.selectedShotType, source: DataSourceEnum.local),
          fetchFromClient: ()=> productRepo!.getLatestProductList(offset: offset, type: productSortProvider.selectedShotType, source: DataSourceEnum.client),
          onResponse: (data, _) {
            _latestProductModel = ProductModel.fromJson(data);
            notifyListeners();
          }
      );
    } else {
      if(_latestProductModel == null || offset != 1) {
        ApiResponseModel? response = await productRepo?.getLatestProductList(offset: offset, type: productSortProvider.selectedShotType, source: DataSourceEnum.client);

        if(response?.response?.data != null && response?.response?.statusCode == 200) {
          if(offset == 1) {
            _latestProductModel = ProductModel.fromJson(response?.response?.data);
          } else {
            _latestProductModel?.totalSize = ProductModel.fromJson(response?.response?.data).totalSize;
            _latestProductModel?.offset = ProductModel.fromJson(response?.response?.data).offset;
            _latestProductModel?.products?.addAll(ProductModel.fromJson(response?.response?.data).products ?? []);

            notifyListeners();
          }
        } else {
          ApiCheckerHelper.checkApi(response!);
        }
      }
    }
  }

  Future<void> getPopularLocalProductList(int offset, bool reload, {bool isUpdate = true}) async {
    if(reload) {
      _popularLocalProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(offset == 1) {
      fetchAndSyncData(
          fetchFromLocal: ()=> productRepo!.getPopularProductList<CacheResponseData>(offset: offset,  source: DataSourceEnum.local),
          fetchFromClient: ()=> productRepo!.getPopularProductList(offset: offset,  source: DataSourceEnum.client),
          onResponse: (data, _) {
            _popularLocalProductModel = ProductModel.fromJson(data);
            notifyListeners();
          }
      );

      // debugPrint('Length ${_popularLocalProductModel?.products?.length}');
    } else {
      ApiResponseModel? response = await productRepo?.getPopularProductList(offset: offset, source: DataSourceEnum.client);

      if(response?.response?.data != null && response?.response?.statusCode == 200) {
        if(offset == 1) {
          _popularLocalProductModel = ProductModel.fromJson(response?.response?.data);
        } else {
          _popularLocalProductModel?.totalSize = ProductModel.fromJson(response?.response?.data).totalSize;
          _popularLocalProductModel?.offset = ProductModel.fromJson(response?.response?.data).offset;
          _popularLocalProductModel?.products?.addAll(ProductModel.fromJson(response?.response?.data).products ?? []);

          notifyListeners();
        }
      } else {
        ApiCheckerHelper.checkApi(response!);
      }
    }
  }

  Future<void> getImportProductList(int offset, bool reload, {bool isUpdate = true}) async {
    if(reload) {
      _importProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(offset == 1) {
      fetchAndSyncData(
          fetchFromLocal: ()=> productRepo!.getImportProductList<CacheResponseData>(offset: offset,  source: DataSourceEnum.local),
          fetchFromClient: ()=> productRepo!.getImportProductList(offset: offset,  source: DataSourceEnum.client),
          onResponse: (data, _) {
            _importProductModel= ProductModel.fromJson(data);
            notifyListeners();
          }
      );
    } else {
      if(_importProductModel == null || offset != 1) {
        ApiResponseModel? response = await productRepo?.getImportProductList(offset: offset, source: DataSourceEnum.client);

        if(response?.response?.data != null && response?.response?.statusCode == 200) {
          if(offset == 1) {
            _importProductModel = ProductModel.fromJson(response?.response?.data);
          } else {
            _importProductModel?.totalSize = ProductModel.fromJson(response?.response?.data).totalSize;
            _importProductModel?.offset = ProductModel.fromJson(response?.response?.data).offset;
            _importProductModel?.products?.addAll(ProductModel.fromJson(response?.response?.data).products ?? []);

            notifyListeners();
          }
        } else {
          ApiCheckerHelper.checkApi(response!);
        }
      }

    }
  }

  Future<void> getRecommendedProductList(int offset, bool reload, {bool isUpdate = true}) async {
    if(reload) {
      _recommendedProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(offset == 1) {
      fetchAndSyncData(
          fetchFromLocal: ()=> productRepo!.getRecommendedProductList<CacheResponseData>(offset: offset,  source: DataSourceEnum.local),
          fetchFromClient: ()=> productRepo!.getRecommendedProductList(offset: offset,  source: DataSourceEnum.client),
          onResponse: (data, _) {
            _recommendedProductModel= ProductModel.fromJson(data);
            notifyListeners();
          }
      );
    } else {
      if(_recommendedProductModel == null || offset != 1) {
        ApiResponseModel? response = await productRepo?.getRecommendedProductList(offset: offset, source: DataSourceEnum.client);

        if(response?.response?.data != null && response?.response?.statusCode == 200) {
          if(offset == 1) {
            _recommendedProductModel = ProductModel.fromJson(response?.response?.data);
          } else {
            _recommendedProductModel?.totalSize = ProductModel.fromJson(response?.response?.data).totalSize;
            _recommendedProductModel?.offset = ProductModel.fromJson(response?.response?.data).offset;
            _recommendedProductModel?.products?.addAll(ProductModel.fromJson(response?.response?.data).products ?? []);

            notifyListeners();
          }
        } else {
          ApiCheckerHelper.checkApi(response!);
        }
      }
    }
  }

  bool checkStock(Product product, {int? quantity}) {
    int? stock;
    if(product.branchProduct?.stockType != 'unlimited' && product.branchProduct?.stock != null && product.branchProduct?.soldQuantity != null) {
      stock = product.branchProduct!.stock! - product.branchProduct!.soldQuantity!;

      if(quantity != null) {
        stock = stock - quantity;
      }
    }

    return stock == null || (stock > 0);
  }
}
