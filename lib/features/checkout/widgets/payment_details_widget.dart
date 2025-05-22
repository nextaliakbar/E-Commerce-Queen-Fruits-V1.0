import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentDetailsWidget extends StatelessWidget {
  final double total;
  const PaymentDetailsWidget({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      bool showPayment = checkoutProvider.selectedOfflineValue != null && checkoutProvider.isOfflineSelected;
      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusDefault)],
        ),
        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: Column(children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text("Metode Pembayaran", style: rubikBold.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              fontWeight: FontWeight.w600,
            )),

            TextButton(
              onPressed: ()=> ResponsiveHelper.showDialogOrBottomSheet(context, PaymentMethodBottomSheetWidget(totalPrice: total)),
              child: Text("Ubah", style: rubikBold.copyWith(
                color: ColorResources.primaryColor,
                fontSize: Dimensions.fontSizeSmall,
              )),
            ),
          ]),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          const Divider(thickness: 0.5),

          if(showPayment) SelectedPaymentView(total: total),

        ]),
      );
    });
  }
}

class SelectedPaymentView extends StatelessWidget {
  final double total;

  const SelectedPaymentView({super.key, required this.total});

  @override
  Widget build(BuildContext context) {
    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);

    return  Container(
      decoration: ResponsiveHelper.isDesktop(context) ? BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        color: Theme.of(context).cardColor,
        border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.3), width: 1),
      ) : const BoxDecoration(),
      padding: EdgeInsets.symmetric(
        vertical: Dimensions.paddingSizeSmall,
        horizontal: ResponsiveHelper.isDesktop(context) ? Dimensions.radiusDefault : 0,
      ),

      child: Column(children: [
        Row(children: [
          Image.asset(
            Images.offlinePayment,
            width: 20, height: 20,
          ),

          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(child: Text('Bayar offline (${checkoutProvider.selectedOfflineMethod?.methodName})',
            style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.primaryColor),
          )),

          Text(
            PriceConverterHelper.convertPrice(total), textDirection: TextDirection.ltr,
            style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge, color: ColorResources.primaryColor),
          )

        ]),

        if(checkoutProvider.selectedOfflineValue != null) Padding(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
          child: Column(children: checkoutProvider.selectedOfflineValue!.map((method) => Padding(
            padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
            child: Row(children: [
              Flexible(child: Text(method.keys.single, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Flexible(child: Text(' :  ${method.values.single}', style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
            ]),
          )).toList()),
        ),
      ]),
    );

  }
}

