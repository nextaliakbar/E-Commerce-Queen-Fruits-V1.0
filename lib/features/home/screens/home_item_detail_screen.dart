import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_directionality_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/on_hover_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/rating_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/wish_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/read_more_text.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/product_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeItemDetailScreen extends StatefulWidget {

  final Product? product;
  final bool importProduct;
  final Function? callBack;
  final CartModel? cartModel;
  final int? cartIndex;
  final bool fromCart;

  const HomeItemDetailScreen({
    super.key,
    required this.product,
    this.importProduct = false,
    this.callBack,
    this.cartModel,
    this.cartIndex,
    this.fromCart = false
  });

  @override
  State<StatefulWidget> createState()=> _HomeItemDetailScreenState();
}

class _HomeItemDetailScreenState extends State<HomeItemDetailScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();

    Provider.of<ProductProvider>(context, listen: false).initData(widget.product, widget.cartModel);
    Provider.of<ProductProvider>(context, listen: false).initProductVariationStatus(widget.product!.variations!.length);
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: const CustomAppBarWidget(
          title: "Detail produk",
          titleColor: ColorResources.primaryColor
      ),
      body: Consumer<CartProvider>(builder: (context, cartProvider, child) {
        return Stack(children: [
            ScrollableBottomSheet(
                isDraggableEnable: false,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: Container(
                    width: 700,
                    constraints: BoxConstraints(maxHeight: size.height * 0.85),
                    decoration: BoxDecoration(color: Theme.of(context).cardColor),
                    clipBehavior: Clip.hardEdge,
                    child: Consumer<ProductProvider>(builder: (context, productProvider, child) {
                      ({double? price, List<Variation>? variations}) productBranchWithPrice = ProductHelper.getBranchProductVariationWithPrice(widget.product);
                      List<Variation>? variationList = productBranchWithPrice.variations;
                      double? price = productBranchWithPrice.price;

                      double variationPrice = 0;

                      for(int index = 0; index < variationList!.length; index++) {
                        for(int i = 0; i < variationList[index].variationValues!.length; i++) {
                          if(productProvider.selectedVariations[index][i]!) {
                            variationPrice += variationList[index].variationValues![i].optionPrice!;
                          }
                        }
                      }

                      double? discount = widget.product!.discount;
                      String? discountType = widget.product!.discountType;
                      double? priceWithDiscount = PriceConverterHelper.convertWithDiscount(price, discount, discountType);
                      double priceWithVariations = price! + variationPrice;
                      double? totalPrice = PriceConverterHelper.convertWithDiscount(priceWithVariations, discount, discountType)! * productProvider.quantity!;
                      double priceWithVariationsWithoutDiscount = (priceWithVariations * productProvider.quantity!);
                      bool isAvailable = DateConverterHelper.isAvailable(widget.product!.availableTimeStarts!, widget.product!.availableTimeEnds!);

                      CartModel cartModel = CartModel(
                        priceWithVariations,
                        priceWithDiscount,
                        [],
                        (priceWithVariations - PriceConverterHelper.convertWithDiscount(priceWithVariations, discount, discountType)!),
                        productProvider.quantity,
                        (priceWithVariations - PriceConverterHelper.convertWithDiscount(priceWithVariations, widget.product!.tax, widget.product!.taxType)!),
                        widget.product,
                        productProvider.selectedVariations
                      );

                      cartProvider.isExistInCart(widget.product?.id, null);

                      return Column(mainAxisSize: MainAxisSize.min, children: [
                        Flexible(child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.white,
                              height: size.height * 0.36,
                              width: size.width,
                              child: PageView.builder(onPageChanged: (value) {
                                setState(() {currentIndex = value;});
                              },
                              itemCount: 3,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Column(children: [
                                    CustomImageWidget(
                                      image: '${splashProvider.baseUrls!.productImageUrl}/${widget.product!.image}',
                                      height: size.height * 0.3,
                                      width: size.width,
                                      fit: BoxFit.cover
                                    ),

                                    const SizedBox(height: Dimensions.paddingSizeDefault),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(3, (index) => AnimatedContainer(
                                        duration: const Duration(milliseconds: 300),
                                        margin: const EdgeInsets.only(right: 4),
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: currentIndex == index ? ColorResources.primaryColor : Colors.grey,
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                      )),
                                    )
                                  ]);
                                },
                              ),
                            ),

                            Expanded(child: SingleChildScrollView(
                              child: Container(
                                transform: Matrix4.translationValues(0, -10, 0),
                                padding: EdgeInsets.all(Dimensions.paddingSizeLarge),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 18),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(children: [
                                         Text(widget.product!.name!, style: rubikSemiBold, overflow: TextOverflow.ellipsis),

                                         const SizedBox(width: Dimensions.paddingSizeSmall),

                                         widget.product!.rating!.isNotEmpty ? widget.product!.rating![0].avarage! > 0.0
                                             ? RatingBarWidget(rating: widget.product!.rating![0].avarage!) : const SizedBox()
                                             : const SizedBox(),

                                        const Spacer(),

                                        WishButtonWidget(product: widget.product)
                                        ]),

                                        const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                        Row(mainAxisSize: MainAxisSize.min, children: [
                                          price > priceWithDiscount! ? CustomDirectionalityWidget(child: Text(
                                            PriceConverterHelper.convertPrice(price),
                                            style: rubikRegular.copyWith(
                                              color: Theme.of(context).hintColor.withOpacity(0.7),
                                              decoration: TextDecoration.lineThrough,
                                              overflow: TextOverflow.ellipsis,
                                              fontSize: Dimensions.fontSizeSmall
                                            ),
                                            maxLines: 1,
                                          )) : const SizedBox(),

                                          const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                          CustomDirectionalityWidget(child: Text(
                                            PriceConverterHelper.convertPrice(price, discount: widget.product!.discount, discountType: widget.product!.discountType),
                                            style: rubikSemiBold.copyWith(overflow: TextOverflow.ellipsis),
                                            maxLines: 1,
                                          ))
                                        ])
                                      ],
                                    ),
                                  ),

                                  _CartProductDescription(product: widget.product!),

                                  variationList.isNotEmpty ? ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: variationList.length,
                                    physics: const NeverScrollableScrollPhysics(),
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor,
                                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                          boxShadow: [BoxShadow(
                                              color: Theme.of(context).shadowColor.withOpacity(0.5),
                                              blurRadius: Dimensions.radiusDefault
                                            )]
                                        ),
                                        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(variationList[index].name ?? '', style: rubikSemiBold),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: productProvider.isRequiredSelected![index] ? Theme.of(context).secondaryHeaderColor.withOpacity(0.05)
                                                        : ColorResources.primaryColor.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(Dimensions.radiusSmall)
                                                  ),
                                                  padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                                                  child: CustomDirectionalityWidget(child: Text(
                                                    variationList[index].isRequired! ? productProvider.isRequiredSelected![index] ? 'Selesai':'Wajib':'Opsional',
                                                    style: rubikRegular.copyWith(
                                                      color: productProvider.isRequiredSelected![index]
                                                          ? Theme.of(context).secondaryHeaderColor : ColorResources.primaryColor,
                                                      fontSize: Dimensions.fontSizeSmall
                                                    ),
                                                  )),
                                                )
                                            ]),

                                            const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                                            Row(children: [
                                             variationList[index].isMultiSelect! ? Text(
                                               "Pilih minimal ${variationList[index].min} hingga ${variationList[index].max} pilihan",
                                               style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).disabledColor),
                                             ) : variationList[index].isRequired! ? Text(
                                               "Pilih salah satu",
                                               style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeExtraSmall, color: ColorResources.primaryColor),
                                             ) : const SizedBox()
                                            ]),

                                            SizedBox(height: variationList[index].isMultiSelect! || variationList[index].isRequired! ? Dimensions.paddingSizeSmall : 0),

                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics: const NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.zero,
                                              itemCount: productProvider.variationsSeeMoreButtonStatus
                                              ? variationList[index].variationValues!.length : variationList[index].variationValues!.length > 3
                                              ? 4 : variationList[index].variationValues!.length,
                                              itemBuilder: (context, i) {
                                                return i == 3 && !productProvider.variationsSeeMoreButtonStatus ? InkWell(
                                                  onTap: () {
                                                    productProvider.setVariationSeeMoreStatus(!productProvider.variationsSeeMoreButtonStatus);
                                                  },
                                                  child: Row(children: [
                                                    const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                                                    Icon(Icons.keyboard_arrow_down, color: ColorResources.primaryColor),
                                                    const SizedBox(width: Dimensions.paddingSizeSmall),
                                                    Text("Lihat", style: rubikRegular.copyWith(color: ColorResources.primaryColor)),
                                                    Text("${variationList[index].variationValues!.length - 3}", style: rubikRegular.copyWith(color: ColorResources.primaryColor)),
                                                    Text("Lainnya", style: rubikRegular.copyWith(color: ColorResources.primaryColor))
                                                  ]),
                                                ) : OnHoverWidget(builder: (bool isHovered) => Container(
                                                  decoration: isHovered ? BoxDecoration(color: ColorResources.primaryColor.withOpacity(0.01)) : null,
                                                  child: InkWell(
                                                    onTap: () {
                                                      productProvider.setCartVariationIndex(index, i, widget.product, variationList[index].isMultiSelect!);
                                                      productProvider.checkIsRequiredSelected(
                                                          index: index,
                                                          isMultiSelect: variationList[index].isMultiSelect!,
                                                          variations: productProvider.selectedVariations[index],
                                                          min: variationList[index].min, max: variationList[index].max
                                                      );
                                                    },
                                                    child: Row(children: [
                                                     Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                                        variationList[index].isMultiSelect! ? Checkbox(
                                                          value: productProvider.selectedVariations[index][i],
                                                          activeColor: ColorResources.primaryColor,
                                                          checkColor: Theme.of(context).cardColor,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
                                                          side: BorderSide(color: productProvider.selectedVariations[index][i]! ? Colors.transparent : Theme.of(context).hintColor, width: 1),
                                                          onChanged: (bool? newValue) {
                                                            productProvider.setCartVariationIndex(
                                                              index, i, widget.product, variationList[index].isMultiSelect!
                                                            );
                                                            productProvider.checkIsRequiredSelected(
                                                              index: index,
                                                              isMultiSelect: variationList[index].isMultiSelect!,
                                                              variations: productProvider.selectedVariations[index],
                                                              min: variationList[index].min, max: variationList[index].max
                                                            );

                                                          },
                                                          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                                                        ) : Radio(
                                                          value: i,
                                                          groupValue: productProvider.selectedVariations[index].indexOf(true),
                                                          onChanged: (dynamic value) {
                                                            productProvider.setCartVariationIndex(
                                                              index, i, widget.product,
                                                              variationList[index].isMultiSelect!
                                                            );
                                                            productProvider.checkIsRequiredSelected(
                                                                index: index, isMultiSelect: false,
                                                                variations: productProvider.selectedVariations[index]
                                                            );
                                                          },
                                                          fillColor: WidgetStateColor.resolveWith((states) => states.contains(WidgetState.selected)
                                                              ? ColorResources.primaryColor : Theme.of(context).hintColor
                                                            ),
                                                          toggleable: false,
                                                          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
                                                          ),

                                                       Text(
                                                         variationList[index].variationValues![i].level!.trim(),
                                                         maxLines: 1, overflow: TextOverflow.ellipsis,
                                                         style: robotoRegular.copyWith(
                                                           fontSize: Dimensions.fontSizeSmall,
                                                           color: productProvider.selectedVariations[index][i]!
                                                             ? Theme.of(context).textTheme.bodyMedium?.color
                                                               : Theme.of(context).hintColor
                                                         ),
                                                       )
                                                     ]),

                                                      const Spacer(),

                                                      CustomDirectionalityWidget(child: Text(
                                                        variationList[index].variationValues![i].optionPrice! > 0
                                                            ? PriceConverterHelper.convertPrice(variationList[index].variationValues![i].optionPrice)
                                                            : 'Gratis',
                                                        maxLines: 1, overflow: TextOverflow.ellipsis,
                                                        style: robotoRegular.copyWith(
                                                            fontSize: Dimensions.fontSizeSmall,
                                                            color: productProvider.selectedVariations[index][i]!
                                                                ? Theme.of(context).textTheme.bodyMedium?.color : Theme.of(context).hintColor
                                                        ),
                                                      ))
                                                    ]),
                                                  ),
                                                ));
                                              },
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                      : const SizedBox()
                                ]),
                              ),
                            ))
                          ],
                        )),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge, vertical: Dimensions.paddingSizeSmall),
                          child: Row(children: [
                           Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Text('Total ', style: rubikSemiBold.copyWith(color: ColorResources.primaryColor)),
                           ]),

                           const Spacer(),

                           CustomDirectionalityWidget(child: Text(
                             PriceConverterHelper.convertPrice(totalPrice),
                             style: rubikSemiBold.copyWith(color: ColorResources.primaryColor),
                           )),

                           const SizedBox(width: Dimensions.paddingSizeSmall),

                            (priceWithVariationsWithoutDiscount > totalPrice) ? CustomDirectionalityWidget(child: Text(
                              PriceConverterHelper.convertPrice(priceWithVariationsWithoutDiscount),
                              style: rubikSemiBold.copyWith(
                                color: Theme.of(context).disabledColor,
                                fontSize: Dimensions.fontSizeSmall,
                                decoration: TextDecoration.lineThrough
                              ),
                            )) : const SizedBox(),

                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                          child: Row(children: [
                            _quantityButton(context),
                            const SizedBox(width: Dimensions.paddingSizeLarge),
                            Expanded(child: _cartButton(isAvailable, context, cartModel, variationList))
                          ]),
                        ),

                        const SizedBox(height: Dimensions.paddingSizeDefault)
                      ]);
                    }),
                  ),
                ),
            )
        ]);
      }),
    );
  }

  Widget _quantityButton(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Row(children: [
      InkWell(
          onTap: ()=> productProvider.quantity! > 1 ? productProvider.setQuantity(false) : null,
          child: Container(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              decoration: BoxDecoration(
                  color: ColorResources.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge)
              ),
              child: const Icon(Icons.remove, size: Dimensions.fontSizeExtraLarge)
          )
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
        child: Text(productProvider.quantity.toString(), style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge)),
      ),
      InkWell(
        onTap: () {
          final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
          int quantity = cartProvider.getCartProductQuantityCount(widget.product!);
          
          if(productProvider.checkStock(
            widget.cartModel != null ? widget.cartModel!.product! : widget.product!,
            quantity: (productProvider.quantity ?? 0) + quantity
          )) {
            productProvider.setQuantity(true);
          } else {
            showCustomSnackBarHelper("Stok habis");
          }
        },
        child: Container(
          padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
          decoration: BoxDecoration(
            color: ColorResources.primaryColor,
            borderRadius: BorderRadius.circular(Dimensions.radiusExtraLarge),
          ),
          child: const Icon(Icons.add, size: Dimensions.fontSizeExtraLarge, color: Colors.white)
        ),
      )
    ]);
  }

  Widget _cartButton(bool isAvailable, BuildContext context, CartModel cartModel, List<Variation>? variationList) {
    return Column(children: [
      isAvailable ? const SizedBox() :
      Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
        margin: const EdgeInsets.only(bottom: Dimensions.paddingSizeSmall),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: ColorResources.primaryColor.withOpacity(0.1)
        ),
        child: Column(children: [
         Text("Tidak tersedia sekarang", style: rubikSemiBold.copyWith(
           color: ColorResources.primaryColor,
           fontSize: Dimensions.fontSizeLarge
          )),

        Text('Akan tersedia pada ${DateConverterHelper.convertTimeToTime(widget.product!.availableTimeStarts!, context)} - ${DateConverterHelper.convertTimeToTime(widget.product!.availableTimeEnds!, context)}',
          style: rubikRegular, overflow: TextOverflow.ellipsis,)
        ]),
      ),

      Consumer<ProductProvider>(builder: (context, productProvider, _) {
        final cartProvider = Provider.of<CartProvider>(context, listen: false);
        int quantity = cartProvider.getCartProductQuantityCount(widget.product!);

        return CustomButtonWidget(
          btnTxt: widget.cartModel != null ? 'Perbarui keranjang' : 'Tambah ke keranjang',
          textStyle: rubikSemiBold.copyWith(color: Colors.white),
          backgroundColor: ColorResources.primaryColor,
          onTap: widget.cartModel == null && !productProvider.checkStock(widget.product!, quantity: quantity) ? null : (){
            if(variationList != null) {
              for(int index = 0; index < variationList.length; index++) {
                if(!variationList[index].isMultiSelect! && variationList[index].isRequired!
                && !productProvider.selectedVariations[index].contains(true)) {
                  showCustomSnackBarHelper("Pilih variasi dari produk ${variationList[index].name}", isToast: true, isError: false);
                  return;
                } else if(variationList[index].isMultiSelect! && (variationList[index].isRequired!
                || productProvider.selectedVariations[index].contains(true)) && variationList[index].min!
                > productProvider.selectedVariationLength(productProvider.selectedVariations, index)) {
                  showCustomSnackBarHelper("Kamu harus memilih minimal ${variationList[index].min} sampai maksimal ${variationList[index].max} "
                      "dari variasi produk ${variationList[index].name}", isToast: true, isError: false);
                  return;
                }
              }
            }
            context.pop();
            Provider.of<CartProvider>(context, listen: false).addToCart(cartModel, widget.cartModel != null ? widget.cartIndex : productProvider.cartIndex);
          }
        );
      })
    ]);
  }
}

