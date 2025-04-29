import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class BranchCloseWidget extends StatelessWidget {
  const BranchCloseWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        const CustomAssetImageWidget(Images.branchClose),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        Text("Semua cabang kami", style: rubikSemiBold.copyWith(color: ColorResources.primaryColor, fontSize: Dimensions.fontSizeLarge))
      ],
    );
  }
}