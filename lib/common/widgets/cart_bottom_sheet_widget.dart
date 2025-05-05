import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartBottomSheetWidget extends StatefulWidget {
  final Product? product;
  final bool fromImportProduct;
  final Function? callback;
  final CartModel? cart;
  final int? cartIndex;
  final bool fromCart;

  const CartBottomSheetWidget({
    super.key,
    required this.product,
    this.fromImportProduct = false,
    this.callback,
    this.cart,
    this.cartIndex,
    this.fromCart = false
  });

  @override
  State<StatefulWidget> createState()=> _CartBottomSheetWidgetState();
}

class _CartBottomSheetWidgetState extends State<CartBottomSheetWidget> {
  @override
  void initState() {
    super.initState();
    // Provider.of<ProductProvider>(context, listen: false).initData();
    // Provider.of<ProductProvider>(context, listen: false).iniProductVariationStatus();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}