class ScrollableBottomSheet extends StatelessWidget {
  final bool isDraggableEnable;
  final Widget child;

  const ScrollableBottomSheet({
    super.key,
    required this.child,
    required this.isDraggableEnable
  });

  @override
  Widget build(BuildContext context) {
    return !isDraggableEnable? child : child;
  }
}

class _CartProductDescription extends StatelessWidget {
  final Product product;

  const _CartProductDescription({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return product.description != null && product.description!.isNotEmpty ? Column(children: [
     Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text('Deskripsi', style: rubikSemiBold),
     ]),

     const SizedBox(height: Dimensions.paddingSizeExtraSmall),

     Align(
       alignment: Alignment.topLeft,
       child: ReadMoreText(
         product.description ?? '',
         trimLines: 1,
         trimCollapsedText: 'Lihat lebih banyak',
         trimExpandedText: 'Lihat lebih sedikit',
         style: rubikRegular.copyWith(
           color: Theme.of(context).hintColor,
           fontSize: Dimensions.fontSizeSmall
         ),
         moreStyle: rubikRegular.copyWith(
           color: Theme.of(context).hintColor,
           fontSize: Dimensions.fontSizeSmall
         ),
         lessStyle: rubikRegular.copyWith(
           color: Theme.of(context).hintColor,
           fontSize: Dimensions.fontSizeSmall
         ),
       ),
     ),

    const SizedBox(height: Dimensions.paddingSizeLarge)
    ]) : const SizedBox();
  }
}