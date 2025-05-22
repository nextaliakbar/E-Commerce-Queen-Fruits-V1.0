import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/domain/models/search_recommended_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/domain/repositories/search_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class SearchProvider extends DataSyncProvider {
  final SearchRepo? searchRepo;

  SearchProvider({required this.searchRepo});

  List<String> _historyList = [];
  Map<String, String> _historyMap = {};
  final TextEditingController _searchController = TextEditingController();
  List<String>? _autoCompletedName;
  List<String>? _productSearchName;
  SearchRecommendedModel? _searchRecommendedModel;
  int? _selectedPriceIndex;
  int? _selectedRatingIndex;
  int? _selectedSortByIndex;
  String _searchText = '';
  bool _isLoading = false;
  ProductModel? _searchProductModel;
  List<List<int>> _priceList = [];

  List<String> get historyList => _historyList;
  Map<String, String> get historyMap => _historyMap;
  TextEditingController get searchController => _searchController;
  List<String>? get autoCompletedName => _autoCompletedName;
  List<String>? get productSearchName => _productSearchName;
  SearchRecommendedModel? get searchRecommendedModel => _searchRecommendedModel;
  int? get selectedPriceIndex => _selectedPriceIndex;
  int? get selectedRatingIndex => _selectedRatingIndex;
  int? get selectedSortByIndex => _selectedSortByIndex;
  String get searchText => _searchText;
  bool get isLoading => _isLoading;
  ProductModel? get searchProductModel => _searchProductModel;
  List<List<int>> get priceList => _priceList;

  void initHistoryList() {
    _historyList = [];
    _historyList.addAll(searchRepo!.getSearchAddress());

    _addLocalSearchToMap();
  }


  Future<void> getProductSearchTagList(String? name, {bool isReload = false}) async {
    ApiResponseModel apiResponse = await searchRepo!.getSuggestionList(name);

    if(apiResponse.response?.statusCode == 200 && apiResponse.response?.data != null) {
      _productSearchName = apiResponse.response?.data.cast<String>();
    }

    debugPrint('search_provider_dart -> getProductSearchTagList');
    debugPrint('---list-----${_productSearchName?.toList()}');
    notifyListeners();
  }

  void _addLocalSearchToMap ()=> _historyMap.addEntries(_historyList.map((item) => MapEntry(item, item)));

  Future<void> onChangeAutoCompleteTag({String? searchText}) async {
    _autoCompletedName = null;

    notifyListeners();

    await getProductSearchTagList(searchText);

    final normalizedSearchText = searchText?.toLowerCase().replaceAll(' ', '') ?? '';

    _autoCompletedName = [
      ...historyList.where(
          (tag) => tag.toLowerCase().replaceAll(' ', '').contains(normalizedSearchText)
      ),
      ...?_productSearchName
    ];

    notifyListeners();

  }

  Future<void> getSearchRecommendedProduct({bool isReload = false}) async {
    if(isReload) {
      _searchRecommendedModel = null;
    }

    if(_searchRecommendedModel == null) {
      fetchAndSyncData(
          fetchFromLocal: ()=> searchRepo!.getSearchRecommendedProduct<CacheResponseData>(source: DataSourceEnum.local),
          fetchFromClient: ()=> searchRepo!.getSearchRecommendedProduct(source: DataSourceEnum.client),
          onResponse: (data, _) {
            _searchRecommendedModel = SearchRecommendedModel.fromJson(data);
            notifyListeners();
          }
      );
    }
  }

  void onClearSearchSuggestion()=> _autoCompletedName = null;

  void saveSearchAddress(String searchAddress) async {
    if(!_historyList.contains(searchAddress)) {
      _historyList.add(searchAddress);
      searchRepo!.saveSearchAddress(searchAddress);
    }
  }

  void resetFilterData({bool isUpdate = false}) {
    _selectedPriceIndex = null;
    _selectedRatingIndex = null;
    _selectedSortByIndex = null;

    Provider.of<CategoryProvider>(Get.context!, listen: false).clearSelectedCategory();

    if(isUpdate) {
      notifyListeners();
    }
  }

  Future<void> searchProduct({
    required int offset,
    required String name,
    required BuildContext context,
    bool isUpdate = true,
    String? productType,
  }) async {
    _searchText = name;
    _isLoading = true;

    if(offset == 1) {
      _searchProductModel = null;

      if(isUpdate) {
        notifyListeners();
      }
    }

    if(isUpdate) {
      notifyListeners();
    }

    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    ApiResponseModel apiResponse = await searchRepo!.getSearchProductList(
        name: name,
        offset: offset,
        productType: productType,
        categoriesId: categoryProvider.selectedCategoryList,
        minPrice: _selectedPriceIndex != null ? _priceList[_selectedPriceIndex!].first.toString() : null,
        maxPrice: _selectedPriceIndex != null ? _priceList[_selectedPriceIndex!].last.toString() : null,
        rating: null, sortBy: null
    );

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      if(offset == 1) {
        _searchProductModel = ProductModel.fromJson(apiResponse.response?.data);
        _createFilterPriceList(_searchProductModel?.productMaxPrice ?? 0);
      } else {
        _searchProductModel?.totalSize = ProductModel.fromJson(apiResponse.response?.data).totalSize;
        _searchProductModel?.offset = ProductModel.fromJson(apiResponse.response?.data).offset;
        _searchProductModel?.products?.addAll(ProductModel.fromJson(apiResponse.response?.data).products ?? []);
      }
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
  }

  void _createFilterPriceList(double amount) {
    _priceList = [];
    int digit = '${amount.ceil()}'.length;

    for(int i = 0; i < digit; i++) {
      int min = i == 0 ? 0 : int.parse('1${'0' * i}');
      int max = int.parse('1${'0' * (i + 1)}');

      _priceList.add([min, max]);
    }
  }
}