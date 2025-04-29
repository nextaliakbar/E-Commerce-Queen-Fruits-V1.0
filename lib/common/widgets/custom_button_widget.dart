import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final TextStyle? textStyle;
  final Color? backgroundColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final bool transparent;
  final EdgeInsets? margin;
  final IconData? iconData;
  final bool isLoading;

  const CustomButtonWidget({
    super.key, this.onTap, required this.btnTxt,
    this.backgroundColor, this.textStyle,
    this.borderRadius = 10, this.width, this.transparent = false,
    this.height, this.margin, this.isLoading = false,
    this.iconData
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final ButtonStyle flatButtonStyle = TextButton.styleFrom(
      backgroundColor: onTap == null ? Theme.of(context).disabledColor : transparent
          ? Colors.transparent :backgroundColor ?? ColorResources.primaryColor,
      minimumSize: Size(width != null ? width !: Dimensions.webScreenWidth, height != null ? height! : 50),

      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius)
      )
    );

    return TextButton(
        onPressed: isLoading ? null : onTap as void Function()?,
        style: flatButtonStyle,
        child: isLoading?
            Center(
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                const SizedBox(
                  height: 15,
                  width: 15,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    strokeWidth: 2,
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text("Loading", style: rubikBold.copyWith(color: Colors.white))
              ]),
            ) :
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(iconData, color: Colors.white, size: iconData != null ? 20 : 0),

              SizedBox(width: iconData != null ? Dimensions.paddingSizeSmall : 0),

              Text(btnTxt ?? "", style: textStyle ?? rubikSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeLarge))
            ])
    );
  }
}