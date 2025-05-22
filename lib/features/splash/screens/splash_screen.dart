import 'dart:async';
import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/data_source_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  final String? routeTo;
  const SplashScreen({super.key, this.routeTo});

  @override
  State<StatefulWidget> createState()=> _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  final GlobalKey<ScaffoldMessengerState> _globalKey = GlobalKey();
  StreamSubscription<List<ConnectivityResult>>? subscription;

  late AnimationController animationController;
  late Animation<Offset> leftSlideAnimation;
  bool isNotLoaded = true;

  @override
  void initState() {
    super.initState();

    _checkConnectivity();

    _splashAnimation();

    Provider.of<SplashProvider>(context, listen: false).initSharedData();
    Provider.of<CartProvider>(context, listen: false).getCartData(context);

    _route();
  }

  void _splashAnimation() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000))..repeat(reverse: true);

    leftSlideAnimation = Tween<Offset>(begin: const Offset(-4, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: animationController, curve: Curves.ease)
    );

    animationController.forward();
  }

  void _route() {
    debugPrint('splash_screen.dart');
    debugPrint('--------call---------');

    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    splashProvider.initConfig(context, DataSourceEnum.local).then((value) async {
      _onConfigAction(value, splashProvider, Get.context!);
    });
  }

  void _onConfigAction(ConfigModel? value, SplashProvider splashProvider, BuildContext context) {
    if(value != null) {
      final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

      if(branchProvider.getBranchId() != -1) {
        splashProvider.getDeliveryInfo(branchProvider.getBranchId());
      }

      if(Provider.of<AuthProvider>(Get.context!, listen: false).isLoggedIn()) {
        Provider.of<AuthProvider>(Get.context!, listen: false).updateToken();
        RouterHelper.getMainRoute(action: RouteAction.pushNameAndRemoveUntil);
      } else {
        if(widget.routeTo != null) {
          Get.context!.pushReplacement(widget.routeTo!);
        } else {
          Future.delayed(const Duration(milliseconds: 10)).then((v) {
            RouterHelper.getBranchListScreen(action: RouteAction.pushNameAndRemoveUntil);
            Provider.of<BranchProvider>(Get.context!, listen: false).getBranchId() != -1
                ? RouterHelper.getMainRoute(action: RouteAction.pushNameAndRemoveUntil)
                : RouterHelper.getBranchListScreen(action: RouteAction.pushNameAndRemoveUntil);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SplashProvider>(
      builder: (context, splashProvider, _) {
        if(splashProvider.configModel != null && isNotLoaded) {
          isNotLoaded = false;
          _onConfigAction(splashProvider.configModel, splashProvider, context);
        }

        return TweenAnimationBuilder(
          tween: Tween<double>(begin: 1.0, end: 0.6),
          curve: Curves.ease,
          duration: const Duration(milliseconds: 1000),
          builder: (context, value, widget) => Scaffold(
            backgroundColor: ColorResources.splashBackgroundColor,
            key: _globalKey,
            body: Center(child: Consumer<SplashProvider>(builder: (context, splash, child) {
                return Stack(children: [
                  Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SlideTransition(
                        position: leftSlideAnimation,
                        child: const CustomAssetImageWidget(
                          Images.logo, height: 150,
                        )
                      ),
                      // Text(AppConstants.appName, style: rubikBold.copyWith(fontSize: 38, color: Colors.white), textAlign: TextAlign.center),
                      Text("Cari buah dan produk olahan buah favoritmu disini", style: rubikMedium.copyWith(fontSize: 24, color: Colors.white), textAlign: TextAlign.center)
                    ])
                  )
                ]);
              })
            )
          )
        );
      },
    );
  }

  void _checkConnectivity() {
    bool isFirst = true;
    subscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> result) {
        bool isConnected = result.contains(ConnectivityResult.wifi) || result.contains(ConnectivityResult.mobile);

        if((isFirst && !isConnected) || !isFirst && context.mounted) {
          showCustomSnackBarHelper(isConnected ? 'Terhubung' : 'Tidak ada koneksi internet', isError: !isConnected);

          if(isConnected && ModalRoute.of(context)?.settings.name == RouterHelper.splashScreen) {
            _route();
          }
        }

        isFirst = false;
    });
  }
}