import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/category_page_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryWebWidget extends StatefulWidget {
  const CategoryWebWidget({super.key});

  @override
  State<StatefulWidget> createState()=> _CategoryWebWidgetState();
}

class _CategoryWebWidgetState extends State<CategoryWebWidget> {
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, categoryProvider, _) {
      return categoryProvider.categoryList == null ? const _CategoryShimmer() :
          categoryProvider.categoryList!.isNotEmpty ? Container(
            decoration: BoxDecoration(
              color: ColorResources.tertiaryColor,
              borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
            ),
            height: 290,
            child: CategoryPageWidget(
                categoryProvider: categoryProvider,
                pageController: pageController
            ),
          ) : const SizedBox();
    });
  }
}

class _CategoryShimmer extends StatelessWidget {
  const _CategoryShimmer();

  @override
  Widget build(BuildContext context) {
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    return SizedBox(height: 260, width: Dimensions.webScreenWidth, child: Center(child: Column(children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
        alignment: Alignment.center,
        child: Shimmer(
          duration: const Duration(seconds: 2),
          enabled: categoryProvider.categoryList == null,
          child: Container(
            height: Dimensions.paddingSizeLarge,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Theme.of(context).shadowColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
            ),
          ),
        ),
      ),

      const SizedBox(height: Dimensions.paddingSizeSmall),

      Expanded(child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisExtent: 100
          ),
          itemCount: 7,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Container(margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault), child: Shimmer(
              duration: const Duration(seconds: 2),
              enabled: categoryProvider.categoryList == null,
              child: Column(children: [
                Container(
                  height: 50, width: 50,
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    color: Theme.of(context).shadowColor.withOpacity(0.3)
                  ),
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                Container(height: 10, width: 50, color: Theme.of(context).shadowColor.withOpacity(0.5))
              ])
              )
            );
          }
      ))
    ])));
  }
}