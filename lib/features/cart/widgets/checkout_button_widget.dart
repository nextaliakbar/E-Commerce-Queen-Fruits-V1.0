import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckOutButtonWidget extends StatelessWidget {
  final double orderAmount;
  final double totalOrder;

  const CheckOutButtonWidget({
    super.key,
    required this.orderAmount,
    required this.totalOrder
  });

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    return ((splashProvider.configModel?.selfPickup ?? false) || (splashProvider.configModel?.homeDelivery ?? false)) ? Container(
      width: Dimensions.webScreenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      child: CustomButtonWidget(btnTxt: "Lanjutkan ke pembayaran", onTap: () {
        if(authProvider.isLoggedIn()){
          if(orderAmount < (splashProvider.configModel?.minimumOrderValue ?? 0)) {
            showCustomSnackBarHelper('Minimal pemesanan adalah ${PriceConverterHelper.convertPrice(splashProvider.configModel!
                .minimumOrderValue)}, kamu mempunyai ${PriceConverterHelper.convertPrice(orderAmount)} di keranjangmu, silahkan tambahkan lebih banyak');
          } else {
            RouterHelper.getCheckoutRoute(totalOrder, 'cart', '');
          }
        } else{
          showCustomSnackBarHelper("Silahkan masuk terlebih dahulu");
        }
      }),
    ) : const SizedBox();
  }
}