import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/models/category_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/repositories/category_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/js_util.dart';

class CategoryProvider extends DataSyncProvider {
  final CategoryRepo? categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  bool _isLoading = false;
  String? _selectedSubCategoryId;
  bool _pageFirstIndex = true;
  ProductModel? _categoryProductModel;
  int _selectCategory = -1;
  final List<int> _selectedCategoryList = [];

  List<CategoryModel>? get categoryList => _categoryList;
  List<CategoryModel>? get subCategoryList => _subCategoryList;
  bool get isLoading => _isLoading;
  String? get selectedSubCategoryId => _selectedSubCategoryId;
  bool get pageFirstIndex => _pageFirstIndex;
  ProductModel? get categoryProductModel => _categoryProductModel;
  int get selectCategory => _selectCategory;
  List<int> get selectedCategoryList => _selectedCategoryList;


  Future<void> getCategoryList(bool reload) async {
    if(_categoryList == null || reload) {
      _isLoading = true;

      fetchAndSyncData(
          fetchFromLocal: ()=> categoryRepo!.getCategoryList<CacheResponseData>(source: DataSourceEnum.local),
          fetchFromClient: ()=> categoryRepo!.getCategoryList(source: DataSourceEnum.client),
          onResponse: (data, _) {
            debugPrint("Data categories ${data.toString()}");
            _categoryList = [];
            data.forEach((category) => _categoryList!.add(CategoryModel.fromJson(category)));

            if(_categoryList!.isNotEmpty) {
              _selectedSubCategoryId = '${categoryList?.first.id}';
            }

            _isLoading = false;

            notifyListeners();
          }
      );
    }
  }

  Future<void> getSubCategoryList(String categoryID, {String type = 'all', String? name}) async {
    _subCategoryList = null;
    _isLoading = true;

    ApiResponseModel apiResponse = await categoryRepo!.getSubCategoryList(categoryID);

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _subCategoryList = [];
      apiResponse.response!.data.forEach((category) => _subCategoryList!.add(CategoryModel.fromJson(category)));
      getCategoryProductList(categoryID, 1, type: type);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> getCategoryProductList(String? categoryID, int offset, {String type = 'all', String? name}) async {
    if(_selectedSubCategoryId != categoryID || offset == 1) {
      _categoryProductModel = null;
    }
    _selectedSubCategoryId = categoryID;
    notifyListeners();

    if(_categoryProductModel == null || offset != 1) {
      ApiResponseModel apiResponse = await categoryRepo!.getCategoryProductList(categoryID: categoryID, offset: offset, type: type, name: name);

      if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        if(offset == 1) {
          _categoryProductModel = ProductModel.fromJson(apiResponse.response?.data);
        } else {
          _categoryProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
          _categoryProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
          _categoryProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
        }
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }

    notifyListeners();
  }

  void updatedProductCurrentIndex(int index, int totalLength) {
    if(index > 0) {
      _pageFirstIndex = false;
      notifyListeners();
    } else {
      _pageFirstIndex = true;
      notifyListeners();
    }

    if(index + 1 == totalLength) {
      _pageFirstIndex = true;
      notifyListeners();
    } else {
      _pageFirstIndex = false;
      notifyListeners();
    }
  }

  void clearSelectedCategory()=> _selectedCategoryList.clear();
}