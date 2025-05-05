import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class RatingBarWidget extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBarWidget({super.key, required this.rating, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return rating > 0 ? Row(mainAxisSize: MainAxisSize.min, children: [
      Text(rating.toStringAsFixed(1), style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeSmall)),
      const SizedBox(width: Dimensions.paddingSizeExtraSmall),

      Icon(Icons.star, color: ColorResources.secondaryColor, size: size)
    ]) : const SizedBox();
  }
}