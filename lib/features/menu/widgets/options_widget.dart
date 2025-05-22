import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_alert_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/menu/widgets/card_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/menu/widgets/portion_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class OptionsWidget extends StatelessWidget {
  final Function? onTap;

  const OptionsWidget({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final bool isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    return Consumer<AuthProvider>(builder: (context, authProvider, _) => SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Ink(
        padding: const EdgeInsets.only(top: Dimensions.paddingSizeLarge),
        child: Column(children: [
         const SizedBox(height: Dimensions.paddingSizeExtraLarge),

         Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
             child: Text("Pengaturan", style: rubikSemiBold.copyWith(fontSize: Dimensions.paddingSizeDefault)),
           ),

           Container(
             decoration: BoxDecoration(
               color: Theme.of(context).cardColor,
               borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
               boxShadow: const [BoxShadow(color: Colors.black12, spreadRadius: 1, blurRadius: 5)]
             ),
             padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault),
             margin: const EdgeInsets.all(Dimensions.paddingSizeDefault),
             child: Column(children: [
               PortionWidget(imageIcon: Images.profileSvg, title: "Profil"),
               PortionWidget(imageIcon: Images.addressSvg, title: "Alamat", onRoute: ()=> RouterHelper.getAddressRoute()),

               isLoggedIn ? PortionWidget(
                 iconColor: ColorResources.primaryColor,
                 icon: Icons.delete,
                 imageIcon: null,
                 title: "Hapus akun",
                 onRoute: (){},
               ) : const SizedBox(),

               InkWell(onTap: (){
                 if(authProvider.isLoggedIn()) {
                   ResponsiveHelper.showDialogOrBottomSheet(context, Consumer<AuthProvider>(builder: (context, authProvider, _) {
                     return CustomAlertDialogWidget(
                       isLoading: authProvider.isLoading,
                       title: "Ingin keluar",
                       icon: Icons.contact_support,
                       isSingleButton: authProvider.isLoading,
                       leftButtonText: "Ya",
                       rightButtonText: "Tidak",
                       onPressLeft: () {
                         authProvider.clearSharedData(context).then((condition) {
                            context.pop();
                            RouterHelper.getMainRoute();
                         });
                       },
                     );
                   }));
                 } else {
                   RouterHelper.getLoginRoute();
                 }
                },
                 child: Padding(
                   padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
                   child: Row(children: [
                     Container(
                       padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                       margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                       decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         color: ColorResources.primaryColor.withOpacity(0.1)
                       ),
                       child: CustomAssetImageWidget(
                         isLoggedIn ? Images.logoutSvg : Images.login, height: 16, width: 16,
                         color: isLoggedIn ? null : ColorResources.primaryColor,
                       ),
                     ),

                     Text(isLoggedIn ? 'Keluar' : 'Masuk', style: rubikRegular)
                   ]),
                 ),
               )
             ]),
           )
         ])
        ]),
      ),
    ));
  }
}