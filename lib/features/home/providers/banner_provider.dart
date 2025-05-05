import 'package:dio/dio.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/domain/repositories/banner_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/models/banner_model.dart';

class BannerProvider extends DataSyncProvider {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});

  List<BannerModel>? _bannerList;
  final List<Product> _productList = [];

  List<BannerModel>? get bannerList => _bannerList;
  List<Product> get productList => _productList;

  Future<void> getBannerList(bool reload) async {
    if(_bannerList == null || reload) {
      fetchAndSyncData(
          fetchFromLocal: ()=> bannerRepo!.getBannerList<CacheResponseData>(source: DataSourceEnum.local),
          fetchFromClient: ()=> bannerRepo!.getBannerList<Response>(source: DataSourceEnum.client),
          onResponse: (response, _) {
            _bannerList = [];

            response?.forEach((category) {
              BannerModel bannerModel = BannerModel.fromJson(category);

              if(bannerModel.product != null) {
                _productList.add(bannerModel.product!);
              }

              _bannerList!.add(bannerModel);
            });

            notifyListeners();
          }
      );
    }
  }
}