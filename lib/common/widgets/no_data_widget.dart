import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
class NoDataWidget extends StatelessWidget {
  final bool isOrder;
  final bool isCart;
  final bool isNothing;
  final bool isAddress;
  final bool isCoupon;

  const NoDataWidget({
    super.key,
    this.isCart = false,
    this.isNothing = false,
    this.isOrder = false,
    this.isAddress = false,
    this.isCoupon = false
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: height - 450
              ),
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    SizedBox(height: 110, width: 110, child: CustomAssetImageWidget(
                     isCoupon? Images.noCouponSvg : isOrder ? Images.emptyBoxSvg : isCart ? Images.emptyCartSvg
                      : isAddress ? Images.noAddressSvg : Images.noProductImage,
                    )),
                    const SizedBox(height: Dimensions.paddingSizeExtraLarge),

                    Text(
                      isCoupon? 'Tidak ada promo tersedia' : isOrder ? 'Tidak ada riwayat pesanan'
                      : isCart ? 'Keranjangmu masi kosong' : isAddress? 'Tidak ada penyimpaanan alamat yang ditemukan'
                      : 'Tidak ada yang ditemukan',
                      style: rubikSemiBold.copyWith(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: Dimensions.fontSizeLarge,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeSmall)
                  ]),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
