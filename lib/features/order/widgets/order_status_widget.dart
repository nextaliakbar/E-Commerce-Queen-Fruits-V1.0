import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/enums/order_status.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class OrderStatusWidget extends StatelessWidget {
  final OrderModel? orderModel;

  const OrderStatusWidget({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Container(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        color: ColorResources.primaryColor.withOpacity(0.07),
        child: Center(child: CustomAssetImageWidget(_getOrderStatusImage(), width: 120)),
      ),

      Container(
        transform: Matrix4.translationValues(0, -25, 0),
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
          boxShadow: [BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.5),
            blurRadius: Dimensions.radiusDefault, spreadRadius: 1,
            offset: const Offset(2, 2),
          )],
        ),
        child: _StatusWidget(orderModel: orderModel),
      ),
    ]);
  }

  String _getOrderStatusImage() {
    String? image;
    if(orderModel?.orderStatus == OrderStatus.processing.name || orderModel?.orderStatus == OrderStatus.confirmed.name) {
      image = Images.processingAnimation;
    }else if(orderModel?.orderStatus == OrderStatus.pending.name ){
      image = Images.pendingAnimation;
    }else if(orderModel?.orderStatus == 'out_for_delivery') {
      image = Images.outForDeliveryAnimation;
    }else if(orderModel?.orderStatus == OrderStatus.delivered.name
        || orderModel?.orderStatus == OrderStatus.completed.name
    ){
      image = Images.confirmedDeliveryAnimation;
    }else if(orderModel?.orderStatus == OrderStatus.canceled.name){
      image = Images.canceledDeliveryAnimation;
    }else if (orderModel?.orderStatus == OrderStatus.failed.name ||  orderModel?.orderStatus == OrderStatus.returned.name){
      image = Images.failedDeliveryAnimation;
    }
    return image ?? "";
  }
}

class _StatusWidget extends StatelessWidget {
  final OrderModel? orderModel;

  const _StatusWidget({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    String orderStatus = orderModel?.orderStatus == 'pending' ? 'Tertunda'
      : orderModel?.orderStatus == 'confirmed' ? 'Dikonfirmasi'
      : orderModel?.orderStatus == 'processing' ? 'Diproses'
      : orderModel?.orderStatus == 'out_for_delivery' ? 'Dalam Pengiriman'
      : orderModel?.orderStatus == 'delivered' ? 'Terkirim'
      : orderModel?.orderStatus == 'returned' ? 'Dikembalikan'
      : orderModel?.orderStatus == 'failed' ? 'Gagal' : 'Selesai';

    double? estimateTime = orderModel?.predictionDurationTimeOrder != null
        && orderModel?.predictionDurationTimeOrder?.predictionDurationResult != null
        ? (orderModel!.predictionDurationTimeOrder!.predictionDurationResult! / 60) > 60
        ? orderModel!.predictionDurationTimeOrder!.predictionDurationResult! / 60
        : orderModel!.predictionDurationTimeOrder!.predictionDurationResult! : null;

    return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(flex: 8, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Pesananmu $orderStatus',
          style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.primaryColor),
        ),
        const SizedBox(height: Dimensions.paddingSizeSmall),

        !(orderModel?.orderStatus == 'delivered' || orderModel?.orderStatus == 'returned' || orderModel?.orderStatus == 'failed'
          || orderModel?.orderStatus == 'canceled' || orderModel?.orderStatus == 'completed') && estimateTime != null ? RichText(text: TextSpan(
          text: "Estimasi pesanan akan tiba dalam ",
          style: rubikRegular.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color),
          children: <TextSpan>[

            TextSpan(text: estimateTime > 60 ? '$estimateTime Jam'  : '$estimateTime Menit', style: rubikSemiBold.copyWith(color: ColorResources.primaryColor))
          ],
        )): const SizedBox(),

        const SizedBox()

      ])),
      const SizedBox(width: Dimensions.paddingSizeDefault),
    ]);
  }
}

