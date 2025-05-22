import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/menu/widgets/options_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class MenuScreen extends StatefulWidget {

  final Function? onTap;

  const MenuScreen({super.key, this.onTap});

  @override
  State<StatefulWidget> createState()=> _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,
      appBar: null,
      body: Consumer<AuthProvider>(builder: (context, authProvider, _) {
        final bool isLoggedIn = authProvider.isLoggedIn();

        return Column(children: [
          Consumer<ProfileProvider>(builder: (context, profileProvider, child) => Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: Padding(
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeExtraLarge,
                right: Dimensions.paddingSizeExtraLarge,
                top: 50, bottom: Dimensions.paddingSizeExtraLarge
              ),
              child: Row(children: [
               Container(
                 decoration: const BoxDecoration(
                   shape: BoxShape.circle
                 ),
                 padding: const EdgeInsets.all(1),
                 child: ClipOval(
                   child: isLoggedIn ? CustomImageWidget(
                     placeholder: Images.placeholderUser, height: 80, width: 80,
                     fit: BoxFit.cover,
                     image: '${splashProvider.baseUrls!.customerImageUrl}/${profileProvider.userInfoModel != null ? profileProvider.userInfoModel!.image : ''}',
                   ) : const CustomAssetImageWidget(
                     Images.placeholderUserSvg, height: 80, width: 80, fit: BoxFit.cover,
                   ),
                 ),
               ),

                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoggedIn && profileProvider.userInfoModel == null ? Shimmer(
                      duration: const Duration(seconds: 2),
                      enabled: true,
                      child: Container(
                        height: Dimensions.paddingSizeDefault,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Theme.of(context).shadowColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                        ),
                      ),
                    ) : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLoggedIn ? '${profileProvider.userInfoModel?.fName} ${profileProvider.userInfoModel?.lName}'
                              : 'Masuk', style: rubikSemiBold,
                        ),

                        if(!isLoggedIn) TextButton(
                            onPressed: ()=> RouterHelper.getLoginRoute(),
                            style: TextButton.styleFrom(
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              padding: EdgeInsets.zero, foregroundColor: Colors.transparent
                            ),
                          child: Text("Daftar atau Masuk", style: rubikRegular.copyWith(color: ColorResources.primaryColor)),
                        ),

                        if(isLoggedIn) Text(
                          profileProvider.userInfoModel?.email ?? '',
                          style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        )
                      ],
                    )
                  ]
                ))
              ]),
            ),
          )),

          Expanded(child: OptionsWidget(onTap: widget.onTap))
        ]);
      })
    );
  }
}