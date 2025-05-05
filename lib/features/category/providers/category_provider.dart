import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/models/category_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/repositories/category_repo.dart';
import 'package:flutter/cupertino.dart';

class CategoryProvider extends DataSyncProvider {
  final CategoryRepo? categoryRepo;

  CategoryProvider({required this.categoryRepo});

  List<CategoryModel>? _categoryList;
  List<CategoryModel>? _subCategoryList;
  bool? _isLoading = false;
  String? _selectedSubCategoryId;

  List<CategoryModel>? get categoryList => _categoryList;

  List<CategoryModel>? get subCategoryList => _subCategoryList;

  bool? get isLoading => _isLoading;

  String? get selectedSubCategoryId => _selectedSubCategoryId;

  Future<void> getCategoryList(bool reload) async {
    if(_categoryList == null || reload) {
      _isLoading = true;

      fetchAndSyncData(
          fetchFromLocal: ()=> categoryRepo!.getCategoryList<CacheResponseData>(source: DataSourceEnum.local),
          fetchFromClient: ()=> categoryRepo!.getCategoryList(source: DataSourceEnum.client),
          onResponse: (data, _) {
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
}