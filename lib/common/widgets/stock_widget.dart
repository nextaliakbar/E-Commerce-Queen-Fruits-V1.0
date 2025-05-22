import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/product_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockTagWidget extends StatelessWidget {
  final ProductGroup productGroup;
  final Product product;

  const StockTagWidget({
    super.key, required this.product, this.productGroup = ProductGroup.common
  });

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    bool isAvailable = ProductHelper.isProductAvailable(product: product);

    return !productProvider.checkStock(product) || !isAvailable ? Positioned.fill(child: Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      width: double.maxFinite,
      decoration: BoxDecoration(color: Colors.black.withOpacity(0.3)),
      child: Center(child: Container(
       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
       decoration: BoxDecoration(
         color: ColorResources.primaryColor.withOpacity(0.5),
         borderRadius: BorderRadius.circular(Dimensions.radiusLarge)
       ),
       child: Row(mainAxisSize: MainAxisSize.min, children: [
        const CustomAssetImageWidget(Images.clockSvg, color: Colors.white, width: 14, height: 14),

        const SizedBox(width: Dimensions.paddingSizeExtraSmall),

        Flexible(child: Text(
          !isAvailable ? 'Tidak tersedia' : 'Stok habis',
          textAlign: TextAlign.center,
          style: robotoRegular.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeExtraSmall),
          maxLines: 1, overflow: TextOverflow.ellipsis
        ))
       ]),
      )),
    )) : const SizedBox();
  }
}