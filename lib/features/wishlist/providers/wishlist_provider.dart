import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepo? wishlistRepo;

  WishlistProvider({required this.wishlistRepo});

  List<Product>? _wishList;
  List<int?> _wishIdList = [];
  bool _isLoading = false;
  
  List<Product>? get wishList => _wishList;
  List<int?> get wishIdList => _wishIdList;
  bool get isLoading => _isLoading;
  
  Future<void> initWishList() async {
    _wishList = [];
    _wishIdList = [];
    
    if(Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
      _isLoading = true;
      ApiResponseModel apiResponse = await wishlistRepo!.getWishList();
      
      if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _wishList = [];
        _wishIdList = [];
        _wishList!.addAll(ProductModel.fromJson(apiResponse.response!.data).products!);

        for(int i = 0; i < _wishList!.length; i++) {
          _wishIdList.add(_wishList![i].id);
        }
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }

      _isLoading = false;
      notifyListeners();
    }
  }
}