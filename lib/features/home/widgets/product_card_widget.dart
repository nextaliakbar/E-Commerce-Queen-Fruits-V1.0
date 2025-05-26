import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/add_to_cart_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/rating_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/stock_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/wish_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/quantity_position.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_item_detail_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/product_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  final QuantityPosition quantityPosition;
  final double imageHeight;
  final double imageWidth;
  final ProductGroup productGroup;
  final bool isShowBorder;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.quantityPosition = QuantityPosition.left,
    this.imageHeight = 150,
    this.imageWidth = 220,
    this.productGroup = ProductGroup.common,
    this.isShowBorder = false
  });

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);
    double? startingPrice = product.price;
    double? priceDiscount = PriceConverterHelper.convertDiscount(product.price, product.discount, product.discountType);
    bool isAvailable = ProductHelper.isProductAvailable(product: product);

    final isCenterAlign = productGroup == ProductGroup.recommendedProduct || productGroup == ProductGroup.branchProduct
    || productGroup == ProductGroup.searchResult || productGroup == ProductGroup.frequentlyBought;

    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        // String productImage = '${splashProvider.baseUrls!.productImageUrl}/${product.image}';
        String productImage = '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.productImageUrl}&file=${product.image}';
        debugPrint("Product image url $productImage");
        return Container(
          decoration: productGroup == ProductGroup.frequentlyBought ? const BoxDecoration() : BoxDecoration(
            boxShadow: [BoxShadow(
              color: Theme.of(context).shadowColor.withOpacity(0.3),
              blurRadius: 10, spreadRadius: 0.2,
              offset: const Offset(0, 2)
            )]
          ),
          margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
          child: Material(
            color: Theme.of(context).cardColor,
            clipBehavior: Clip.hardEdge,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: ColorResources.primaryColor.withOpacity(isShowBorder ? 0.2 : 0)),
              borderRadius: BorderRadius.circular(productGroup == ProductGroup.frequentlyBought ? Dimensions.radiusSmall : Dimensions.radiusLarge)
            ),
            child: InkWell(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeItemDetailScreen(product: product))
                );
              },
              hoverColor: ColorResources.primaryColor.withOpacity(0.03),
              child: Stack(children: [
                productGroup == ProductGroup.importProduct ? Column(
                  crossAxisAlignment: isCenterAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Stack(children: [
                      Column(children: [Stack(children: [
                          _ProductImageWidget(imageHeight: imageHeight, imageWidth: imageWidth, productImage: productImage, productGroup: productGroup),

                          Positioned(
                            right: Dimensions.paddingSizeSmall,
                            top: Dimensions.paddingSizeSmall,
                            left: null,
                            child: WishButtonWidget(product: product)
                          ),

                          StockTagWidget(product: product)
                        ])]),

                      Positioned.fill(left: Dimensions.paddingSizeSmall, right: Dimensions.paddingSizeExtraSmall, child: Align(alignment: Alignment.bottomCenter, child: Stack(children: [
                        Column(mainAxisSize: MainAxisSize.min, children: [
                         const SizedBox(height: 35),

                         Container(
                           transform: Matrix4.translationValues(0, -20, 0),
                           decoration: BoxDecoration(
                             color: Theme.of(context).cardColor,
                             borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                             boxShadow: [BoxShadow(
                               color: Theme.of(context).shadowColor.withOpacity(0.2),
                               offset: const Offset(0, 5),
                               blurRadius: 20,
                               spreadRadius: 10
                             )]
                           ),
                           margin: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                           child: Column(mainAxisSize: MainAxisSize.min, children: [
                             _ProductDescriptionWidget(
                                 product: product,
                                 priceDiscount: priceDiscount,
                                 startingPrice: startingPrice,
                                 productGroup: productGroup)
                           ]),
                         )
                        ]),

                        if(productProvider.checkStock(product) && isAvailable)
                          Positioned.fill(child: Align(alignment: Alignment.topCenter, child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                            child: AddToCartButtonWidget(product: product),
                          )))
                      ])))
                    ]))
                  ],
                ) : Stack(children: [
                  Column(crossAxisAlignment: isCenterAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start, children: [
                    Stack(children: [

                      /// For product image
                      _ProductImageWidget(imageHeight: imageHeight, imageWidth: imageWidth, productImage: productImage, productGroup: productGroup),

                      /// If stock produk out or not available
                      StockTagWidget(product: product, productGroup: productGroup)
                    ]),

                    /// For Description product
                    _ProductDescriptionWidget(
                      product: product,
                      priceDiscount: priceDiscount,
                      startingPrice: startingPrice,
                      productGroup: productGroup,
                    )
                  ]),
                  
                  /// Add to cart and quantity button
                  if(productProvider.checkStock(product) && isAvailable)
                    Positioned(top: imageHeight - 15, child: Align(
                      alignment: quantityPosition == QuantityPosition.left ? Alignment.bottomLeft 
                      : quantityPosition == QuantityPosition.center ? Alignment.bottomCenter 
                      : Alignment.bottomRight,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
                        child: AddToCartButtonWidget(product: product)
                      ),
                    ))
                ]),

                if(productGroup != ProductGroup.importProduct)
                  /// For wishlisht button
                  Positioned(
                    top: Dimensions.paddingSizeSmall,
                    right: Dimensions.paddingSizeSmall,
                    child: WishButtonWidget(product: product),
                  ),
                
                if(product.discount != null && product.discount != 0)
                  Positioned(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: _DiscountTagWidget(product: product, productGroup: productGroup)
                    ),
                  )
              ]),
            ),
          ),
        );
      },
    );
  }
}

