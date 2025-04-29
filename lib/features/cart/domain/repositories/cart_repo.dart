import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/data_sync_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartRepo {
  final SharedPreferences? sharedPreferences;
  CartRepo({required this.sharedPreferences});

  String _getCartDataKey(BuildContext context) {
    return '${AppConstants.cartList}_${Provider.of<BranchProvider>(context, listen: false).getBranchId()}';
  }

  List<CartModel> getCartList(BuildContext context) {
    List<String>? carts = [];
    if(sharedPreferences!.containsKey(_getCartDataKey(context))) {
      carts = sharedPreferences!.getStringList(_getCartDataKey(context));
    }

    List<CartModel> cartList = [];
    for(var cart in carts!) {
      cartList.add(CartModel.fromJson(jsonDecode(cart)));
    }

    return cartList;
  }
}