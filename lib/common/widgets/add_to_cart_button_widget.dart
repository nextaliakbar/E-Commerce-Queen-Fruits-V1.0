import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_item_detail_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddToCartButtonWidget extends StatelessWidget {

  final Product product;

  const AddToCartButtonWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(builder: (context, cartProvider, _) {
      int quantity = cartProvider.getCartProductQuantityCount(product);
      int cartIndex = cartProvider.getCartIndex(product);

      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          boxShadow: [BoxShadow(
            color: ColorResources.primaryColor.withOpacity(0.2), offset: const Offset(0, 2),
            blurRadius: Dimensions.radiusExtraLarge, spreadRadius: Dimensions.radiusSmall
          )]
        ),
        child: quantity == 0 ? Material(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: Colors.white,
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomeItemDetailScreen(product: product)));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
               Icon(Icons.add_circle, color: ColorResources.primaryColor, size: Dimensions.paddingSizeLarge),

               const SizedBox(width: Dimensions.paddingSizeSmall),

               Text("Tambah", style: rubikBold.copyWith(color: ColorResources.primaryColor, fontSize: Dimensions.fontSizeSmall))

              ]),
            ),
          ),
        ) : Material(
          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
          color: ColorResources.primaryColor,
          clipBehavior: Clip.hardEdge,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              InkWell(
                onTap: ()=> showCustomSnackBarHelper("Fitur dalam tahap pengembangan"),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.remove, size: Dimensions.fontSizeDefault, color: ColorResources.primaryColor)
                )
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: Text(quantity.toString(), style: rubikRegular.copyWith(color: Colors.white)),
              ),

              InkWell(
                onTap: ()=> showCustomSnackBarHelper("Fitur dalam tahap pengembangan"),
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.add, size: Dimensions.fontSizeDefault, color: ColorResources.primaryColor),
                ),
              )
            ])
          ),
        ),
      );
    });
  }
}