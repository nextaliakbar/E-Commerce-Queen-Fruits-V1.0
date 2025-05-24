import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeliveryInfoWidget extends StatelessWidget {
  const DeliveryInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: Column(children: [

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          CustomAssetImageWidget(Images.storeLocationSvg, width: 20, height: 20, color: Theme.of(context).primaryColor),
          const SizedBox(width: Dimensions.paddingSizeDefault),

          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("Dari", style: rubikRegular),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Text(orderProvider.trackModel?.branches?.name ?? '', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
          ])),
        ]),

        if(orderProvider.trackModel?.orderType == OrderType.delivery.name && (orderProvider.trackModel?.deliveryAddress?.address?.isNotEmpty ?? false)) ...[
          const Divider(height: Dimensions.paddingSizeLarge),

          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            CustomAssetImageWidget(Images.locationPlaceMarkSvg, width: 20, height: 20, color: Theme.of(context).secondaryHeaderColor),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: [
              Text("Tujuan", style: rubikRegular),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              Text(orderProvider.trackModel?.deliveryAddress?.address ?? '', style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
            ])),
          ]),
        ],

      ]),
    );
  }
}
