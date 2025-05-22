import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/product_sort_type.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class HomeItemTypeWidget extends StatelessWidget {

  final Function (ProductType productType) onChange;

  const HomeItemTypeWidget({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<ProductType>(
      tooltip: "Jenis produk",
      padding: const EdgeInsets.all(0),
      onSelected: (ProductType result) {

      },
      itemBuilder: (BuildContext c) => <PopupMenuEntry<ProductType>>[
        PopupMenuItem<ProductType>(
          value: ProductType.localProduct,
          child: _PopUpItem(title: "Produk lokal"),
          onTap: ()=> onChange(ProductType.localProduct),
        ),

        PopupMenuItem<ProductType>(
          value: ProductType.importProduct,
          child: _PopUpItem(title: "Produk impor"),
          onTap: ()=> onChange(ProductType.importProduct),
        )
      ],
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          child: CustomAssetImageWidget(
            Images.sortSvg,
            width: Dimensions.paddingSizeDefault,
            height: Dimensions.paddingSizeDefault,
            color: Theme.of(context).hintColor,
          ),
        ),
      ),
    );
  }
}

class _PopUpItem extends StatelessWidget {
  final String title;

  const _PopUpItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
      ),
      child: Row(children: [
       Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
           child: Text(title, style: rubikSemiBold))
      ]),
    );
  }
}

