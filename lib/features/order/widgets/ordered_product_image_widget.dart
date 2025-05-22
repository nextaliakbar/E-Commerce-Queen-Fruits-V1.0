import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class OrderedProductImageWidget extends StatelessWidget {
  final OrderModel orderModel;
  const OrderedProductImageWidget({super.key, required this.orderModel});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: (orderModel.productImageList?.length ?? 0) > 1 ? 2 : 1,
        crossAxisSpacing: Dimensions.paddingSizeExtraSmall,
        mainAxisSpacing: Dimensions.paddingSizeExtraSmall,
        childAspectRatio: (orderModel.productImageList?.length ?? 0) == 2 ? 0.8 : 1,
      ),
      itemCount: min((orderModel.productImageList?.length ?? 0), 4),
      itemBuilder: (context, index) => (index < 3 ) || (orderModel.productImageList?.length ?? 0) == 4  ? ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        child: CustomImageWidget(
          image: '${splashProvider.configModel?.baseUrls?.productImageUrl}/${orderModel.productImageList?[index]}',
          height: 30, width: 30,
        ),
      ) : const Card(
        margin: EdgeInsets.zero,
        elevation: 0.5,
        child: SizedBox(height: 30, width: 30, child: Center(child: Text('+4'))),
      ),
    );
  }
}
