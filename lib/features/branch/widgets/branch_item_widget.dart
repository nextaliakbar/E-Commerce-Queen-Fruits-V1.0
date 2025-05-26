import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_shadow_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/branch_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/localization/app_localization.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchItemWidget extends StatelessWidget {
  final BranchValue? branchesValue;
  final bool isItemChange;

  const BranchItemWidget({super.key, this.branchesValue, required this.isItemChange});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
      return Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: () async {
            if(branchesValue?.branches?.id != branchProvider.getBranchId() && cartProvider.cartList.isNotEmpty) {
              BranchHelper.dialogOrBottomSheet(
                  context,
                  onPressRight: () {
                    branchProvider.updateBranchId(branchesValue!.branches!.id);
                    BranchHelper.setBranch(context);
                    cartProvider.getCartData(context);
                  }, title: "Kamu memiliki produk di keranjang pada cabang ini. Mengganti cabang akan memperbarui keranjang. "
                  "Kembali ke cabang ini untuk mendapatkan kembali produk kamu di keranjang. Ingin lanjut pindah cabang"
              );
            } else if(branchesValue?.branches?.id == branchProvider.getBranchId()) {
              debugPrint("Branch ID ${branchesValue?.branches?.id} and my get branch ${branchProvider.getBranchId()}");
              showCustomSnackBarHelper("Ini adalah cabang kamu saat ini");
            } else if(branchesValue!.branches!.status!) {
              BranchHelper.dialogOrBottomSheet(
                  context,
                  onPressRight: () {
                    branchProvider.updateBranchId(branchesValue!.branches!.id);
                    BranchHelper.setBranch(context);
                    cartProvider.getCartData(context);
                  }, title: "Pindah ke cabang ini"
              );
            } else {
              showCustomSnackBarHelper('${branchesValue!.branches!.name} tutup sekarang');
            }
          },
          child: BranchItemViewMobile(branchesValue: branchesValue),
        ),
      );
    });
  }
}

class BranchItemViewMobile extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchItemViewMobile({super.key, required this.branchesValue});

  @override
  Widget build(BuildContext context) {
    return CustomShadowWidget(
      padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
      margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
      borderRadius: Dimensions.radiusDefault,

      child: Row(children: [
        Column(children: [
          Stack(children: [
              BranchLogoView(branchesValue: branchesValue),

              if(!branchesValue!.branches!.status!) Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  color: Colors.black.withOpacity(0.7)
                ),
                width: 82, height: 82,
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                 const Icon(Icons.schedule, size: Dimensions.paddingSizeDefault, color: Colors.white),
                 
                 Text('Sementara tutup', textAlign: TextAlign.center, style: rubikRegular.copyWith(
                    color: Colors.white, fontSize: Dimensions.fontSizeSmall
                 ))
                ]),
              ),
          ]),
        ]),

        const SizedBox(width: Dimensions.paddingSizeDefault),

        Flexible(child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${branchesValue?.branches?.name}', style: rubikSemiBold, maxLines: 1, overflow: TextOverflow.ellipsis),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          Text(
            '${branchesValue?.branches?.address}',
            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).textTheme.displayLarge?.color),
            // maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall)
        ]))
      ]),
    );
  }
}

class BranchLogoView extends StatelessWidget {
  final BranchValue? branchesValue;

  const BranchLogoView({super.key, required this.branchesValue});

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        border: Border.all(color: ColorResources.primaryColor.withOpacity(0.3))
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        child: CustomImageWidget(
          placeholder: Images.placeholderImage,
          height: 80, width: 80,
          fit: BoxFit.cover,
          // image: '${splashProvider.baseUrls!.branchImageUrl}/${branchesValue?.branches!.image}',
          image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.branchImageUrl}&file=${branchesValue?.branches!.image}',
        ),
      ),
    );
  }
}