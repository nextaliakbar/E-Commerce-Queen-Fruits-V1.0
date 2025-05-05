import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/domain/models/search_recommended_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/domain/repositories/search_repo.dart';
import 'package:flutter/cupertino.dart';

class SearchProvider extends DataSyncProvider {
  final SearchRepo? searchRepo;

  SearchProvider({required this.searchRepo});

  List<String> _historyList = [];
  Map<String, String> _historyMap = {};
  final TextEditingController _searchController = TextEditingController();
  List<String>? _autoCompletedName;
  List<String>? _productSearchName;
  SearchRecommendedModel? _searchRecommendedModel;

  List<String> get historyList => _historyList;
  Map<String, String> get historyMap => _historyMap;
  TextEditingController get searchController => _searchController;
  List<String>? get autoCompletedName => _autoCompletedName;
  List<String>? get productSearchName => _productSearchName;
  SearchRecommendedModel? get searchRecommendedModel => _searchRecommendedModel;

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
}