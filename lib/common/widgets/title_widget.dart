import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class TitleWidget extends StatelessWidget {
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final bool isShowLeadingIcon;
  final bool isShowTrailingIcon;
  final String? title;
  final String? subTitle;
  final Function? onTap;

  const TitleWidget({
    super.key, required this.title, this.onTap, this.subTitle,
    this.leadingIcon, this.isShowLeadingIcon = false,
    this.trailingIcon, this.isShowTrailingIcon = false
  });

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(mainAxisSize: MainAxisSize.min, children: [
        if(isShowLeadingIcon && leadingIcon != null)...[
          const SizedBox(width: Dimensions.paddingSizeSmall),
          leadingIcon ?? const SizedBox(),
          const SizedBox(width: Dimensions.paddingSizeSmall)
        ],

        Text(title!, style: rubikBold.copyWith(color: ColorResources.homePageSectionTitleColor))
      ]),

      if(isShowTrailingIcon && trailingIcon != null) trailingIcon!,

      if(onTap != null && !isShowTrailingIcon) InkWell(
        onTap: onTap as void Function()?,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          child: Text(
            subTitle ?? 'Lihat semua',
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.homePageSectionTitleColor)
          ),
        ),
      )
    ]);
  }
}