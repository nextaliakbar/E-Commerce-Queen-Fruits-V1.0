import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryManWidget extends StatelessWidget {
  final DeliveryMan deliveryMan;

  const DeliveryManWidget({super.key, required this.deliveryMan});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Row(children: [

      ClipOval(child: CustomImageWidget(
        image: '${splashProvider.baseUrls?.deliveryManImageUrl}/${deliveryMan.image}',
        width: 50, height: 50,
      )),
      const SizedBox(width: Dimensions.paddingSizeDefault),

      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${deliveryMan.fName} ${deliveryMan.lName}', style: rubikRegular, maxLines: 2, overflow: TextOverflow.ellipsis),
        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

        if((deliveryMan.rating?.isNotEmpty ?? false) && (deliveryMan.rating?.first.avarage ??  0) > 0)Row(children: [
          Text('${deliveryMan.rating?.first.avarage}', style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall)),
          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

          Icon(Icons.star, color: Theme.of(context).primaryColor, size: Dimensions.fontSizeSmall),
        ]),
      ])),

      Center(child: Row(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: [
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.5), offset: const Offset(0, 5),
              spreadRadius: 5, blurRadius: 15,
            )],
          ),
          child: InkWell(
            onTap: () => launchUrl(Uri.parse('tel:${deliveryMan.phone}'), mode: LaunchMode.externalApplication),

            child: const CustomAssetImageWidget(Images.callIcon, width: 30, height: 30),
          ),
        ),
      ])),

    ]);
  }
}
