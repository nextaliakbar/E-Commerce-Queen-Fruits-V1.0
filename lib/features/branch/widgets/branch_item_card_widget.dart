import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchItemCardWidget extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchItemCardWidget({super.key, this.branchesValue});

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Consumer<BranchProvider>(
        builder: (context, branchProvider, _) {
          return GestureDetector(
            onTap: () {
              if(branchesValue!.branches!.status!) {
                branchProvider.updateBranchId(branchesValue!.branches!.id);
              } else {
                showCustomSnackBarHelper('${branchesValue!.branches!.name} tutup sekarang');
              }
            },
            child: Stack(children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: ColorResources.primaryColor.withOpacity(branchProvider.selectedBranchId == branchesValue!.branches!.id ? 1 : 0),
                    width: 1
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                  color: branchProvider.selectedBranchId == branchesValue!.branches!.id ? ColorResources.primaryColor.withOpacity(0.1)
                      : Theme.of(context).cardColor,
                  boxShadow: [BoxShadow(color: Theme.of(context).hintColor.withOpacity(0.25), blurRadius: 36, offset: const Offset(18, 18))]
                ),
                child: Column(children: [
                  /// Branch Banner
                  Expanded(flex: 3, child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(Dimensions.radiusLarge),
                      topLeft: Radius.circular(Dimensions.radiusLarge)
                    ),
                    child: Stack(children: [
                      CustomImageWidget(
                        placeholder: Images.branchBanner,
                        // image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.coverImage}',
                        image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.branchImageUrl}&file=${branchesValue!.branches!.coverImage}',
                        width: Dimensions.webScreenWidth,
                      ),

                      if(!branchesValue!.branches!.status!) Container(
                        decoration: BoxDecoration(
                          color:Colors.black.withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(Dimensions.radiusLarge),
                            topLeft: Radius.circular(Dimensions.radiusLarge)
                          )
                        ),
                        child: Center(child: Container(
                         padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                         decoration: BoxDecoration(
                           color: Theme.of(context).primaryColor.withOpacity(0.5),
                           borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)
                         ),
                         child: Row(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.end, children: [
                           const Icon(Icons.schedule_outlined, color: Colors.white, size: Dimensions.paddingSizeLarge),
                           const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                           Text('Tutup sekarang', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeDefault, color: Colors.white))
                         ]),
                        )),
                      )
                    ]),
                  )),

                  /// Branch info
                  Expanded(flex: 2, child: Padding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      const SizedBox(width: 90),

                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(branchesValue!.branches!.name!, style: rubikSemiBold),

                            Row(children: [
                             Icon(Icons.location_on_rounded, size: Dimensions.fontSizeDefault, color: ColorResources.primaryColor),
                              const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                              Expanded(child: Text(
                                branchesValue?.branches?.address ?? '',
                                style: rubikSemiBold.copyWith(color: ColorResources.primaryColor, fontSize: Dimensions.fontSizeSmall),
                                maxLines: 1, overflow: TextOverflow.ellipsis,
                              ))
                            ])
                          ])),

                          if(branchesValue!.distance != -1 && splashProvider.configModel?.googleMapStatus == 1)
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [

                              Text('${branchesValue!.distance.toStringAsFixed(3)} km', style: rubikBold),

                              Text('Jauh', style: rubikSemiBold.copyWith(
                                fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor
                              ))

                            ]))
                        ])
                      ]))
                    ]),
                  ))
                ]),
              ),

              /// Branch image
              Positioned(bottom: 20, left: 15, child: Container(
               height: 70, width: 70,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                 color: Colors.white
               ),
               margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
               padding: const EdgeInsets.all(3),
               child: Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                   border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.2)),
                   color: Theme.of(context).cardColor
                 ),
                 child: ClipRRect(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), child: CustomImageWidget(
                   placeholder: Images.placeholderImage,
                   // image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue!.branches!.image}',
                   image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.branchImageUrl}&file=${branchesValue!.branches!.image}',
                   height: 70, width: 70,
                 ),),
               ),
              ))
            ])
          );
        });
  }
}