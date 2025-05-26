import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/cart_bottom_sheet_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/rating_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/stock_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/marquee_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProductWidget extends StatelessWidget {
  final CartModel? cartModel;
  final int cartIndex;
  final bool isAvailable;

  const CartProductWidget({super.key, required this.cartModel, required this.cartIndex, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    List<Variation>? variationList;

    if(cartModel?.product!.branchProduct != null && cartModel!.product!.branchProduct!.isAvailable!) {
      variationList = cartModel?.product!.branchProduct!.variations;
    } else {
      variationList = cartModel!.product!.variations;
    }

    String variationText = '';
    if(variationList != null && cartModel!.variations!.isNotEmpty) {
      for(int index = 0; index < cartModel!.variations!.length; index++) {
        if(cartModel!.variations![index].contains(true)) {
          variationText += '${variationText.isNotEmpty ? ', ' : ''} ${cartModel!.product!.variations![index].name} (';
          for(int i = 0; i < cartModel!.variations![index].length; i++) {
            if(cartModel!.variations![index][i]!) {
              variationText += '${variationText.endsWith('(') ? '' : ', '} ${variationList[index].variationValues?[i].level} - ${
                PriceConverterHelper.convertPrice(variationList[index].variationValues![i].optionPrice)
              }';
            }
          }
          variationText += ')';
        }
      }
    }

    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.2), borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
        ),
        child: Stack(children: [

          const Positioned(
            top: 0, bottom: 0, right: Dimensions.paddingSizeExtraLarge,
            child: Icon(Icons.delete, color: Colors.white, size: Dimensions.paddingSizeLarge),
          ),


          ClipRRect(
            child: Dismissible(
              key: UniqueKey(),
              onDismissed: (DismissDirection direction) {
                cartProvider.removeFromCart(cartIndex);
              },
              child: Container(
                  padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [

                    Padding(
                      padding: const EdgeInsets.only(left: Dimensions.paddingSizeExtraSmall),
                      child: Row(children: [
                        /// for cart image and stock tag
                        Stack(children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                            child: CustomImageWidget(
                              placeholder: Images.placeholderImage, height: 80, width: 80,
                              image: '${AppConstants.baseUrl}/source.php?folder=${splashProvider.baseUrls!.productImageUrl}&file=${cartModel!.product!.image}',
                              // image: '${splashProvider.baseUrls!.productImageUrl}/${cartModel!.product!.image}',
                            ),
                          ),

                          StockTagWidget(product: cartModel!.product!),
                        ]),
                        const SizedBox(width: Dimensions.paddingSizeSmall),

                        Expanded(
                          flex: 5,
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text(cartModel!.product!.name!, style: rubikSemiBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                            Row(children: [
                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  RatingBarWidget(rating: (cartModel?.product?.rating?.isNotEmpty ?? false) ? cartModel?.product?.rating![0].avarage ?? 0 : 0.0, size: 12),
                                  const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                    _PriceTagWidget(cartModel: cartModel),

                                  cartModel!.product!.variations!.isNotEmpty && variationText.isNotEmpty ? Padding(
                                    padding: const EdgeInsets.only(top: Dimensions.paddingSizeExtraSmall),
                                    child: Row(mainAxisSize: MainAxisSize.min,children: [
                                      Flexible(child: MarqueeWidget(
                                        backDuration: const Duration(microseconds: 500),
                                        animationDuration: const Duration(microseconds: 500),
                                        direction: Axis.horizontal,
                                        child: Row(children: [
                                          Text(
                                            'Variasi: ',
                                            style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor),
                                          ),

                                          CustomDirectionalityWidget(child: Text(variationText, style: rubikBold.copyWith(
                                            fontSize: Dimensions.fontSizeExtraSmall,
                                          ))),
                                        ]),
                                      )),
                                    ]),
                                  ) : const SizedBox(),

                                ]),
                              ),
                                _QuantityTagWidget(
                                  cartModel: cartModel, cartProvider: cartProvider,
                                  cartIndex: cartIndex, productProvider: productProvider,
                                ),
                            ]),
                          ]),
                        ),
                      ]),
                    ),
                  ])),
            ),
          ),
        ]),
      ),
    );
  }
}

class _PriceTagWidget extends StatelessWidget {
  final CartModel? cartModel;

  const _PriceTagWidget({required this.cartModel});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      if(cartModel!.discountAmount! > 0 ) ... [
        Flexible(child: CustomDirectionalityWidget(
          child: Text(PriceConverterHelper.convertPrice((cartModel!.product!.price!)), style: rubikRegular.copyWith(
            color: Theme.of(context).hintColor.withOpacity(0.7),
            fontSize: Dimensions.fontSizeSmall,
            decoration: TextDecoration.lineThrough,
          )),
        )),
        const SizedBox(width: Dimensions.paddingSizeExtraSmall),
      ],

      Flexible(child: CustomDirectionalityWidget(child: Text(
        PriceConverterHelper.convertPrice(cartModel!.discountedPrice),
        style: rubikBold.copyWith(fontSize: Dimensions.fontSizeSmall),
      ))),
    ]);
  }
}

class _QuantityTagWidget extends StatelessWidget {
  final CartModel? cartModel;
  final CartProvider cartProvider;
  final ProductProvider productProvider;
  final int cartIndex;

  const _QuantityTagWidget({
    super.key,
    required this.cartModel,
    required this.cartProvider,
    required this.productProvider,
    required this.cartIndex
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall), child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            if (cartModel!.quantity! > 1) {
              cartProvider.setQuantity(isIncrement: false, fromProductView: false, cartModel: cartModel, productIndex: null);
            }else {
              cartProvider.removeFromCart(cartIndex);
            }
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.5)),
            ),
            child: Icon(Icons.remove, size: Dimensions.fontSizeExtraLarge, color: Theme.of(context).hintColor.withOpacity(0.8)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
          child: Text(cartModel!.quantity.toString(), style: rubikRegular),
        ),

        InkWell(
          onTap: () {
            int quantity = cartModel != null && cartModel!.product != null ? cartProvider.getCartProductQuantityCount(cartModel!.product!) : 0;
            if(productProvider.checkStock(cartModel!.product!, quantity: quantity)){
              cartProvider.setQuantity(isIncrement: true, fromProductView: false, cartModel: cartModel, productIndex: null);
            }else{
              showCustomSnackBarHelper('Stok habis');
            }
          },
          child: Container(
            padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
            decoration: BoxDecoration(
              color: ColorResources.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: Dimensions.fontSizeExtraLarge, color: Colors.white),
          ),
        ),
      ],
    ));
  }
}