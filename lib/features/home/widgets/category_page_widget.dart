import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryPageWidget extends StatefulWidget {
  final CategoryProvider categoryProvider;
  final PageController pageController;

  const CategoryPageWidget({
    super.key, required this.categoryProvider,
    required this.pageController
  });

  @override
  State<StatefulWidget> createState()=> _CategoryPageWidgetState();
}

class _CategoryPageWidgetState extends State<CategoryPageWidget> {
  int initialLength = 8;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final length = 8;
    int totalPage = (widget.categoryProvider.categoryList!.length / length).ceil();
    List<int> totalPageIndexList = [];

    for(int i = 0; i < totalPage; i++) {
      totalPageIndexList.add(i);
    }

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Column(mainAxisSize: MainAxisSize.min, children: [
      const SizedBox(height: Dimensions.paddingSizeDefault),

      Center(child: Text("Kategori produk", textAlign: TextAlign.center, style: rubikBold.copyWith(
        fontSize: Dimensions.fontSizeDefault,
        color: ColorResources.homePageSectionTitleColor
      ))),

      const SizedBox(height: Dimensions.paddingSizeSmall),

      Expanded(child: PageView.builder(
        controller: widget.pageController,
        physics: const BouncingScrollPhysics(),
        itemCount: totalPage,
        onPageChanged: (index) {
          debugPrint("Click category item 1");
          widget.categoryProvider.updatedProductCurrentIndex(index, totalPage);
        },
        itemBuilder: (context, index) {
          initialLength = length;
          currentIndex = length * index;

          if(index + 1 == totalPage) {
            initialLength = widget.categoryProvider.categoryList!.length - (index * length);
          }

          return GridView.builder(
            itemCount: initialLength,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, mainAxisExtent: 110
            ),
            padding: EdgeInsets.zero,
            itemBuilder: (context, i) {
              int currentIndex0 = i + currentIndex;
              String? name = widget.categoryProvider.categoryList![currentIndex0].name;

              return Column(mainAxisSize: MainAxisSize.min, children: [
                  InkWell(
                    onTap: (){
                      debugPrint("Click category item 2");
                      RouterHelper.getCategoryRoute(widget.categoryProvider.categoryList![currentIndex0]);
                    } ,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                    child: Container(
                      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                        boxShadow: [BoxShadow(
                          color: Colors.white,
                          spreadRadius: Dimensions.radiusSmall, blurRadius: Dimensions.radiusLarge
                        )]
                      ),
                      child: CustomImageWidget(
                        height: 45, width: 45,
                        image: splashProvider.baseUrls != null
                        ? '${splashProvider.baseUrls!.categoryImageUrl}/${widget.categoryProvider.categoryList![currentIndex0].image}' : '',
                      ),
                    ),
                  ),
                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                
                Text(name!, maxLines: 1, textAlign: TextAlign.center, style: rubikSemiBold.copyWith(
                 fontSize: Dimensions.fontSizeSmall
                ))
              ]);
            },
          );
        },
      )),

      Row(mainAxisAlignment: MainAxisAlignment.center, children: totalPageIndexList.map((index) {
        return Container(
          width: currentIndex == index * length ? Dimensions.paddingSizeDefault : Dimensions.paddingSizeExtraSmall,
          height: Dimensions.paddingSizeExtraSmall,
          margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
            color: currentIndex == index * length
              ? ColorResources.primaryColor : ColorResources.primaryColor.withOpacity(0.3)
          ),
        );
      }).toList())
    ]);
  }
}