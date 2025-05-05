import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/providers/wishlist_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishButtonWidget extends StatelessWidget {
  final Product? product;
  final EdgeInsetsGeometry edgeInset;

  const WishButtonWidget({
    super.key, required this.product,
    this.edgeInset = EdgeInsets.zero
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<WishlistProvider>(builder: (context, wishlistProvider, child) {
      return Padding(
        padding: edgeInset, child: Material(
          color: ColorResources.primaryColor.withOpacity(wishlistProvider.wishIdList.contains(product!.id) ? 1 : 0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: (){},
            child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: const Icon(Icons.favorite, color: Colors.white, size: Dimensions.paddingSizeDefault),
            ),
          ),
        ),
      );
    });
  }
}