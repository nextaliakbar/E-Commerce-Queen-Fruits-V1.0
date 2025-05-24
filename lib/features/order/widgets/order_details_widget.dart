import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/delivery_info_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/delivery_man_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/item_info_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_status_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/payment_info_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderDetailsWidget extends StatelessWidget {
  final int? orderId;

  const OrderDetailsWidget({super.key, this.orderId});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    return Consumer<OrderProvider>(
        builder: (context, order, _) {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

            OrderStatusWidget(orderModel: order.trackModel),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
              child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Informasi Pengiriman", style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusSmall,
                      spreadRadius: 1, offset: const Offset(2, 2),
                    )],
                  ),
                  // padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
                  child: const DeliveryInfoWidget(),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                Text("Informasi Produk", style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [BoxShadow(
                      color: Theme.of(context).shadowColor.withOpacity(0.5),
                      blurRadius: Dimensions.radiusSmall, spreadRadius: 1, offset: const Offset(2, 2),
                    )],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: ItemInfoWidget(orderProvider: order, splashProvider: splashProvider),
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                if(order.trackModel?.deliveryMan != null) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Kurir", style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child:  DeliveryManWidget(deliveryMan: order.trackModel!.deliveryMan!),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeLarge),
                ]),

                Text("Informasi Pembayaran", style: rubikBold),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    boxShadow: [
                      BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2)),
                    ],
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                  child: PaymentInfoWidget(orderProvider: order),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                if(order.trackModel?.orderNote?.isNotEmpty ?? false) ...[
                  Text("Catatan Pengiriman", style: rubikBold),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                      boxShadow: [BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2),
                      )],
                    ),
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                      Text(order.trackModel?.orderNote ?? '', style: rubikRegular.copyWith(color: Theme.of(context).hintColor)),
                    ]),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),
                ],
                const SizedBox(height: Dimensions.paddingSizeSmall),
              ]),
            ),
          ]);
        }
    );
  }
}