class _ProductImageWidget extends StatelessWidget {
  final double imageHeight;
  final double imageWidth;
  final String productImage;
  final ProductGroup productGroup;

  const _ProductImageWidget({
    required this.imageHeight,
    required this.imageWidth,
    required this.productImage,
    required this.productGroup
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        productGroup == ProductGroup.frequentlyBought ? Dimensions.radiusSmall : Dimensions.radiusDefault
      ),
      child: CustomImageWidget(
        placeholder: Images.placeholderRectangle,
        fit: BoxFit.cover, height: imageHeight, width: imageWidth,
        image: productImage,
      ),
    );
  }
}

class _ProductDescriptionWidget extends StatelessWidget {
  final Product product;
  final double? priceDiscount;
  final double? startingPrice;
  final ProductGroup productGroup;

  const _ProductDescriptionWidget({
    super.key, required this.product, required this.priceDiscount,
    required this.startingPrice, required this.productGroup
  });

  @override
  Widget build(BuildContext context) {
    final isCenterAlign = productGroup == ProductGroup.recommendedProduct || productGroup == ProductGroup.importProduct
    || productGroup == ProductGroup.branchProduct || productGroup == ProductGroup.frequentlyBought;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall, vertical: Dimensions.paddingSizeExtraSmall),
      child: Column(
        crossAxisAlignment: isCenterAlign ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Row(mainAxisAlignment: isCenterAlign ? MainAxisAlignment.center : MainAxisAlignment.start, children: [
            Flexible(child: Text(product.name!, maxLines: 1, overflow: TextOverflow.ellipsis, style: rubikSemiBold)),
          ]),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          product.rating!.isNotEmpty ? (product.rating![0].avarage! > 0.0 ? RatingBarWidget(
            rating: product.rating![0].avarage!,
            size: Dimensions.paddingSizeDefault
          ) : const SizedBox()) : const SizedBox(),

          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

          FittedBox(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
           priceDiscount! > 0 ? Padding(
             padding: const EdgeInsets.only(right: Dimensions.paddingSizeExtraSmall),
             child: CustomDirectionalityWidget(child: Text(
               PriceConverterHelper.convertPrice(startingPrice),
               style: rubikRegular.copyWith(
                 fontSize: Dimensions.fontSizeSmall,
                 decoration: TextDecoration.lineThrough,
                 color: Theme.of(context).hintColor
               ),
             )),
           ) : const SizedBox(),

           CustomDirectionalityWidget(child: Text(
             PriceConverterHelper.convertPrice(startingPrice, discount: product.discount, discountType: product.discountType),
             style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall)
           ))
          ])),
          const SizedBox(height: Dimensions.paddingSizeExtraSmall)
        ],
      ),
    );
  }
}

class _DiscountTagWidget extends StatelessWidget {

  final Product product;
  final ProductGroup productGroup;

  const _DiscountTagWidget({
    super.key, required this.product,
    required this.productGroup
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeSmall), child: Container(
      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(color: ColorResources.primaryColor.withOpacity(0.7), borderRadius: BorderRadius.circular(Dimensions.radiusLarge)),
      child: Text(
        PriceConverterHelper.getDiscountType(discount: product.discount, discountType: product.discountType),
        style: rubikBold.copyWith(color: Colors.white, fontSize: Dimensions.fontSizeSmall),
      ),
    ));
  }
}