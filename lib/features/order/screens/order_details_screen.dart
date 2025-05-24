import 'package:ecommerce_app_queen_fruits_v1_0/common/models/order_details_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_amount_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_details_shimmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_details_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderModel? orderModel;
  final int? orderId;
  final String? phoneNumber;

  const OrderDetailsScreen({
    super.key,
    required this.orderModel,
    required this.orderId,
    this.phoneNumber
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {

  final GlobalKey<ScaffoldMessengerState> _scaffold = GlobalKey();

  @override
  void initState() {
    super.initState();

    _loadData(context);
  }

  Future<void> _loadData(BuildContext context) async {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);

    ResponseModel? response = await orderProvider.trackOrder(
      widget.orderId.toString(),
      orderModel: widget.orderModel,
      fromTracking: false,
      phoneNumber: widget.phoneNumber
    );

    await orderProvider.getOrderDetails(
      widget.orderId.toString(),
      phoneNumber: widget.phoneNumber,
      isApiCheck: response != null && response.isSuccess
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      key: _scaffold,
      appBar: AppBar(
        title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text('Pesanan #${widget.orderId}', style: rubikSemiBold.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color,
          )),
          const SizedBox(height: Dimensions.paddingSizeSmall),

          Consumer<OrderProvider>(
              builder: (context, orderProvider, _) {
                return orderProvider.trackModel?.createdAt != null ? Text(DateConverterHelper.formatDate(
                  DateConverterHelper.isoStringToLocalDate(orderProvider.trackModel!.createdAt!), context,
                  isSecond: false,
                ), style: rubikRegular.copyWith(
                  color: Theme.of(context).hintColor,
                  fontSize: Dimensions.fontSizeSmall,
                )) : const SizedBox();
              }
          )

        ]),
        backgroundColor: Theme.of(context).cardColor,
        leading: IconButton(
          onPressed: () => context.pop(),
          color: ColorResources.primaryColor,
          highlightColor: Colors.transparent,
          icon: const Icon(Icons.arrow_back_ios),
        ),
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(children: [
       Expanded(child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Consumer<OrderProvider>(builder:
          (context, orderProvider, child) {
            double? deliveryCharge = 0;
            double itemsPrice = 0;
            double discount = 0;
            double tax = 0;
            double extraDiscount = 0;

            if(orderProvider.orderDetails != null && orderProvider.orderDetails!.isNotEmpty && (orderProvider.trackModel != null && orderProvider.trackModel?.id != -1)) {
              if(orderProvider.trackModel?.orderType == 'delivery') {
                deliveryCharge = orderProvider.trackModel!.deliveryCharge;
              }

              for(OrderDetailsModel orderDetails in orderProvider.orderDetails!) {
                itemsPrice = itemsPrice + (orderDetails.price! * orderDetails.quantity!);
                discount = discount = (orderDetails.discountOnProduct! * orderDetails.quantity!);
                tax = (tax + (orderDetails.taxAmount! * orderDetails.quantity!));
              }
            }

            if(orderProvider.trackModel != null && orderProvider.trackModel!.extraDiscount != null && orderProvider.trackModel?.id != -1) {
              extraDiscount = orderProvider.trackModel!.extraDiscount ?? 0.0;
            }

            double subtotal = itemsPrice + tax;
            double couponAmount = orderProvider.trackModel != null && orderProvider.trackModel?.id != -1 ? orderProvider.trackModel?.couponDiscountAmount ?? 0 : 0;
            double total = itemsPrice - discount - extraDiscount + tax + deliveryCharge! - couponAmount;
            debugPrint("Order details is not null ${orderProvider.orderDetails != null}");
            debugPrint("Track model is not null ${orderProvider.trackModel != null}");
            debugPrint("Order details is not empty ${orderProvider.orderDetails?.isNotEmpty}");
            return orderProvider.orderDetails == null || orderProvider.trackModel == null
              ? OrderDetailsShimmerWidget(enabled: !orderProvider.isLoading && orderProvider.orderDetails == null && orderProvider.trackModel == null)
              : (orderProvider.orderDetails?.isNotEmpty ?? false)
              ? Column(children: [
                const OrderDetailsWidget(),

                Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: OrderAmountWidget(
                   itemsPrice: itemsPrice,
                    tax: tax, subtotal: subtotal,
                    discount: discount, extraDiscount: extraDiscount,
                    deliveryCharge: deliveryCharge,
                    total: total, phoneNumber: widget.phoneNumber
                ))
              ]) : const Center(child: Text("Empty page"),);
          }))
       ]))
      ]),
    );
  }
}
