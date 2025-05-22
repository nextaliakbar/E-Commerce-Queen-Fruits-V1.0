import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/domain/repositories/cart_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
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
        quantity = quantity + (_cartList[i]!.quantity ?? 0);
      }
    }
    return quantity;
  }

  int isExistInCart(int? productID, int? cartIndex) {
    for(int index = 0; index < _cartList.length; index++) {
      if(_cartList[index]!.product!.id == productID) {
        if(index == cartIndex) {
          return -1;
        } else {
          return index;
        }
      }
    }
    return -1;
  }
  
  void addToCart(CartModel cartModel, int? index) {
    if(index != null && index != -1) {
      _cartList.replaceRange(index, index + 1, [cartModel]);
    } else {
      _cartList.add(cartModel);
    }
    cartRepo!.addToCartList(_cartList);
    setCartUpdate(false);
    showCustomSnackBarHelper(index == -1 ? "Ditambahkan ke keranjang" : "Keranjang diperbarui", isToast: true, isError: false);
    notifyListeners();
  }
  
  void setCartUpdate(bool isUpdate) {
    _isCartUpdate = isUpdate;
    if(_isCartUpdate) {
      notifyListeners();
    }
  }

  void removeFromCart(int index) {
    _amount = _amount - (_cartList[index]!.discountedPrice! * _cartList[index]!.quantity!);
    _cartList.removeAt(index);
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void setQuantity({
    required bool isIncrement,
    CartModel? cartModel,
    int? productIndex,
    required bool fromProductView
  }) {
    int? index = fromProductView ? productIndex : _cartList.indexOf(cartModel);

    if(isIncrement) {
      _cartList[index!]!.quantity = _cartList[index]!.quantity! + 1;
      _amount = _amount + _cartList[index]!.discountedPrice!;
    } else {
      _cartList[index!]!.quantity = _cartList[index]!.quantity! - 1;
      _amount = _amount - _cartList[index]!.discountedPrice!;
    }

    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }

  void clearCartList() {
    _cartList = [];
    _amount = 0;
    cartRepo!.addToCartList(_cartList);
    notifyListeners();
  }
}