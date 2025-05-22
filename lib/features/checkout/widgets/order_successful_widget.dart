import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/screen/order_successful_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulWidget extends StatelessWidget {
  final OrderSuccessfulScreen widget;
  final bool success;
  final double total;
  final Size size;

  const OrderSuccessfulWidget({
    super.key,
    required this.widget,
    required this.success,
    required this.total,
    required this.size
  });

  @override
  Widget build(BuildContext context) {
    final OrderProvider orderProvider = Provider.of<OrderProvider>(context, listen: false);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        child: Center(child: SizedBox(
          width: Dimensions.webScreenWidth,
          child: orderProvider.isLoading ? const CircularProgressIndicator() :  Column(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                height: 100, width: 100,
                decoration: BoxDecoration(
                  color: ColorResources.primaryColor.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.status == 0 ? Icons.check_circle : widget.status == 1 ? Icons.sms_failed : widget.status == 2 ? Icons.question_mark : Icons.cancel,
                  color: ColorResources.primaryColor, size: 80,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeLarge),


              Text(
                widget.status == 0 ? 'Pesanan berhasil dibuat' : widget.status == 1 ? 'pembayaran gagal' : widget.status == 2 ? 'Pesanan gagal dibuat' : 'Pembayaran dibatalkan',
                style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              if(widget.status == 0) Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('ID Pesanan:', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)),
                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                Text('${widget.orderId}', style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
              ]),
              const SizedBox(height: 30),

              const SizedBox.shrink() ,

              const SizedBox(height: Dimensions.paddingSizeDefault),

              SizedBox(
                width: size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                  child: CustomButtonWidget(
                    btnTxt: "Kembali ke beranda",
                    onTap: ()=> RouterHelper.getDashboardRouter('home', action: RouteAction.pushNameAndRemoveUntil),
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }
}
