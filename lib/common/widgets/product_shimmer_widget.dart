import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ProductShimmerWidget extends StatelessWidget {
  final bool isList;
  final bool isEnabled;
  final double height;
  final double width;

  const ProductShimmerWidget({
    super.key, required this.isEnabled, this.height = 250, this.width = 180, required this.isList
  });

  @override
  Widget build(BuildContext context) {
    return isList ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
       Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Shimmer(enabled: isEnabled, child: Container(
         height: 20, width: 150,
         decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
           color: Theme.of(context).shadowColor.withOpacity(0.3)
         ), 
        )),
        
        Padding(
          padding: EdgeInsets.only(right: 0),
          child: Shimmer(enabled: isEnabled, child: Container(
            height: 20, width: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
              color: Theme.of(context).shadowColor.withOpacity(0.3)
            ),
          )),
        ) 
       ]),
       
       const SizedBox(height: Dimensions.paddingSizeLarge),
       
       SizedBox(height: height, child: ListView.builder(
         shrinkWrap: true,
         physics: const NeverScrollableScrollPhysics(),
         scrollDirection: Axis.horizontal,
         padding: EdgeInsets.zero,
         itemCount: 8,
         itemBuilder: (context, index) {
           return _ShimmerCardItem(isEnabled: isEnabled, width: width);
         },
       )) 
      ]
    ) : _ShimmerGridCardItem(isEnabled: isEnabled, width: width);
  }
}

class _ShimmerGridCardItem extends StatelessWidget {
  final bool isEnabled;
  final double width;

  const _ShimmerGridCardItem({super.key, required this.isEnabled, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
}

class _ShimmerCardItem extends StatelessWidget {
  final bool isEnabled;
  final double width;
  
  const _ShimmerCardItem({super.key, required this.isEnabled, required this.width});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall, bottom: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Shimmer(
        duration: const Duration(seconds: 1), interval: const Duration(seconds: 1),
        enabled: isEnabled, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Container(
           height: 140, width: width,
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
             color: Theme.of(context).shadowColor.withOpacity(0.3)
           ),
         ) 
      ]),
      ),
    );
  }
}