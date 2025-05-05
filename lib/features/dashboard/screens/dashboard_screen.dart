import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_pop_scope_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/dashboard/widgets/bottom_nav_item_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  final int pageIndex;
  const DashboardScreen({super.key, required this.pageIndex});

  @override
  State<StatefulWidget> createState()=> _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin{
  PageController? _pageController;
  int? _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _pageIndex = widget.pageIndex;

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    // if(splashProvider.policyModel == null) {
    //   Provider.of<SplashProvider>(context, listen: false).getPolicyPage();
    // }

    HomeScreen.loadData(false);

    // locationProvider.checkPermission(()=> locationProvider.getCurrentLocation(context, false).then((currentAddress) {
    //   locationProvider.onChangeCurrentAddress(currentAddress);
    // }), canBeIgnoreDialog: true);

    Provider.of<OrderProvider>(context, listen: false).changeStatus(true);

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      const HomeScreen(false)
    ];

  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);

    return CustomPopScopeWidget(
      isExit: _pageIndex == 0,
      onPopInvoked: () async {
        if(_pageIndex != 0) {
          _setPage(0);
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: null,
        body: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: defaultTargetPlatform == TargetPlatform.iOS ? 80 : 65),
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _screens.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Consumer<SplashProvider>(
                builder: (ctx, splashController, _) {
                  return Container(
                    width: size.width,
                    height: defaultTargetPlatform == TargetPlatform.iOS ? 80 : 65,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusLarge)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5)]
                    ),
                    child: Stack(children: [
                      /**
                     Center(
                       heightFactor: 0.2,
                       child: Container(
                         width: 60, height: 60,
                         decoration: BoxDecoration(
                           border: Border.all(color: ColorResources.primaryColor, width: 5),
                           borderRadius: BorderRadius.circular(30),
                           boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 2, offset: const Offset(0, -2), spreadRadius: 0)]
                         ),
                         child: FloatingActionButton(
                             shape: const CircleBorder(),
                           backgroundColor: ColorResources.primaryColor,
                           onPressed: () {
                               _setPage(2);
                           },
                           elevation: 0,
                           child: Consumer<CartProvider>(builder: (context, cartProvider, _) {
                             return Stack(
                               children: [
                                 const CustomAssetImageWidget(Images.order, color: Colors.white, height: 30),

                                 if(cartProvider.cartList.isNotEmpty) Positioned(top: -4, right: 0, child: Container(
                                   alignment: Alignment.center,
                                   padding: const EdgeInsets.all(5),
                                   decoration: const BoxDecoration(
                                     shape: BoxShape.circle, color: Colors.white
                                   ),
                                   child: Text('${cartProvider.cartList.length}', style: rubikSemiBold.copyWith(
                                    color: ColorResources.primaryColor,
                                    fontSize: Dimensions.paddingSizeSmall
                                   )),
                                 ))
                               ],
                             );
                           }),
                         ),
                       ),
                     ),
                          */

                      Center(
                        child: SizedBox(
                          width: size.width, height: 80,
                          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                            BottomNavItemWidget(
                              title: "Buat Kamu",
                              imageIcon: Images.forYouSvg,
                              isSelected: _pageIndex == 0,
                              onTap: ()=> _setPage(0),
                            ),

                            BottomNavItemWidget(
                              title: "Favorit",
                              imageIcon: Images.favoriteSvg,
                              isSelected: _pageIndex == 1,
                              onTap: ()=> _setPage(1),
                            ),

                            BottomNavItemWidget(
                              title: "Keranjang",
                              imageIcon: Images.cartSvg,
                              isSelected: _pageIndex == 2,
                              onTap: ()=> _setPage(2),
                            ),

                            // Container(width: size.width * 0.2),

                            BottomNavItemWidget(
                              title: "Pesanan",
                              imageIcon: Images.shopSvg,
                              isSelected: _pageIndex == 3,
                              onTap: ()=> _setPage(3),
                            ),

                            BottomNavItemWidget(
                              title: "Menu",
                              imageIcon: Images.menuSvg,
                              isSelected: _pageIndex == 4,
                              onTap: ()=> _setPage(4),
                            )
                          ]),
                        ),
                      )
                    ]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    _pageController?.jumpToPage(pageIndex);
    setState(() {
      _pageIndex = pageIndex;
    });
  }
}