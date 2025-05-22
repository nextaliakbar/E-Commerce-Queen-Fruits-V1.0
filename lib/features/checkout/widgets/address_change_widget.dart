import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_bottom_sheet_header.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_dialog_shape_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class AddressChangeWidget extends StatelessWidget {
  final Branches? currentBranch;
  final bool kmWiseCharge;
  final double? amount;

  const AddressChangeWidget({
    super.key, required this.currentBranch, required this.kmWiseCharge, required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    final double height = MediaQuery.sizeOf(context).height;

    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      return CustomDialogShapeWidget(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraLarge, vertical: Dimensions.paddingSizeLarge),
        maxHeight: height * 0.5, child: Column(children: [
          locationProvider.addressList == null ? _AddressShimmerWidget(
            enabled: locationProvider.addressList == null,
          ) : (locationProvider.addressList?.isNotEmpty ?? false) ? Expanded(child: Column(children: [
            CustomBottomSheetHeader(title: "Alamat Pengiriman"),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Expanded(child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: locationProvider.addressList!.length,
            itemBuilder: (context, index) {
              bool isAvailable = splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance' ? CheckOutHelper.isAddressInCoverage(
                  currentBranch, locationProvider.addressList![index]) : true;

              return Padding(
                padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
                child: Material(
                  color: index == checkoutProvider.addressIndex ? Theme.of(context).cardColor : ColorResources.primaryColor.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    side: index == checkoutProvider.addressIndex ? BorderSide(color: ColorResources.primaryColor, width: 2) : BorderSide.none,
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: InkWell(
                    onTap: isAvailable ? (){
                      Navigator.of(context).pop();
                      CheckOutHelper.selectDeliveryAddress(
                        splashProvider: splashProvider,
                        isAvailable: isAvailable, index: index, configModel: splashProvider.configModel!,
                        locationProvider: locationProvider, checkoutProvider: checkoutProvider,
                        fromAddressList: true,
                      );

                    } : null,
                    child: Stack(children: [
                      Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Row(children: [
                        Padding(
                          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
                          child: Icon(
                            locationProvider.addressList![index].addressType == 'Home' ? Icons.home_outlined
                                : locationProvider.addressList![index].addressType == 'Workplace' ? Icons.work_outline : Icons.list_alt_outlined,
                            color: index == checkoutProvider.addressIndex ? ColorResources.primaryColor
                                : Theme.of(context).textTheme.bodyLarge!.color,
                            size: Dimensions.paddingSizeLarge,
                          ),
                        ),

                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(locationProvider.addressList![index].addressType! == 'Home'
                                ? 'Rumah' : locationProvider.addressList![index].addressType! == 'Workplace'
                                ? 'Kantor' : 'Lainnya', style: rubikSemiBold.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                            )),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Text(locationProvider.addressList![index].address!, style: rubikRegular, /*maxLines: 1, overflow: TextOverflow.ellipsis*/),
                          ]),
                        ),

                        index == checkoutProvider.addressIndex ? Align(
                          alignment: Alignment.topRight,
                          child: Icon(Icons.check_circle, color: ColorResources.primaryColor),
                        ) : const SizedBox(),
                      ])),

                      !isAvailable ? Positioned(
                        top: 0, left: 0, bottom: 0, right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black.withOpacity(0.6)),
                          child: Text(
                            "Diluar jangkauan cabang ini",
                            textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                            style: rubikRegular.copyWith(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ) : const SizedBox(),
                    ]),
                  ),
                ),
              );
            },
          )),
          ])) : Expanded(child: Column(children: []))
        ]),
      );
    });
  }
}

class _AddressShimmerWidget extends StatelessWidget {
  const _AddressShimmerWidget({
    required this.enabled,
  });

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) => Shimmer(enabled: enabled, child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeLarge),
        child: Row(children: [
          Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall), child: Container(
            width: Dimensions.paddingSizeLarge, height: Dimensions.paddingSizeLarge,
            color: Theme.of(context).hintColor.withOpacity(0.3),
          )),

          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                width: 200, height: Dimensions.paddingSizeLarge,
                color: Theme.of(context).hintColor.withOpacity(0.3),
                margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
              ),

              Container(
                width: 150, height: Dimensions.paddingSizeLarge,
                color: Theme.of(context).hintColor.withOpacity(0.3),
              ),
            ]),
          ),
        ]),
      )),
    );
  }
}