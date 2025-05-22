import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';

class CardButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String image;
  final String title;

  const CardButtonWidget({
    super.key,
    required this.image,
    required this.title,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110, height: 80,
      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
      child: Material(
        clipBehavior: Clip.hardEdge,
        color: Theme.of(context).cardColor,
        elevation: 7,
        shadowColor: Theme.of(context).shadowColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(Dimensions.paddingSizeDefault),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            child: Column(mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center, children: [
              CustomAssetImageWidget(image, height: 25, width: 25, color: Theme.of(context).hintColor),

              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text(title, style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall))
            ]),
          ),
        ),
      ),
    );
  }
}