import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/cart_product_widget.dart';
import 'package:flutter/material.dart';

class CartListWidget extends StatelessWidget {
  final CartProvider cartProvider;
  final List<bool> availableList;

  const CartListWidget({super.key, required this.cartProvider, required this.availableList});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: cartProvider.cartList.length,
      itemBuilder: (context, index) {
        return CartProductWidget(cartModel: cartProvider.cartList[index], cartIndex: index, isAvailable: availableList[index]);
      },
    );
  }
}