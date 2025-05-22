import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

class ProductProvider extends DataSyncProvider {
  final ProductRepo? productRepo;

  ProductProvider({required this.productRepo});

  ProductModel? _latestProductModel;
  ProductModel? _popularLocalProductModel;
  ProductModel? _importProductModel;
  ProductModel? _recommendedProductModel;
  List<List<bool?>> _selectedVariations = [];
  int? _quantity;
  bool _variationSeeMoreButtonStatus = false;
  List<bool>? _isRequiredSelected = [];
  final int _cartIndex = -1;

  ProductModel? get latestProductModel => _latestProductModel;
  ProductModel? get popularLocalProductModel => _popularLocalProductModel;
  ProductModel? get importProductModel => _importProductModel;
  ProductModel? get recommendedProductModel => _recommendedProductModel;
  List<List<bool?>> get selectedVariations => _selectedVariations;
  int? get quantity => _quantity;
  bool get variationsSeeMoreButtonStatus => _variationSeeMoreButtonStatus;
  List<bool>? get isRequiredSelected => _isRequiredSelected;
  int get cartIndex => _cartIndex;

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

  void initData(Product? product, CartModel? cartModel) {
    _selectedVariations = [];

    if(cartModel != null) {
      _quantity = cartModel.quantity;
      _selectedVariations.addAll(cartModel.variations!);
    } else {
      _quantity = 1;
      if(product!.variations != null) {
        for(int index = 0; index < product.variations!.length; index++) {
          _selectedVariations.add([]);

          for(int i = 0; i < product.variations![index].variationValues!.length; i++) {
            _selectedVariations[index].add(false);
          }
        }
      }
    }
  }

  void initProductVariationStatus(int length) {
    _variationSeeMoreButtonStatus = false;
    _isRequiredSelected = [];

    for(int i = 0; i < length; i++) {
      _isRequiredSelected!.add(false);
    }
  }

  void setVariationSeeMoreStatus(bool status) {
    _variationSeeMoreButtonStatus = status;
    notifyListeners();
  }

  void setCartVariationIndex(int index, int i, Product? product, bool isMultiSelect) {
    if(!isMultiSelect) {
      for(int a = 0; a < _selectedVariations[index].length; a++) {
        if(product!.variations![index].isRequired!) {
          _selectedVariations[index][a] = a == i;
        } else {
          if(_selectedVariations[index][a]!) {
            _selectedVariations[index][a] = false;
          } else {
            _selectedVariations[index][a] = a == i;
          }
        }
      }
    } else {
      if(!_selectedVariations[index][i]! && selectedVariationLength(_selectedVariations, index) >= product!.variations![index].max!) {
        showCustomSnackBarHelper("Maksimal variasi untuk "
            "${product.variations![index].name} adalah "
            "${product.variations![index].max}", isToast: true
        );
      } else {
        _selectedVariations[index][i] = !_selectedVariations[index][i]!;
      }
    }

    notifyListeners();
  }

  int selectedVariationLength(List<List<bool?>> selectedVariations, int index) {
    int length = 0;
    for(bool? isSelected in selectedVariations[index]) {
      if(isSelected!) {
        length++;
      }
    }
    return length;
  }

  void checkIsRequiredSelected({required int index, required bool isMultiSelect, int? min = 1, int? max = 1, required List<bool?> variations}) {
    if(isMultiSelect) {
      int count = 0;
      for(int i = 0; i < variations.length; i++) {
        if(variations[i] == true) count++;
      }

      if(count >= min! && count <= max!) {
        _isRequiredSelected![index] = true;
      } else {
        _isRequiredSelected![index] = false;
      }
    } else {
      _isRequiredSelected![index] = true;
    }

    notifyListeners();
  }

  void setQuantity(bool isIncrement) {
    if(isIncrement) {
      _quantity = _quantity! + 1;
    } else {
      _quantity = _quantity! - 1;
    }

    notifyListeners();
  }
}
