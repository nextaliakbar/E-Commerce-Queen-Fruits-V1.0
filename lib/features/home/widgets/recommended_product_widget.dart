import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_single_child_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/product_shimmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/title_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/quantity_position.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendedProductWidget extends StatefulWidget {

  const RecommendedProductWidget({super.key});

  @override
  State<StatefulWidget> createState()=> _RecommendedProductWidgetState();
}

class _RecommendedProductWidgetState extends State<RecommendedProductWidget> {

  final CarouselSliderController sliderController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return (productProvider.recommendedProductModel == null) ? Center(
          child: Container(
            width: Dimensions.webScreenWidth,
            padding: EdgeInsets.only(left: 0),
            child: ProductShimmerWidget(
                isEnabled: productProvider.popularLocalProductModel == null,
                isList: true),
          ),
        )
            : (productProvider.recommendedProductModel?.products?.isEmpty ?? true) ? const SizedBox() : Column(children: [
            Container(
            color: Theme.of(context).cardColor,
            padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeSmall),
            width: Dimensions.webScreenWidth,
            child: TitleWidget(
              title: "Rekomendasi produk",
              // isShowLeadingIcon: true,
              // leadingIcon: null,
              ),
            ),

            Center(child: SizedBox(
              width: 800,
              child: (productProvider.recommendedProductModel?.products?.length ?? 0) > 3 ? CarouselSlider.builder(
                  itemCount: productProvider.recommendedProductModel?.products?.length,
                  carouselController: sliderController,
                  options: CarouselOptions(
                    height: 360,
                    viewportFraction: 0.65,
                    enlargeFactor: 1,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    scrollDirection: Axis.horizontal
                  ),
                  itemBuilder: (context, index, realIndex) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                      child: ProductCardWidget(
                        product: productProvider.recommendedProductModel!.products![index],
                        imageHeight: 220,
                        imageWidth: double.maxFinite,
                        quantityPosition: QuantityPosition.center,
                        productGroup: ProductGroup.recommendedProduct,
                      ),
                    );
                  },
              ) : Center(
                child: CustomSingleChildListWidget(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.recommendedProductModel?.products?.length ?? 0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    itemBuilder: (index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: SizedBox(height: 360, width: 220, child: ProductCardWidget(
                          product: productProvider.recommendedProductModel!.products![index],
                          imageHeight: 220,
                          imageWidth: double.maxFinite,
                          quantityPosition: QuantityPosition.center,
                          productGroup: ProductGroup.recommendedProduct,
                        )),
                    )
                ),
              )
            ))
        ]);
      })
    ]);
  }
}