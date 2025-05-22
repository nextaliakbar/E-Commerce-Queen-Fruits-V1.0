import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class ItemViewWidget extends StatelessWidget {
  final String title;
  final String subTitle;
  final TextStyle? titleStyle;
  final TextStyle? subTitleStyle;

  const ItemViewWidget({
    super.key,
    required this.title,
    required this.subTitle,
    this.titleStyle,
    this.subTitleStyle
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: titleStyle ?? rubikSemiBold),

      CustomDirectionalityWidget(child: Text(subTitle, style: subTitleStyle ?? rubikRegular))
    ]);
  }
}