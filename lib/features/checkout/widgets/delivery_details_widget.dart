import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/address_change_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryDetailsWidget extends StatelessWidget {
  final Branches? currentBranch;
  final bool kmWiseCharge;
  final double? deliveryCharge;
  final double? amount;
  final GlobalKey dropdownKey;

  const DeliveryDetailsWidget({
    super.key,
    required this.currentBranch,
    required this.kmWiseCharge,
    required this.deliveryCharge, this.amount,
    required this.dropdownKey,
  });

  @override
  Widget build(BuildContext context) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;
    final TextEditingController searchController = TextEditingController();

    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
      final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

      AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
        addressList: locationProvider.addressList,
        selectedAddress: checkoutProvider.addressIndex == -1 ? null : locationProvider.addressList?[checkoutProvider.addressIndex],
        lastOrderAddress: null
      );

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusDefault)],
        ),
        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if(checkoutProvider.orderType == OrderType.delivery)...[
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text("Dikirim ke", style: rubikBold.copyWith(
                fontSize: Dimensions.fontSizeDefault,
                fontWeight: FontWeight.w600,
              )),

              TextButton(
                onPressed: () => ResponsiveHelper.showDialogOrBottomSheet(context, AddressChangeWidget(
                    amount: amount,
                    currentBranch: currentBranch,
                    kmWiseCharge: kmWiseCharge,
                  ),
                ),
                child: Text(deliveryAddress == null ? "Tambah Alamat" : "Ubah", style: rubikBold.copyWith(
                  color: ColorResources.primaryColor,
                )),
              ),
            ]),
            SizedBox(height: Dimensions.paddingSizeSmall),

            deliveryAddress == null ? Padding(
              padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.info_outline_rounded, color: ColorResources.primaryColor),
                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text("Teks pendek", style: rubikRegular.copyWith(color: Theme.of(context).colorScheme.error)),
              ]),
            ) : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

              _ContactItemWidget(
                icon: deliveryAddress.addressType == 'Home'
                    ? Icons.home_outlined : deliveryAddress.addressType == 'Workplace'
                    ? Icons.work_outline
                    : Icons.list_alt_outlined,
                title: deliveryAddress.addressType == 'Home' ? 'Rumah'
                : deliveryAddress.addressType == 'Workplace' ? 'Kantor' : 'Lainnya'
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _ContactItemWidget(icon: Icons.person, title: deliveryAddress.contactPersonName ?? ''),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              _ContactItemWidget(icon: Icons.call, title: deliveryAddress.contactPersonNumber ?? ''),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              const Divider(height: Dimensions.paddingSizeDefault, thickness: 0.5),

              Text(deliveryAddress.address ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),
            ]),
            const SizedBox(height: Dimensions.paddingSizeLarge),
          ],
        ]),
      );
    });
  }
}

class _ContactItemWidget extends StatelessWidget {
  final IconData icon;
  final String? title;
  const _ContactItemWidget({
    required this.icon, this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Icon(icon, color: ColorResources.primaryColor),
      const SizedBox(width: Dimensions.paddingSizeSmall),

      Flexible(child: Text(
        title ?? '', maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikRegular,
      )),
    ]);
  }
}