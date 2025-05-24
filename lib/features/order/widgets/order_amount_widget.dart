import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_divider_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/item_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderAmountWidget extends StatefulWidget {
  final double itemsPrice;
  final double tax;
  final double subtotal;
  final double discount;
  final double extraDiscount;
  final double? deliveryCharge;
  final double total;
  final String? phoneNumber;

  const OrderAmountWidget({
    super.key,
    required this.itemsPrice,
    required this.tax,
    required this.subtotal,
    required this.discount,
    required this.extraDiscount,
    required this.deliveryCharge,
    required this.total,
    required this.phoneNumber
  });

  @override
  State<OrderAmountWidget> createState() => _OrderAmountWidgetState();
}

class _OrderAmountWidgetState extends State<OrderAmountWidget> {

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    return Column(children: [
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: 5, spreadRadius: 1, offset: const Offset(2, 2))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeDefault),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        child: Column(children: [

          ItemViewWidget(
            title: "Harga Produk",
            subTitle: PriceConverterHelper.convertPrice(widget.itemsPrice),
          ),


          ItemViewWidget(
            title: "Diskon",
            subTitle: '(-) ${PriceConverterHelper.convertPrice(widget.discount)}',
          ),


          ItemViewWidget(
            title: "Pajak/PPN",
            subTitle: '(+) ${PriceConverterHelper.convertPrice(widget.tax)}',
          ),

          ///....Extra discount..
          if(widget.extraDiscount > 0) Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ItemViewWidget(
              title: "Extra Diskon",
              subTitle: '(-) ${PriceConverterHelper.convertPrice(widget.extraDiscount)}',
              titleStyle: poppinsRegular.copyWith(fontSize: Dimensions.fontSizeLarge),
            ),
          ),

          // ItemViewWidget(
          //   title: "Diskon Kupon",
          //   subTitle: '(-) ${PriceConverterHelper.convertPrice(orderProvider.trackModel?.couponDiscountAmount ?? 0)}',
          // ),

          ItemViewWidget(
            title: "Biaya Pengiriman",
            subTitle: '(+) ${PriceConverterHelper.convertPrice(widget.deliveryCharge)}',
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
            child: CustomDividerWidget(),
          ),

          ItemViewWidget(
            title: "Total Jumlah",
            subTitle: PriceConverterHelper.convertPrice(widget.total),
            titleStyle: rubikSemiBold.copyWith(color: ColorResources.primaryColor),
            subTitleStyle: rubikSemiBold.copyWith(color: ColorResources.primaryColor),
          ),

          const SizedBox(),

        ]),
      ),
    ]);
  }
}
