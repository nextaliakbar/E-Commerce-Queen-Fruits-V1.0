import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/product_shimmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/quantity_position.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/view_change_to_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductViewWidget extends StatelessWidget {

  const ProductViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.sizeOf(context);
    final double webPadding = (size.width - Dimensions.webScreenWidth) / 2;

    return Consumer<ProductProvider>(builder: (context, productProvider, _) {
      debugPrint('------ latest ====== > ${productProvider.latestProductModel?.products?.length}');

      return productProvider.latestProductModel != null ? Consumer<ProductSortProvider>(
        builder: (context,_, child) => SliverPadding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          sliver: (productProvider.latestProductModel?.products?.isNotEmpty ?? false) ? SliverGrid.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Dimensions.paddingSizeSmall,
                mainAxisSpacing: Dimensions.paddingSizeSmall,
                crossAxisCount: 2,
                mainAxisExtent: 260
              ),
              itemCount: productProvider.latestProductModel!.products!.length,
              itemBuilder: (context, index) {
                return ProductCardWidget(
                    product: productProvider.latestProductModel!.products![index],
                    quantityPosition: QuantityPosition.left,
                    productGroup: ProductGroup.common,
                    isShowBorder: true,
                    imageHeight: 160,
                    imageWidth: size.width,
                );
              }
          ) : const SliverToBoxAdapter()
        )
      ) : const _ProductListShimmerWidget();
    });
  }
}

class _ProductListShimmerWidget extends StatelessWidget {
  const _ProductListShimmerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final double realSpaceNeeded = (MediaQuery.sizeOf(context).width - Dimensions.webScreenWidth) / 2;

    return SliverPadding(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      sliver: SliverGrid.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: Dimensions.paddingSizeSmall,
            mainAxisSpacing: Dimensions.paddingSizeSmall,
            crossAxisCount: 2,
            mainAxisExtent: 250
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return const ProductShimmerWidget(
              isEnabled: true,
              width: double.minPositive,
              isList: false,
            );
          }
      ),
    );
  }
}
