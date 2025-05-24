import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/offline_payment_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wallet/widgets/add_fund_dialogue_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';
import 'package:provider/provider.dart';

class PaymentMethodBottomSheetWidget extends StatefulWidget {
  final double totalPrice;
  const PaymentMethodBottomSheetWidget({super.key, required this.totalPrice});

  @override
  State<PaymentMethodBottomSheetWidget> createState() => _PaymentMethodBottomSheetWidgetState();
}

class _PaymentMethodBottomSheetWidgetState extends State<PaymentMethodBottomSheetWidget> {
  bool notHideOffline = true;

  final JustTheController? toolTip = JustTheController();

  List<PaymentMethod> paymentList = [];

  @override
  void initState() {
    super.initState();
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final ConfigModel configModel = Provider.of<SplashProvider>(context,listen: false).configModel!;

    checkoutProvider.setPaymentIndex(null, isUpdate: false);
    checkoutProvider.setOfflineSelectedValue(null, isUpdate: false);
    Future.delayed(const Duration(milliseconds: 500)).then((value) {
      checkoutProvider.changePaymentMethod(isClear: true, isUpdate: true);
    });

    if(configModel.isOfflinePayment! && notHideOffline) {
      paymentList.add(PaymentMethod(
        getWay: 'offline',
        getWayTitle: 'Offline',
        type: 'offline',
        getWayImage: Images.offlinePayment
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(child: SizedBox(width: 550, child: Column(mainAxisSize: MainAxisSize.min, children: [

        Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.8),
          width: 550,
          margin: const EdgeInsets.only(top: kIsWeb ? 0 : 30),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusExtraLarge))
          ),
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingSizeExtraLarge,
            vertical: Dimensions.paddingSizeLarge,
          ),
          child: Consumer<CheckoutProvider>(
              builder: (ctx, checkoutProvider, _) {
                return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      height: 4, width: 35,
                      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                      decoration: BoxDecoration(color: Theme.of(context).disabledColor, borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: Dimensions.paddingSizeDefault),

                  if(paymentList.isNotEmpty) Row(children: [
                    Text("Pembayaran", style: rubikBold.copyWith(fontSize: Dimensions.fontSizeDefault)),
                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                    // Expanded(
                    //   child: Text('Cara yang lebih cepat dan aman untuk pembayaran', style: robotoRegular.copyWith(
                    //     fontSize: Dimensions.fontSizeExtraSmall, color: Theme.of(context).hintColor,
                    //   )),
                    // ),

                  ]),
                  const SizedBox(height: Dimensions.paddingSizeLarge),

                  Flexible(child: PaymentMethodView(
                      toolTip: toolTip,
                      paymentList: paymentList,
                      onTap: (index){
                        if(notHideOffline &&  paymentList[index].type == 'offline'){
                          checkoutProvider.changePaymentMethod(digitalMethod: paymentList[index]);
                        }
                      }
                  )),
                  const SizedBox(height: Dimensions.paddingSizeExtraLarge),


                  SafeArea(child: CustomButtonWidget(
                    btnTxt: "Pilih",
                    onTap: checkoutProvider.paymentMethodIndex == null
                        && checkoutProvider.paymentMethod == null
                        || (checkoutProvider.paymentMethod != null && checkoutProvider.paymentMethod?.type == 'offline' && checkoutProvider.selectedOfflineMethod == null)
                        ? null : () {
                      if(checkoutProvider.paymentMethod?.type == 'offline'){
                        if(checkoutProvider.selectedOfflineValue != null){
                          checkoutProvider.setOfflineSelect(true);
                          context.pop();
                        }else{
                          showDialog(context: context, builder: (ctx)=> OfflinePaymentWidget(totalAmount: widget.totalPrice));
                        }

                      }
                    },
                  )),

                ]);
              }
          ),
        ),
      ]))),
    );
  }
}
