import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/no_data_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/paginated_lis_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/product_shimmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;
  final String? categoryBannerImage;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.categoryBannerImage
  });

  @override
  State<StatefulWidget> createState()=> _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin{
  int _tabIndex = 0;
  String _type = 'all';
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  Future<void> _loadData() async {
    final categoryProvider = Provider.of<CategoryProvider>(context, listen: false);

    categoryProvider.getCategoryList(false);
    categoryProvider.getSubCategoryList(widget.categoryId);
  }

  @override
  void dispose() {
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    final Size size = MediaQuery.of(context).size;
    final double realSpaceNeeded = (size.width - Dimensions.webScreenWidth) / 2;
    debugPrint("Category Banner Image : ${splashProvider.baseUrls?.categoryImageUrl}/${widget.categoryBannerImage}");
    return Scaffold(
      body: Consumer<CategoryProvider>(builder: (context, categoryProvider, child) {
          return categoryProvider.isLoading || categoryProvider.categoryList == null
              ? _categoryShimmer(context, size.height, categoryProvider) : PaginatedListWidget(
              scrollController: scrollController,
              onPaginate: (int? offset) async {
                await categoryProvider.getCategoryProductList('${categoryProvider.selectedSubCategoryId}', offset ?? 1);
              },
              totalSize: categoryProvider.categoryProductModel?.totalSize,
              offset: categoryProvider.categoryProductModel?.offset,
              limit: categoryProvider.categoryProductModel?.limit,
              builder: (Widget loaderWidget) => Expanded(child: CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    surfaceTintColor: Colors.transparent,
                    backgroundColor: Theme.of(context).cardColor,
                    expandedHeight: 200,
                    toolbarHeight: 50 + MediaQuery.of(context).padding.top,
                    pinned: true,
                    floating: false,
                    leading: SizedBox(
                      width: size.width,
                      child: IconButton(
                          onPressed: ()=> context.pop(),
                          icon: const Icon(Icons.chevron_left, color: Colors.white)
                      ),
                    ),
                    flexibleSpace: Container(
                      color: Theme.of(context).canvasColor,
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      child: FlexibleSpaceBar(
                        title: Text(widget.categoryName ?? '', style: rubikSemiBold.copyWith(
                          fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).cardColor
                        )),

                        titlePadding: EdgeInsets.only(
                          bottom: 54 + (MediaQuery.of(context).padding.top / 2),
                          left: 50, right: 50
                        ),
                        background: Container(
                          height: 50, width: MediaQuery.of(context).size.width,
                          margin: const EdgeInsets.only(bottom: 50),
                          child: CustomImageWidget(
                            placeholder: Images.categoryBanner, fit: BoxFit.cover,
                            // image: '${splashProvider.baseUrls?.categoryImageUrl}/${widget.categoryBannerImage}',
                            image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls?.categoryBannerImageUrl}&file=${widget.categoryBannerImage}',
                          ),
                        ),
                      ),
                    ),
                    bottom: PreferredSize(
                      preferredSize: const Size.fromHeight(30.0),
                      child: categoryProvider.subCategoryList != null ? Container(
                        width: size.width,
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.05),
                              blurRadius: 10, spreadRadius: 0, offset: const Offset(0, 10)
                            )
                          ]
                        ),
                        child: TabBar(
                          dividerColor: Colors.transparent,
                          controller: TabController(
                            initialIndex: _tabIndex,
                            length: categoryProvider.subCategoryList!.length + 1,
                            vsync: this
                          ),
                          isScrollable: true,
                          unselectedLabelColor: Theme.of(context).hintColor.withOpacity(0.7),
                          indicatorWeight: 3,
                          indicatorSize: TabBarIndicatorSize.label,
                          indicatorColor: ColorResources.primaryColor,
                          labelColor: Theme.of(context).textTheme.bodyLarge!.color,
                          tabs: _tabs(categoryProvider),
                          onTap: (int index) {
                            _type = 'all';
                            _tabIndex = index;

                            if(index == 0) {
                              categoryProvider.getCategoryProductList(widget.categoryId, 1);
                            } else {
                              categoryProvider.getCategoryProductList(categoryProvider.subCategoryList![index-1].id.toString(), 1);
                            }
                          },
                        ),
                      ) : const SizedBox()
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                    sliver: categoryProvider.categoryProductModel == null || (categoryProvider.categoryProductModel?.products?.isNotEmpty ?? false)
                    ? SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: Dimensions.paddingSizeSmall,
                          mainAxisSpacing: Dimensions.paddingSizeSmall,
                          mainAxisExtent: 260
                        ),
                        itemCount: categoryProvider.categoryProductModel == null ? 10 : categoryProvider.categoryProductModel!.products!.length,
                        itemBuilder: (context, index) {
                          if(categoryProvider.categoryProductModel == null) {
                            return const ProductShimmerWidget(
                              isEnabled: true,
                              isList: false,
                              width: double.maxFinite,
                            );
                          }

                          return ProductCardWidget(
                            product: categoryProvider.categoryProductModel!.products![index],
                            imageWidth: 260,
                          );

                        }
                    ) : const SliverToBoxAdapter(child: NoDataWidget()),
                  )
                ],
              ))
          );
      }),
    );
  }

  SingleChildScrollView _categoryShimmer(BuildContext context, double height, CategoryProvider categoryProvider) {
    return SingleChildScrollView(child: Column(children: [
      ConstrainedBox(
        constraints: BoxConstraints(minHeight: height < 600 ? height : height - 400),
        child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
          Shimmer(
              duration: const Duration(seconds: 3),
              enabled: true,
              child: Container(height: 200, width: double.infinity, color: Theme.of(context).shadowColor)
            ),
          GridView.builder(
              shrinkWrap: true,
              itemCount: 10,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                crossAxisCount: 2,
                mainAxisExtent: 260
              ),
              itemBuilder: (context, index) {
                return ProductShimmerWidget(isEnabled: categoryProvider.categoryProductModel == null, isList: false, width: double.maxFinite);
              }
          )
        ]))),
      )
    ]));
  }

  List<Tab> _tabs(CategoryProvider categoryProvider) {
    List<Tab> tabList = [];
    tabList.add(const Tab(text: 'Semua'));
    for(var subCategory in categoryProvider.subCategoryList!) {
      tabList.add(Tab(text: subCategory.name));
    }

    return tabList;
  }
}