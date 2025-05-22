import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomShadowWidget extends StatelessWidget {
  final Widget child;

  final EdgeInsets? padding;

  final EdgeInsets? margin;

  final double? borderRadius;

  const CustomShadowWidget({
    super.key, required this.child,
    this.padding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.borderRadius = Dimensions.radiusDefault
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(borderRadius!),
        boxShadow: [
          BoxShadow(offset: const Offset(0, 5), blurRadius: 15, spreadRadius: -3, color: ColorResources.primaryColor.withOpacity(0.01)),

          BoxShadow(offset: const Offset(0, 0), blurRadius: 3, color: ColorResources.primaryColor.withOpacity(0.02))
        ]
      ),

      child: child,
    );
  }
}