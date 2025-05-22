import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/item_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CostSummeryWidget extends StatelessWidget {
  final bool kmWiseCharge;
  final double? deliveryCharge;
  final double? subtotal;

  const CostSummeryWidget({
    super.key, required this.kmWiseCharge,
    this.deliveryCharge, this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(
        builder: (context, checkoutProvider, _) {
          bool isTakeAway = checkoutProvider.orderType == OrderType.takeAway;

          return Column(children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                Align(alignment: Alignment.center,
                  child: Text("Ringkasan Biaya", style: rubikBold.copyWith(
                    fontSize: Dimensions.fontSizeDefault,
                    fontWeight: FontWeight.w600,
                  )),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                const Divider(thickness: 0.08, color: Colors.black),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                ItemViewWidget(
                  title: "Subtotal",
                  subTitle: PriceConverterHelper.convertPrice(subtotal),
                  titleStyle: rubikSemiBold,
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                if(!isTakeAway) ItemViewWidget(
                  title: "Biaya Pengiriman",
                  subTitle: (!isTakeAway || checkoutProvider.distance != -1) ?
                  '(+) ${PriceConverterHelper.convertPrice( isTakeAway ? 0 : deliveryCharge)}'
                      : "Tidak ada"!,
                  titleStyle: rubikSemiBold,
                ),

                const Divider(thickness: 0.08, color: Colors.black),
                /*const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: CustomDividerWidget(),
              ),*/
              ]),
            ),

          ]);
        }
    );
  }
}
