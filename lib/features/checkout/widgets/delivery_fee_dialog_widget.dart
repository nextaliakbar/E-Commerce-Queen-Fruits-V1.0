import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_divider_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/item_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeliveryFeeDialogWidget extends StatelessWidget {
  final double? amount;
  final double distance;
  final Function(double amount)? callBack;

  const DeliveryFeeDialogWidget({super.key, required this.amount, required this.distance, this.callBack});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    double deliveryCharge = CheckOutHelper.getDeliveryCharge(
        googleMapStatus: splashProvider.configModel?.googleMapStatus ?? 0,
        distance: distance, shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0.0,
        minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble() ?? 0,
        isTakeAway: checkoutProvider.orderType == OrderType.takeAway,
        minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0
    );

    return Consumer<OrderProvider>(builder: (context, order, child) {

      if(callBack != null) {
        callBack!(deliveryCharge);
      }

      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: Column( mainAxisSize: MainAxisSize.min, children: [

            Container(
              height: 70, width: 70,
              decoration: BoxDecoration(
                color: ColorResources.primaryColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.delivery_dining,
                color: ColorResources.primaryColor, size: 50,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),

            Column(children: [
              Text(
                'Biaya pengirim dari alamat yang dipilih dari cabang',
                style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              CustomDirectionalityWidget(child: Text(
                PriceConverterHelper.convertPrice(deliveryCharge),
                style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge),
              )),

              const SizedBox(height: 20),

              ItemViewWidget(
                title: 'Subtotal',
                subTitle: PriceConverterHelper.convertPrice(amount),
              ),
              const SizedBox(height: 10),

              ItemViewWidget(
                title: 'Biaya Pengiriman',
                subTitle:  '(+) ${PriceConverterHelper.convertPrice(deliveryCharge)}',
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                child: CustomDividerWidget(),
              ),

              ItemViewWidget(
                title: 'Total Jumlah',
                subTitle:   PriceConverterHelper.convertPrice((amount ?? 0.0) + deliveryCharge),
                titleStyle: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: ColorResources.primaryColor),
              ),

            ]),
            const SizedBox(height: 30),

            CustomButtonWidget(btnTxt: 'Ok', onTap: () {
              context.pop();
            }),

          ]),
        ),
      );
    });
  }
}