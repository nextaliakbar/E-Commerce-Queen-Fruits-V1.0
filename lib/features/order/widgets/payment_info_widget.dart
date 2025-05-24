import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class PaymentInfoWidget extends StatelessWidget {
  final OrderProvider orderProvider;

  const PaymentInfoWidget({super.key, required this.orderProvider});

  @override
  Widget build(BuildContext context) {
    debugPrint("Payment method : ${orderProvider.trackModel?.paymentMethod}");
    bool isExpansion = orderProvider.trackModel?.paymentMethod == 'offline_payment';
    debugPrint("IS Expansions $isExpansion");

    return Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [

      ExpansionTile(

        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        expandedAlignment: Alignment.centerLeft,
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        shape: Border.all(color: Colors.transparent, width: 0.001),
        iconColor: ColorResources.primaryColor,
        collapsedIconColor: ColorResources.primaryColor,
        textColor: Theme.of(context).textTheme.bodyMedium?.color,
        leading: CustomAssetImageWidget(Images.payment, width: 30, height: 30, color: Colors.black),
        title: Text("Sumber Pembayaran",style: rubikRegular,),
        subtitle: isExpansion ?  Text(
          '${orderProvider.trackModel?.offlinePaymentInformation?.paymentName}',
          style: rubikRegular.copyWith(color: Theme.of(context).hintColor),
        ) : null,
        trailing: isExpansion ? null : const SizedBox(),

        children: orderProvider.trackModel?.offlinePaymentInformation?.methodInformation != null
            ? orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.map((item) => Column(
          children: [
            _KeyValueItemWidget(
              item: item.key ?? '',
              value: item.value ?? '',
            ),

            if(orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.indexOf(item)
                == orderProvider.trackModel!.offlinePaymentInformation!.methodInformation!.length -1
                && (orderProvider.trackModel?.offlinePaymentInformation?.paymentNote?.isNotEmpty ?? false))
              _KeyValueItemWidget(
                item: "Catatan",
                value: orderProvider.trackModel?.offlinePaymentInformation?.paymentNote ?? '',
                maxLines: 3,
              ),
          ],
        )).toList() : [],
      ),

    ]);

  }
}

class _KeyValueItemWidget extends StatelessWidget {
  final String item;
  final String value;
  final int maxLines;

  const _KeyValueItemWidget({
    super.key,
    required this.item,
    required this.value,
    this.maxLines = 1
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(flex : 1, child: Text(item, style: poppinsRegular,maxLines: 1, overflow: TextOverflow.ellipsis)),
        const SizedBox(width: Dimensions.paddingSizeSmall),

        Expanded(flex: 2, child: Text(' :  $value',
          style: poppinsRegular, maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        )),
      ]),
    );
  }
}

