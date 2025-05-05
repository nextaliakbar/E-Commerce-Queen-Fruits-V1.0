import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchButtonWidget extends StatelessWidget {
  final Color? color;
  final bool isRow;
  final bool isPopup;

  const BranchButtonWidget({super.key, this.isRow = true, this.color, this.isPopup = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(builder: (context, splashProvider, _) {
      return splashProvider.isBranchSelectDisable() ? Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          return branchProvider.getBranchId() != -1 ? isPopup ? const BranchPopUpButton() : InkWell(
            onTap: ()=> RouterHelper.getBranchListScreen(),
            child: isRow ? Row(children: [
             CustomAssetImageWidget(
               Images.branchIcon, color: color ?? ColorResources.primaryColor, height: Dimensions.paddingSizeDefault
             ),

             RotatedBox(quarterTurns: 1, child: Icon(Icons.sync_alt, color: color ?? ColorResources.primaryColor, size: Dimensions.paddingSizeDefault)),

            const SizedBox(width: 2),

            Text('${branchProvider.getBranch()?.name}',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall,
                    color: color ?? ColorResources.primaryColor),
                maxLines: 1, overflow: TextOverflow.ellipsis
            )
            ]) : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // const SizedBox(height: Dimensions.paddingSizeSmall),

                Row(children: [
                 CustomAssetImageWidget(
                   Images.branchIcon, color: color ?? ColorResources.primaryColor, height: Dimensions.paddingSizeDefault,
                 ),
                 RotatedBox(quarterTurns: 1, child: Icon(Icons.sync_alt, color: color ?? ColorResources.primaryColor, size: Dimensions.paddingSizeDefault))
                ]),

                // const SizedBox(height: 8),

                Text('${branchProvider.getBranch()?.name}',
                  style: rubikRegular.copyWith(color: color ?? ColorResources.primaryColor, fontSize: Dimensions.fontSizeSmall),
                  maxLines: 1, overflow: TextOverflow.ellipsis
                ),
                const SizedBox(width: Dimensions.fontSizeExtraSmall),
              ],
            )
          ) : const SizedBox();
        },
      ) : const SizedBox();
    });
  }
}

class BranchPopUpButton extends StatelessWidget {
  const BranchPopUpButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()=> RouterHelper.getBranchListScreen(),
      child: Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return Row(children: [
         Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
           Text("Cabang", style: rubikRegular.copyWith(
            fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor
           )),

           Text('${branchProvider.getBranch()?.name}', style: poppinsRegular.copyWith(
             fontSize: Dimensions.fontSizeSmall, color: ColorResources.primaryColor
           )),

           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Icon(Icons.expand_more, size: Dimensions.paddingSizeDefault, color: Theme.of(context).hintColor)
         ])
        ]);
      }),
    );
  }
}