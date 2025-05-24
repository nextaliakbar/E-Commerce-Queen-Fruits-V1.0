import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_item_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderListWidget extends StatelessWidget {
  final bool isRunning;

  const OrderListWidget({super.key, required this.isRunning});

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(builder: (context, orderProvider, child) {
        List<OrderModel>? orderList;
        List<DateTime> dateTimeList = [];

        if(orderProvider.runningOrderList != null) {
          orderList = isRunning ? orderProvider.runningOrderList : orderProvider.historyOrderList;
        }
        debugPrint("Order list is null ${orderList == null} & order list is empty ${orderList?.isEmpty}");
        debugPrint("Order list length ${orderList?.length}");
        return orderList != null ? orderList.isNotEmpty ? RefreshIndicator(
          onRefresh: () async {
            await Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
          },
          backgroundColor: ColorResources.primaryColor,
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(children: [
              Center(
                child: SizedBox(
                  width: Dimensions.webScreenWidth,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    itemCount: orderList.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {

                      // DateTime originalDateTime = DateConverterHelper.getDateOnly(orderList![index].deliveryDate!);
                      // DateTime convertedDate = DateTime(originalDateTime.year, originalDateTime.month, originalDateTime.day);
                      // bool addTitle = false;
                      //
                      // if(!dateTimeList.contains(convertedDate)) {
                      //   addTitle = true;
                      //   dateTimeList.add(convertedDate);
                      // }
                      return OrderItemWidget(orderProvider: orderProvider, isRunning: isRunning, orderModel: orderList![index], isAddDate: false);
                    },
                  ),
                ),
              ),
            ]),
          ),
        ) : const SizedBox() : const SizedBox();
    });
  }
}
