import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class BottomNavItemWidget extends StatelessWidget {
  final String imageIcon;
  final String title;
  final Function? onTap;
  final bool isSelected;

  const BottomNavItemWidget({super.key, this.onTap, this.isSelected = false, required this.title, required this.imageIcon});


  @override
  Widget build(BuildContext context) {
    return Expanded(child: InkWell(
      onTap: onTap as void Function()?,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
       CustomAssetImageWidget(
         imageIcon, height: 25, width: 25,
         color: isSelected ? ColorResources.primaryColor : Theme.of(context).hintColor,
       ),
       SizedBox(height: isSelected? Dimensions.paddingSizeExtraSmall : Dimensions.paddingSizeSmall),

       if(isSelected) Text(title, style: rubikBold.copyWith(color: isSelected ? ColorResources.primaryColor : Theme.of(context).textTheme.bodyMedium!.color!, fontSize: 12))
      ]),
    ));
  }
}