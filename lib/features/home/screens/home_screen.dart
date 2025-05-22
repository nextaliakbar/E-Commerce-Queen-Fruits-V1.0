import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/branch_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/customizable_space_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/paginated_lis_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/sliver_delegate_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/title_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/frequently_bought_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/banner_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/banner_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/category_web_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/import_product_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/local_product_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/recommended_product_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/providers/wishlist_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final bool fromAppBar;

  const HomeScreen(this.fromAppBar, {super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();

  static Future<void> loadData(bool reload, {bool isFcmUpdate = false}) async {
    final ProductProvider productProvider = Provider.of<ProductProvider>(Get.context!, listen: false);
    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);
    final BannerProvider bannerProvider = Provider.of<BannerProvider>(Get.context!, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
    final WishlistProvider wishlistProvider = Provider.of<WishlistProvider>(Get.context!, listen: false);
    final SearchProvider searchProvider = Provider.of<SearchProvider>(Get.context!, listen: false);
    final FrequentlyBoughtProvider frequentlyBoughtProvider = Provider.of<FrequentlyBoughtProvider>(Get.context!, listen: false);

    final isLogin = Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn();

    if(isLogin) {
      profileProvider.getUserInfo(reload, isUpdate: reload);

      if(isFcmUpdate) {
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
      }
    } else {
      profileProvider.setUserInfoModel = null;
    }

    wishlistProvider.initWishList();

    if(productProvider.latestProductModel == null || reload) {
      productProvider.getLatestProductList(1, reload);
    }


    if(reload || productProvider.popularLocalProductModel == null) {
      productProvider.getPopularLocalProductList(1, true, isUpdate: false);
    }

    // if(reload) {
    //   splashProvider.getPolicyPage();
    // }

    categoryProvider.getCategoryList(reload);


    if(productProvider.importProductModel == null || reload) {
      productProvider.getImportProductList(1, reload);
    }

    if(productProvider.recommendedProductModel == null || reload) {
      productProvider.getRecommendedProductList(1, reload);
    }

    bannerProvider.getBannerList(reload);
    searchProvider.getSearchRecommendedProduct();
    // frequentlyBoughtProvider.getFrequentlyBoughtProduct(1, reload);
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> drawerGlobalKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final ScrollController _localProductScrollController = ScrollController();
  final ScrollController _importProductScrollController = ScrollController();
  final ScrollController _branchListScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);
    branchProvider.getBranchValueList(context);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.dispose();
    _localProductScrollController.dispose();
    _importProductScrollController.dispose();
    _branchListScrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: drawerGlobalKey,
      endDrawerEnableOpenDragGesture: false,
      drawer: const SizedBox(),
      appBar: null,
      body: RefreshIndicator(
          onRefresh: () async {
            Provider.of<OrderProvider>(context, listen: false).changeStatus(true, notify: true);
            Provider.of<SplashProvider>(context, listen: false).initConfig(context, DataSourceEnum.client).then((value) {
              if(value != null) {
                HomeScreen.loadData(true);
              }
            });
          },
        backgroundColor: ColorResources.primaryColor,
        color: Theme.of(context).cardColor,
        child: Consumer<ProductProvider>(builder: (context, productProvider, _) => PaginatedListWidget(
            scrollController: _scrollController,
            onPaginate: (int? offset) async {
              await productProvider.getLatestProductList(offset ?? 1, false);
            },
            totalSize: productProvider.latestProductModel?.totalSize,
            offset: productProvider.latestProductModel?.offset,
            builder: (loaderWidget) {
              return Expanded(child: CustomScrollView(controller: _scrollController, slivers: [
                SliverAppBar(
                  pinned: true, toolbarHeight: Dimensions.paddingSizeDefault,
                  automaticallyImplyLeading: false,
                  expandedHeight: 70,
                  floating: false, elevation: 0,
                  backgroundColor: ColorResources.primaryColor,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.zero, centerTitle: true, expandedTitleScale: 1,
                    title: CustomizableSpaceBarWidget(builder: (context, scrollingRate) => Center(child:
                      Container(
                        width: Dimensions.webScreenWidth,
                        color: ColorResources.primaryColor,
                        padding: const EdgeInsets.only(top: 30),
                        margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: Opacity(
                          opacity: (1 - scrollingRate),
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                            if(scrollingRate < 0.01) Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                             // const SizedBox(height: Dimensions.paddingSizeSmall),
                             Text("Lokasimu saat ini", style: rubikSemiBold.copyWith(color: Colors.white)),

                              Row(children: [
                               Consumer<LocationProvider>(builder: (context, locationProvider, _) => Text(
                                   (locationProvider.currentAddress?.isNotEmpty ?? false)
                                       ? (locationProvider.currentAddress!.length > 35 ? '${locationProvider.currentAddress!.substring(0, 35)}...'
                                       : locationProvider.currentAddress!) : 'Belum tersedia',
                                 style: rubikSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                                 maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center,
                               )),
                               //  Text("Belum tersedia", style: rubikSemiBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
                               //      maxLines: 1, overflow: TextOverflow.ellipsis, textAlign: TextAlign.center),
                               // const SizedBox(width: Dimensions.fontSizeExtraSmall),
                              ])
                            ]),

                            if(scrollingRate < 0.01) Row(children: [
                             const Padding(
                               padding: EdgeInsets.only(right: Dimensions.paddingSizeDefault),
                               child: BranchButtonWidget(isRow: false, color: Colors.white)
                             ),

                            const SizedBox(),

                            ])
                          ]),
                        ),
                      )
                    )),
                  ),
                ),

                SliverPersistentHeader(pinned: true, delegate: SliverDelegateWidget(
                    child: Center(child: Stack(children: [
                      Container(
                        transform: Matrix4.translationValues(0, -2, 0),
                        height: 60, width: Dimensions.webScreenWidth,
                        color: Colors.transparent,
                        child: Column(children: [
                         Expanded(child: Container(color: ColorResources.primaryColor)),

                         Expanded(child: Container(color: Colors.transparent))
                        ]),
                      ),

                      Positioned(
                        left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeSmall,
                        top: Dimensions.paddingSizeExtraSmall, bottom: Dimensions.paddingSizeExtraSmall,
                        child: InkWell(
                          onTap: ()=> RouterHelper.getSearchRoute(),
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                            height: 50, width: Dimensions.webScreenWidth,
                            decoration: BoxDecoration(
                              color: Theme.of(context).cardColor,
                              borderRadius: const BorderRadius.all(Radius.circular(Dimensions.radiusLarge)),
                              border: Border.all(width: 1, color: ColorResources.primaryColor)
                            ),
                            child: Row(children: [
                              Padding(
                                  padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
                                child: CustomAssetImageWidget(
                                  Images.search, color: Theme.of(context).hintColor,
                                  height: Dimensions.paddingSizeDefault,
                                ),
                              ),
                              Expanded(child: Text("Cari produk favoritmu disini", style: rubikRegular.copyWith(
                                color: Theme.of(context).hintColor
                              )))
                            ]),
                          ),
                        ),
                      )
                    ]))
                )),

                /// For Banner and Category
                SliverToBoxAdapter(child: Column(children: [
                  const BannerWidget(),
                  const SizedBox(height: Dimensions.paddingSizeSmall),

                  Container(
                    decoration: BoxDecoration(color: ColorResources.tertiaryColor),
                    padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                    child: const CategoryWebWidget(),
                  )
                ])),

                /// For local product
                SliverToBoxAdapter(child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
                  return (productProvider.popularLocalProductModel?.products?.isEmpty ?? false) ? const SizedBox() : LocalProductWidget(controller: _localProductScrollController);
                })),

                /// For import product
                SliverToBoxAdapter(child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
                  return (productProvider.importProductModel?.products?.isEmpty ?? false) ? const SizedBox() : ImportProductWidget(controller: _importProductScrollController);
                })),

                /// For list branch
                SliverToBoxAdapter(child: Consumer<BranchProvider>(builder: (context, branchProvider, _) {
                  return (branchProvider.branchValueList?.isEmpty ?? false) ? const SizedBox() : Center(child: SizedBox(
                    width: Dimensions.webScreenWidth,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                        child: BranchListWidget(controller: _branchListScrollController),
                    ),
                  ));
                })),

                /// For recommended product
                SliverToBoxAdapter(child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
                  return (productProvider.recommendedProductModel?.products?.isEmpty ?? false) ? const SizedBox() : const RecommendedProductWidget();
                })),

                if(productProvider.latestProductModel == null || (productProvider.latestProductModel?.products?.isNotEmpty ?? false))
                  SliverToBoxAdapter(child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault, vertical: Dimensions.paddingSizeSmall),
                      width: Dimensions.webMaxWidth,
                      child: TitleWidget(
                        title: 'Semua produk'
                      ),
                    ),
                  )),

                const ProductViewWidget()

              ]));
            }
        )),
      ),
    );
  }
}