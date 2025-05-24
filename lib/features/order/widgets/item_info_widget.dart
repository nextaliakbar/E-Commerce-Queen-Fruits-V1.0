import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class ItemInfoWidget extends StatelessWidget {
  final OrderProvider orderProvider;
  final SplashProvider splashProvider;

  const ItemInfoWidget({super.key, required this.orderProvider, required this.splashProvider});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orderProvider.orderDetails!.length,
        itemBuilder: (context, index) {
          String variationText = '';

          if(orderProvider.orderDetails![index].variations != null && orderProvider.orderDetails![index].variations!.isNotEmpty) {
            for(Variation variation in orderProvider.orderDetails![index].variations!) {
              variationText += '${variationText.isNotEmpty ? ', ' : ''}${variation.name}';
              for(VariationValue value in variation.variationValues!) {
                variationText += '${variationText.endsWith('(') ? '' : ', '}${value.level} - ${value.optionPrice}';
              }
              variationText += ')';
            }
          } else if(orderProvider.orderDetails![index].oldVariations != null && orderProvider.orderDetails![index].oldVariations!.isNotEmpty) {
            variationText = orderProvider.orderDetails![index].oldVariations![0].type ?? '';
          }

          return orderProvider.orderDetails![index].productDetails != null ?
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                child: CustomImageWidget(
                  placeholder: Images.placeholderImage, height: 50, width: 50,
                  image: '${splashProvider.baseUrls!.productImageUrl}/'
                      '${orderProvider.orderDetails![index].productDetails!.image}',
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              ///Name Column
              Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(child: Text(
                    orderProvider.orderDetails![index].productDetails!.name!,
                    style: rubikSemiBold,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  )),
                ]),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Text(variationText, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),

              ])),

              ///Quantity Column
                Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(
                    'x ${orderProvider.orderDetails![index].quantity.toString()}',
                    style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
                  ),
                ])),

              Expanded(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [

                CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(orderProvider.orderDetails![index].price! - orderProvider.orderDetails![index].discountOnProduct!),
                  overflow: TextOverflow.ellipsis, maxLines: 1,
                  style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall),
                )),

                orderProvider.orderDetails![index].discountOnProduct! > 0 ? CustomDirectionalityWidget(child: Text(
                  PriceConverterHelper.convertPrice(orderProvider.orderDetails![index].price),
                  overflow: TextOverflow.ellipsis, maxLines: 1,
                  style: rubikSemiBold.copyWith(
                    decoration: TextDecoration.lineThrough,
                    fontSize: Dimensions.fontSizeSmall,
                    color: Theme.of(context).hintColor.withOpacity(0.7),
                  ),
                )) : const SizedBox(),
              ])),
            ]),

            const SizedBox.shrink(),

            const Padding(
              padding: EdgeInsets.only(top: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeSmall),
              child: Divider(height: 1),
            ),
          ]) : const SizedBox.shrink();
        },
      ),

      const SizedBox(height: Dimensions.paddingSizeSmall)
    ]);
  }
}
