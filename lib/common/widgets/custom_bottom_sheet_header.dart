import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomBottomSheetHeader extends StatelessWidget {
  final String? title;
  final bool? showDragBar;
  final bool? showCloseButton;
  final double? titleSize;
  final FontWeight? titleWeight;

  const CustomBottomSheetHeader({
    super.key,
    this.title,
    this.showDragBar = true,
    this.showCloseButton = true,
    this.titleSize,
    this.titleWeight
  });

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [

      const SizedBox(height: Dimensions.paddingSizeSmall),
      if(showDragBar ?? false)
        Center(child: Container(
          width: 35, height: 4, decoration: BoxDecoration(
          color: Theme.of(context).hintColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        )),

        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          if(title != null)
            Text(title ?? '', style: rubikSemiBold.copyWith(
              fontSize: titleSize ?? Dimensions.fontSizeSmall,
              fontWeight: titleWeight,
            )),

          if(showCloseButton!)
            InkWell(
              onTap: () => context.pop(),
              child: Icon(Icons.close, size: Dimensions.paddingSizeDefault, color: Theme.of(context).hintColor),
            ),
        ]),

    ]);

  }
}
