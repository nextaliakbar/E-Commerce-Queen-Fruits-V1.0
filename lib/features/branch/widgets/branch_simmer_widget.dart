import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BranchSimmerCardWidget extends StatelessWidget {
  
  final bool isEnabled;
  
  const BranchSimmerCardWidget({super.key, required this.isEnabled});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: Dimensions.paddingSizeSmall),
      width: 370,
      child: Shimmer(enabled: isEnabled, child: Stack(children: [
        
        Container(
          margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: Theme.of(context).shadowColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
          ),
          
          child: Column(children: [
            Expanded(flex: 2, child: ClipRRect(
             borderRadius: const BorderRadius.only(
               topRight: Radius.circular(Dimensions.radiusDefault),
               topLeft: Radius.circular(Dimensions.radiusDefault)
             ), 
            ))
          ]),
        )
      ]))
    );
  }
}