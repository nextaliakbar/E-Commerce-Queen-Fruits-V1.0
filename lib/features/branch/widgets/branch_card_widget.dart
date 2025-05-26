import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchCardWidget extends StatelessWidget {
  final BranchValue? branchModel;
  final List<BranchValue>? branchModelList;
  final VoidCallback? onTap;

  const BranchCardWidget({super.key, this.branchModel, this.branchModelList, this.onTap});

  @override
  Widget build(BuildContext context) {
    final  SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<BranchProvider>(
      builder: (context, branchProvider, _) {
        return GestureDetector(onTap: branchModel!.branches!.status! ? () {
          branchProvider.updateBranchId(branchModel!.branches!.id);
          onTap!();
        } : null, child: Container(
          width: 320,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            border: branchProvider.selectedBranchId == branchModel!.branches!.id
              ? Border.all(color: ColorResources.primaryColor) : null
          ),
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
             DecoratedBox(
               decoration: BoxDecoration(
                 border: Border.all(color: ColorResources.primaryColor.withOpacity(0.2)),
                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
               ),
               child: ClipRRect(
                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                 child: CustomImageWidget(
                   placeholder: Images.placeholderRectangle,
                   // image: '${splashProvider.baseUrls!.branchImageUrl}/${branchModel!.branches!.image}',
                   image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.branchImageUrl}&file=${branchModel!.branches!.image}',
                   width: 60, fit: BoxFit.cover, height: 60,
                 ),
               ),
             ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text(branchModel!.branches!.name ?? '', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(branchModel!.branches!.address != null
                    ? (branchModel!.branches!.address!.length > 20
                    ? '${branchModel!.branches!.address!.substring(0, 20)}...'
                    : branchModel!.branches!.address!)
                    : branchModel!.branches!.name!,
                  style: rubikSemiBold.copyWith(color: ColorResources.primaryColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                )
              ])
            ]),

            const SizedBox(height: Dimensions.paddingSizeSmall),

            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
             Row(children: [
              Icon(
                Icons.schedule_outlined,
                color: branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error
              ),

              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

              Text(
                branchModel!.branches!.status! ? 'Buka sekarang' : 'Tutup sekarang',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault,
                color: branchModel!.branches!.status! ? Theme.of(context).secondaryHeaderColor : Theme.of(context).colorScheme.error
                ),
              )
             ]),
              
              if(branchModel!.distance != -1 && splashProvider.configModel?.googleMapStatus == 1) Row(children: [
                Text('${branchModel!.distance.toStringAsFixed(3)} km', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
                
                const SizedBox(width: 3),
                
                Text('Jauh', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall))
              ])
            ])
          ]),
        ));
      },
    );
  }
}