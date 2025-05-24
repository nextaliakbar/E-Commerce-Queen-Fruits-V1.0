import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/ordered_product_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class OrderItemWidget extends StatelessWidget {
  final OrderModel orderModel;
  final bool isRunning;
  final OrderProvider orderProvider;
  final bool isAddDate;

  const OrderItemWidget({
    super.key,
    required this.orderModel,
    required this.isRunning,
    required this.orderProvider,
    required this.isAddDate
  });

  @override
  Widget build(BuildContext context) {
    String status = orderModel.orderStatus! == 'pending' ? 'Tertunda' : orderModel.orderStatus! == 'confirmed' ? 'Dikonfirmasi'
    : orderModel.orderStatus! == 'processing' ? 'Diproses' : orderModel.orderStatus! == 'out_for_delivery' ? 'Dalam Pengiriman'
    : orderModel.orderStatus! == 'delivered' ? 'Terkirim' : orderModel.orderStatus! == 'canceled' ? 'Dibatalkan'
    : orderModel.orderStatus! == 'returned' ? 'Dikembalikan' : orderModel.orderStatus! == 'failed' ? 'Gagal' : 'Selesai';
    String? paymentMethod = orderModel.paymentMethod! == 'offline_payment' ? 'Transfer Bank' : '';
    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
      if(!isRunning && isAddDate)
        Padding(
          padding: const EdgeInsets.only(left:Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
          child: Text(DateConverterHelper.estimatedDate(DateTime.parse(orderModel.deliveryDate!)), style: rubikRegular.copyWith(
            color: Theme.of(context).hintColor,
            fontSize: Dimensions.fontSizeDefault,
          )),
        ),

      Container(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.only(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: InkWell(
          onTap: ()=> RouterHelper.getOrderDetailsRoute('${orderModel.id}'),
          child: Column(children: [

            isRunning
                ? Row(children: [

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  OrderedProductImageWidget(orderModel: orderModel),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                flex: 3,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      '#${orderModel.id.toString()}',
                      style: rubikBold.copyWith(color: ColorResources.primaryColor),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(
                        color: ColorResources.buttonBackgroundColorMap['${orderModel.orderStatus}'],
                        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                      ),
                      child: Text(
                        status,style: rubikSemiBold.copyWith(color: ColorResources.buttonTextColorMap['${orderModel.orderStatus}'], fontSize: Dimensions.fontSizeSmall),
                      ),
                    ),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text(
                      '${orderModel.detailsCount} produk',
                      style: rubikRegular.copyWith(color: Theme.of(context).hintColor.withOpacity(0.7), fontSize: Dimensions.fontSizeSmall),
                    ),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    // Text('Estimasi pesanan tiba', style: rubikSemiBold.copyWith(
                    //   color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeExtraSmall,
                    // )),
                  ]),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    Text( PriceConverterHelper.convertPrice((orderModel.orderAmount ?? 0) + (orderModel.deliveryCharge ?? 0)), style: rubikBold),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    // Text(DateConverterHelper.getEstimateTime(timerProvider.getEstimateDuration(orderItem, context) ?? const Duration(), context) , style: rubikBold.copyWith(color: Theme.of(context).primaryColor)),
                  ]),

                ]),
              ),

            ])
                : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

              Expanded(
                flex: 3,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                  Text(
                    'Pesanan #${orderModel.id.toString()}',
                    style: rubikBold.copyWith(color: ColorResources.primaryColor, fontSize: Dimensions.fontSizeLarge),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Text(PriceConverterHelper.convertPrice((orderModel.deliveryCharge ?? 0) + (orderModel.orderAmount ?? 0)), style: rubikBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge
                  )),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Text(paymentMethod, style: rubikSemiBold),

                ]),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall, vertical: Dimensions.paddingSizeExtraSmall),
                    decoration: BoxDecoration(
                      color: ColorResources.buttonBackgroundColorMap['${orderModel.orderStatus}'],
                      borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                    ),
                    child: Text(
                      status,style: rubikSemiBold.copyWith(
                          color: ColorResources.buttonTextColorMap['${orderModel.orderStatus}'],
                          fontSize: Dimensions.fontSizeSmall
                      ),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  OrderedProductImageWidget(orderModel: orderModel),

                ]),
              ),

            ]),

          ]),
        ),
      ),

    ]);

  }
}
