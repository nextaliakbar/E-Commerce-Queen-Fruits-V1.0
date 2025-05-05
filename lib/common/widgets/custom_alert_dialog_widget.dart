import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class CustomAlertDialogWidget extends StatelessWidget {
    final String? image;
    final IconData? icon;
    final String? title;
    final String? subtitle;
    final String? leftButtonText;
    final String? rightButtonText;
    final Function? onPressLeft;
    final Function? onPressRight;
    final Color? iconColor;
    final Widget? child;
    final bool isLoading;
    final bool isSingleButton;
    final double? widht;
    final double? height;
    final bool isPadding;

    const CustomAlertDialogWidget({
      super.key, this.image, this.icon, this.title,
      this.subtitle, this.leftButtonText, this.rightButtonText,
      this.onPressLeft, this.onPressRight, this.iconColor,
      this.child, this.isLoading = false, this.isSingleButton = false,
      this.widht, this.height, this.isPadding = true
    });

    @override
  Widget build(BuildContext context) {
    return _CustomerAlertDialogShape(
      width: widht,
      height: height,
      isPadding: isPadding,
      child: child ?? Container(
        padding: const EdgeInsets.symmetric(
          vertical: Dimensions.paddingSizeLarge,
          horizontal: Dimensions.paddingSizeSmall
        ),
        width: MediaQuery.sizeOf(context).width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [

          if(image != null) CustomAssetImageWidget(image!, width: 50),

          if(icon != null) Icon(icon!, size: 50, color: iconColor ?? Theme.of(context).colorScheme.error),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(title != null) Text(title!, style: rubikBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge), textAlign: TextAlign.center),

          const SizedBox(height: Dimensions.paddingSizeDefault),

          if(subtitle != null) Text(subtitle!, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeLarge), textAlign: TextAlign.center),

          const SizedBox(height: 50),

          Row(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
            if(!isSingleButton) Flexible(child: SizedBox(
              width: null,
              child: CustomButtonWidget(
                backgroundColor: Theme.of(context).disabledColor.withOpacity(0.2),
                btnTxt: leftButtonText ?? "Tidak",
                textStyle: rubikSemiBold.copyWith(color: Theme.of(context).textTheme.titleMedium?.color, fontSize: Dimensions.fontSizeLarge),
                onTap: isLoading ? null : onPressLeft ?? ()=> Navigator.pop(context),
              ),
            )),

            if(!isSingleButton) const SizedBox(width: Dimensions.paddingSizeDefault),

            Flexible(child: SizedBox(
              width: null,
              child: CustomButtonWidget(
                isLoading: isLoading,
                btnTxt: rightButtonText ?? 'Ya',
                onTap: onPressRight ?? ()=> Navigator.pop(context),
              ),
            ))

          ])
        ])
      ),
    );
  }
}

class _CustomerAlertDialogShape extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final bool isPadding;

  const _CustomerAlertDialogShape({
    required this.child, this.width,
    this.height, this.isPadding = true
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
      padding: isPadding ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.only(top: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).canvasColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(height: 4, width: 40, decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
            borderRadius: BorderRadius.circular(25)
          )),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          child
        ],
      ),
    );
  }
}