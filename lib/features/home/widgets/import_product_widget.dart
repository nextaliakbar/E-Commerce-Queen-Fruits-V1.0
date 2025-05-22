import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_single_child_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_slider_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/title_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/quantity_position.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ImportProductWidget extends StatelessWidget {
  final ScrollController controller;

  const ImportProductWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Center(child: Container(
      width: Dimensions.webScreenWidth,
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
      child: Consumer<ProductProvider>(builder: (context, productProvider, _) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          productProvider.importProductModel == null ? Container(

          ) : (productProvider.importProductModel?.products?.isNotEmpty ?? false) ?
              Column(children: [
                Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge), child: TitleWidget(
                  title: "Produk Impor",
                  subTitle: "Lihat Semua",
                  onTap: ()=> RouterHelper.getHomeItem(productType: ProductType.importProduct)
                )),

                const SizedBox(height: Dimensions.paddingSizeSmall),

                SizedBox(height: 250, width: Dimensions.webScreenWidth, child: CustomSliderListWidget(
                    controller: controller,
                    verticalPosition: 50,
                    isShowForwardButton: false,
                    child: CustomSingleChildListWidget(
                      controller: controller,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: (productProvider.importProductModel?.products?.length ?? 0) > 12 ? 12 : productProvider.importProductModel?.products?.length ?? 0,
                      itemBuilder: (index) => Container(
                       width: 160,
                       margin: EdgeInsets.only(left:  Dimensions.paddingSizeLarge),
                       child: ProductCardWidget(
                         product: productProvider.importProductModel!.products![index],
                         productGroup: ProductGroup.importProduct,
                         quantityPosition: QuantityPosition.center,
                         imageHeight: 190,
                         imageWidth: 200,
                       ),
                      )
                    )
                ))
              ]) : Center(child: Text("Produk import tidak tersedia"))
        ]);
      }),
    ));
  }
}