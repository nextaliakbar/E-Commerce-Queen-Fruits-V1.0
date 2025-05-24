import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class PaymentMethodView extends StatelessWidget {
  final Function(int index) onTap;
  final List<PaymentMethod> paymentList;
  final JustTheController? toolTip;

  const PaymentMethodView({
    super.key, required this.onTap, required this.paymentList, this.toolTip
  });

  @override
  Widget build(BuildContext context) {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return SingleChildScrollView(child: ListView.builder(
      itemCount: paymentList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index){
        bool isSelected = paymentList[index] == checkoutProvider.paymentMethod;
        // bool isOffline = paymentList[index].type == 'offline';
        bool isOffline = true;
        return InkWell(
          onTap: isSelected && isOffline ? null : ()=> onTap(index),
          child: Container(
            decoration: BoxDecoration(
                color: isSelected ? ColorResources.primaryColor.withOpacity(0.05) : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
            ),
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeLarge),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween , children: [


                Row(children: [
                  Container(
                    height: Dimensions.paddingSizeLarge, width: Dimensions.paddingSizeLarge,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: isSelected ? Theme.of(context).secondaryHeaderColor : Theme.of(context).cardColor,
                        border: Border.all(color: Theme.of(context).disabledColor)
                    ),
                    child: Icon(Icons.check, color: Theme.of(context).cardColor, size: 16),
                  ),
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                  Image.asset(
                    Images.offlinePayment,  height: Dimensions.paddingSizeLarge, fit: BoxFit.contain,
                  ),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Text(
                    isOffline ? "Lihat Metode Pembayaran" : paymentList[index].getWayTitle ?? '',
                    style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
                  ),
                ]),
              ]),

              if(isOffline && isSelected && splashProvider.offlinePaymentModelList != null) SingleChildScrollView(
                padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraLarge),
                scrollDirection: Axis.horizontal,
                child: Row(mainAxisAlignment: MainAxisAlignment.start, children: splashProvider.offlinePaymentModelList!.map((offlineMethod) => InkWell(
                  onTap: () {
                    checkoutProvider.changePaymentMethod(offlinePaymentModel: offlineMethod);
                    checkoutProvider.setOfflineSelectedValue(null);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      border: Border.all(width: 2, color: checkoutProvider.selectedOfflineMethod == offlineMethod ? ColorResources.primaryColor.withOpacity(0.5,) : Colors.blue.withOpacity(0.05)) ,
                      borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    ),
                    child: Text(offlineMethod?.methodName ?? ''),
                  ),
                )).toList()),
              ),


              if(isOffline && checkoutProvider.selectedOfflineValue != null && isSelected ) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: Dimensions.paddingSizeDefault),

                Text("Informasi Pembayaran", style: rubikSemiBold,),
                const SizedBox(height: Dimensions.paddingSizeSmall),

                Column(children: checkoutProvider.selectedOfflineValue!.map((method) => Row(children: [
                  Flexible(child: Text(method.keys.single, style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  const SizedBox(width: Dimensions.paddingSizeSmall),

                  Flexible(child: Text(' :  ${method.values.single}', style: rubikRegular, maxLines: 1, overflow: TextOverflow.ellipsis)),
                ])).toList()),

              ]),

            ]),
          ),
        );
      },));
  }

}