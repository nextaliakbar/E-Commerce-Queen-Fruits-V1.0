import 'package:carousel_slider/carousel_slider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/banner_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({super.key});

  @override
  State<StatefulWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final CarouselSliderController _mainBannerController = CarouselSliderController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Column(children: [
      Consumer<BannerProvider>(builder: (context, bannerProvider, child) {
        return bannerProvider.bannerList == null ? const _BannerShimmer() :
        (bannerProvider.bannerList?.isNotEmpty ?? false)
            ? Container(
            decoration: const BoxDecoration(),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.
                paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
            child: Text("Spesial hari ini", style: rubikBold.copyWith(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: Dimensions.fontSizeDefault
            ))
        )
        ,

        SizedBox(
          height: 130,
          child: Stack(alignment: Alignment.bottomCenter, children: [
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
          child: CarouselSlider.builder(
            disableGesture: false,
            itemCount: bannerProvider.bannerList!.length <= 10 ? bannerProvider.bannerList!.length : 10,
            carouselController: _mainBannerController,
            options: CarouselOptions(
              height: 120,
              viewportFraction: 1,
              initialPage: _currentIndex,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              onPageChanged: (index, _) {
              _currentIndex = index;

              if(mounted) {
              setState(() {});
              }
            },
            scrollDirection: Axis.horizontal
          ),
          itemBuilder: (context, index, realIndex) {
          return Material(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            clipBehavior: Clip.hardEdge,
            color: Colors.transparent,
            child: InkWell(
            onTap: () {
            if(bannerProvider.bannerList![index].productId != null) {
            Product? product;

            for(Product prod in bannerProvider.productList) {
              if(prod.id == bannerProvider.bannerList![index].productId) {
                product = prod;
                break;
              }
            }

              // if(product != null) {
              //   showModalBottomSheet(
              //     isDismissible: true,
              //     backgroundColor: Colors.transparent,
              //     isScrollControlled: true,
              //     useSafeArea: true,
              //     context: context,
              //     builder: (ctx) => CartBottomSheetWidget(
              //      product: product,
              //      fromImportProduct: true,
              //      callback: (CartModel model) {
              //
              //      },
              //     )
              //   );
              // }

            } else if(bannerProvider.bannerList![index].categoryId != null) {

            }
        },
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
          ),
          child: ClipRRect(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          child: CustomImageWidget(
              placeholder: Images.placeholderImage, width: double.infinity, height: 120,
              fit: BoxFit.cover,
              image: '${splashProvider.baseUrls!.bannerImageUrl}/${bannerProvider.bannerList![index].image}',
            )))));
        })),
        Positioned(bottom: 8, child: Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: List.generate(bannerProvider.bannerList!.length <= 10 ? bannerProvider.bannerList!.length : 10, (index) => Container(
           width: _currentIndex == index ? Dimensions.paddingSizeLarge : 5,
           height: 5,
           margin: const EdgeInsets.symmetric(horizontal: 2),
           decoration: BoxDecoration(
             borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
             color: _currentIndex == index
                 ? ColorResources.primaryColor : ColorResources.primaryColor.withOpacity(0.3),
           )))
        ))])
        )])
        ) : const SizedBox();
      })
    ]);
  }
}

class _BannerShimmer extends StatelessWidget {
  const _BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(
        context, listen: false);

    return Shimmer(
      duration: const Duration(seconds: 2),
      enabled: bannerProvider.bannerList == null,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault,
              vertical: Dimensions.paddingSizeSmall),
          child: Container(
            height: Dimensions.paddingSizeLarge,
            width: 150,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .shadowColor
                    .withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
            ),
          ),
        ),

        SizedBox(height: 130, child: Row(children: [
          const SizedBox(width: Dimensions.paddingSizeLarge),

          Expanded(flex: 7, child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .shadowColor
                      .withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault)
              )
          )),

          const SizedBox(width: Dimensions.paddingSizeSmall),

          Expanded(flex: 3,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                Expanded(child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .shadowColor
                            .withOpacity(0.2),
                        borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(Dimensions.radiusDefault))
                    )
                )),

                const SizedBox(height: Dimensions.paddingSizeLarge),

                Container(
                  height: 10,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                      color: Theme
                          .of(context)
                          .shadowColor
                          .withOpacity(0.4),
                      borderRadius: BorderRadius.circular(
                          Dimensions.radiusDefault)
                  ),
                )
              ]))
        ]))
      ]),
    );
  }
}