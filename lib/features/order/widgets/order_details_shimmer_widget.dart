import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class OrderDetailsShimmerWidget extends StatelessWidget {
  final bool enabled;

  const OrderDetailsShimmerWidget({super.key, required this.enabled});

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.sizeOf(context).height;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(children: [

        ConstrainedBox(
          constraints: BoxConstraints(minHeight: height < 600 ? height : height - 400, maxWidth: Dimensions.webScreenWidth),
          child: SizedBox(width: Dimensions.webScreenWidth, child: Row(
            crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(flex: 3, child: Shimmer(
                enabled: enabled,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(
                      height: 160,
                      color: Theme.of(context).hintColor.withOpacity(0.2),
                      child: Center(child: Container(color: Theme.of(context).hintColor.withOpacity(0.4), width: 80, height: 80)),
                    ),

                    Container(
                      width: double.maxFinite,
                      transform: Matrix4.translationValues(0, -25, 0),
                      margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                      decoration: BoxDecoration(
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                        borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                        boxShadow: [BoxShadow(
                          color: Theme.of(context).shadowColor.withOpacity(0.5),
                          blurRadius: Dimensions.radiusDefault, spreadRadius: 1,
                          offset: const Offset(2, 2),
                        )],
                      ),
                      child: Row(children: [
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Container(
                            width: 200,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          Container(
                            width: 150,
                            height: 20,
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hintColor.withOpacity(0.5),
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                            ),
                          ),
                        ])),

                        Container(
                          width: 40, height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.5),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                        ),
                      ]),
                    ),

                    ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Container(
                          width: 180, height: 20,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeSmall),

                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                        Container(
                          height: 100,
                          margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hintColor.withOpacity(0.2),
                            borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 80, height: 80,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.5),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                              Container(
                                width: 100, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                              const SizedBox(height: Dimensions.paddingSizeSmall),

                              Container(
                                width: 80, height: 20,
                                margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).hintColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                                ),
                              ),
                            ])),

                            Container(
                              width: 40, height: 20,
                              margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),

                            Container(
                              width: 60, height: 20,
                              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                              decoration: BoxDecoration(
                                color: Theme.of(context).hintColor.withOpacity(0.3),
                                borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusDefault)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                      ]),
                    ),
                ]),
              )),
            ],
          )),
        ),
        const SizedBox(height: Dimensions.paddingSizeExtraLarge),
      ]),
    );
  }
}
