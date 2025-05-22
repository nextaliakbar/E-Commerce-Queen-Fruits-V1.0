import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';

class CustomDialogShapeWidget extends StatelessWidget {
  final Widget? child;
  final double? maxHeight;
  final double? maxWidth;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const CustomDialogShapeWidget({
    super.key, this.child, this.maxHeight, this.maxWidth,
    this.padding, this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return Stack(children: [
      Container(
        constraints: BoxConstraints(maxHeight: maxHeight ?? height * 0.85, maxWidth: maxWidth ?? 500),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(
            top: const Radius.circular(Dimensions.radiusLarge),
          ),
        ),
        padding: padding ?? EdgeInsets.symmetric(
          horizontal:  Dimensions.paddingSizeLarge,
          vertical: Dimensions.paddingSizeExtraSmall,
        ),
        margin: margin ?? EdgeInsets.all(0),
        child: child,
      ),
    ]);
  }
}
