import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/cart_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/checkout_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/item_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {

  const CartScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBarWidget(context: context, title: "Keranjang", isBackButtonExist: false),
      body: Consumer<CheckoutProvider>(builder: (context, checkoutProvider, child) {
        return Consumer<CartProvider>(builder: (context, cartProvider, child) {
          List<bool> availableList = [];
          double itemPrice = 0;
          double discount = 0;
          double tax = 0;

          for(CartModel? cartModel in cartProvider.cartList) {
            availableList.add(DateConverterHelper.isAvailable(cartModel!.product!.availableTimeStarts!, cartModel.product!.availableTimeEnds!));

            itemPrice = itemPrice + (cartModel.price! * cartModel.quantity!);
            discount = discount + (cartModel.discountAmount! * cartModel.quantity!);

            tax = tax + (cartModel.taxAmount! * cartModel.quantity!);
          }

          double orderAmount = itemPrice;
          double subtotal = itemPrice + tax;
          double total = subtotal - discount;
          bool kmWiseCharge = CheckOutHelper.isKmCharge(deliveryInfoModel: splashProvider.deliveryInfoModel);

          return cartProvider.cartList.isNotEmpty ? Column(children: [
            Expanded(child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(children: [
                Center(child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: height < 600 ? height : height - 400),
                  child: SizedBox(width: Dimensions.webScreenWidth, child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

                    Expanded(flex: 2, child: Container(
                      decoration : const BoxDecoration(),
                      margin: const EdgeInsets.all(0),
                      padding: const EdgeInsets.all(0),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              /// Product
                              CartListWidget(cartProvider: cartProvider, availableList: availableList),
                              const SizedBox(height: Dimensions.paddingSizeLarge),
                          ]),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            ItemViewWidget(
                                title: "Harga Produk",
                                subTitle: PriceConverterHelper.convertPrice(itemPrice)
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            ItemViewWidget(
                                title: "Pajak",
                                subTitle: '(+) ${PriceConverterHelper.convertPrice(tax)}'
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            ItemViewWidget(
                                title: "Diskon",
                                subTitle: '(-) ${PriceConverterHelper.convertPrice(discount)}'
                            ),
                            const SizedBox(height: Dimensions.paddingSizeSmall),

                            Divider(color: Theme.of(context).hintColor.withOpacity(0.5)),

                            ItemViewWidget(
                                title: kmWiseCharge ? 'Total' : "Total Jumlah",
                                subTitle: PriceConverterHelper.convertPrice(total),
                                subTitleStyle: rubikSemiBold,
                            ),

                            const SizedBox(height: Dimensions.paddingSizeSmall)
                          ]),
                        )
                      ]),
                    )),

                  ])),
                )),
              ]),
            )),
              CheckOutButtonWidget(orderAmount: orderAmount, totalOrder: total),
          ]) : Row();
        });
      })
    );
  }
}