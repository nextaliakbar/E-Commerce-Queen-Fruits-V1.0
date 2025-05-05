import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/domain/repositories/cart_repo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  final CartRepo? cartRepo;
  List<CartModel?> _cartList = [];
  double _amount = 0.0;
  bool _isCartUpdate = false;

  CartProvider({required this.cartRepo});

  void getCartData(BuildContext context) {
    _cartList = [];
    _cartList.addAll(cartRepo!.getCartList(context));
    for(var cart in cartList) {
      _amount = _amount + (cart!.discountedPrice! * cart.quantity!);
    }
  }

  List<CartModel?> get cartList => _cartList;

  double get amount => _amount;

  bool get isCartUpdate => _isCartUpdate;

  int getCartIndex(Product product) {
    for(int i = 0; i < _cartList.length; i++) {
      if(_cartList[i]!.product!.id == product.id) {
        return i;
      }
    }

    return -1;
  }

  int getCartProductQuantityCount(Product product) {
    int quantity = 0;
    for(int i = 0; i < _cartList.length; i++) {
      if(_cartList[i]!.product!.id == product.id) {
        quantity = quantity * (_cartList[i]!.quantity ?? 0);
      }
    }

    return quantity;
  }
}