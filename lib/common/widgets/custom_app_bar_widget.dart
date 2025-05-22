import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;
  final BuildContext? context;
  final Widget? actionView;
  final bool centerTitle;
  final bool isTransparent;
  final double elevation;
  final Widget? leading;
  final Color? titleColor;

  const CustomAppBarWidget({
    super.key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
    this.context,
    this.actionView,
    this.centerTitle = true,
    this.isTransparent = false,
    this.elevation = 0,
    this.leading,
    this.titleColor
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!,
        style: rubikSemiBold.copyWith(
            fontSize: Dimensions.fontSizeLarge,
            color: titleColor ?? (isTransparent ? ColorResources.primaryColor : Theme.of(context).textTheme.bodyLarge!.color))
      ),
      centerTitle: centerTitle,
      leading: isBackButtonExist ? IconButton(
        icon: leading ?? const Icon(Icons.arrow_back_ios, color: ColorResources.primaryColor),
        color: titleColor ?? (isTransparent ? Theme.of(context).cardColor : ColorResources.primaryColor),
        onPressed: ()=> onBackPressed != null ? onBackPressed!() : context.pop(),
      ) : const SizedBox(),
      actions: actionView != null ? [
        Padding(
          padding: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
          child: actionView!,
        )
      ] : [],
      backgroundColor: isTransparent? Colors.transparent : Theme.of(context).cardColor,
      elevation: elevation,
    );
  }

  @override
  Size get preferredSize => Size(double.maxFinite, 50);
}