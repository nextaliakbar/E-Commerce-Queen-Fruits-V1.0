import 'dart:typed_data';
import 'dart:ui';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/confirm_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/cost_summery_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/widgets/item_view_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/payment_details_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/models/check_out_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/delivery_details_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/slot_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/upside_expansion_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/localization/app_localization.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final double? amount;
  final List<CartModel>? cartList;
  final bool fromCart;

  const CheckoutScreen({
    super.key,
    required this.amount,
    required this.fromCart,
    required this.cartList
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final ScrollController scrollController = ScrollController();
  final GlobalKey dropdownKey = GlobalKey();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  final TextEditingController _noteController = TextEditingController();
  late bool _isLoggedIn;
  late List<CartModel?> _cartList;
  final List<PaymentMethod> _paymentList = [];
  final List<Color> _paymentColor = [];
  Branches? currentBranch;

  @override
  void initState() {
    super.initState();
    _onInitLoad();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    bool kmWiseCharge = CheckOutHelper.isKmCharge(deliveryInfoModel: splashProvider.deliveryInfoModel!);
    bool takeAway = Provider.of<CheckoutProvider>(context, listen: false).orderType == OrderType.takeAway;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      appBar: CustomAppBarWidget(
        context: context, title: "Pemesanan", centerTitle: false,
        leading: InkWell(
          onTap: () => context.pop(),
          child: Icon(Icons.arrow_back_ios_rounded, color: ColorResources.primaryColor),
        ),
      ) as PreferredSizeWidget?,

      body: _isLoggedIn ?  Column(children: [
        Expanded(child: CustomScrollView(controller: scrollController, slivers: [

          SliverToBoxAdapter(child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
            return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {


              checkoutProvider.checkOutData?.copyWith(deliveryCharge: checkoutProvider.deliveryCharge);

              return Center(child: Container(alignment: Alignment.topCenter, width: Dimensions.webScreenWidth, child: Column(children: [

                Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Expanded(flex: 6, child: Container(
                    margin: EdgeInsets.only(
                      left:  Dimensions.paddingSizeDefault,
                      right: Dimensions.paddingSizeDefault,
                      top: Dimensions.paddingSizeDefault,
                      bottom: Dimensions.paddingSizeDefault,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

                      /// for Delivery to & Delivery type
                      DeliveryDetailsWidget(
                        currentBranch: currentBranch,
                        kmWiseCharge: kmWiseCharge,
                        deliveryCharge: checkoutProvider.deliveryCharge,
                        amount: widget.amount,
                        dropdownKey: dropdownKey,
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),


                      /// for Time Slot
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusDefault)],
                        ),
                        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text("Waktu Preferensi", style: rubikBold.copyWith(
                            fontSize:Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                          )),

                          const SizedBox(height: Dimensions.paddingSizeExtraSmall),

                          SizedBox(height: 50, child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            itemCount: 2,
                            itemBuilder: (context, index) {
                              return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                Radio(
                                  activeColor: ColorResources.primaryColor,
                                  value: index,
                                  groupValue: checkoutProvider.selectDateSlot,
                                  onChanged: (value)=> checkoutProvider.updateDateSlot(index),
                                ),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Text(index == 0 ? "Hari Ini" : "Besok", style: rubikRegular.copyWith(
                                  color: index == checkoutProvider.selectDateSlot ? ColorResources.primaryColor : Theme.of(context).textTheme.bodyLarge?.color,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),
                              ]);
                            },
                          )),
                          const SizedBox(height: Dimensions.paddingSizeSmall),

                          SizedBox(
                            height: 40,
                            child: checkoutProvider.timeSlots != null ? checkoutProvider.timeSlots!.isNotEmpty ? ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemCount: checkoutProvider.timeSlots!.length,
                              itemBuilder: (context, index) {
                                return SlotWidget(
                                  title: (
                                      index == 0 && checkoutProvider.selectDateSlot == 0  && splashProvider.isStoreOpenNow(context))
                                      ? "Secepatnya"
                                      : '${DateConverterHelper.dateToTimeOnly(checkoutProvider.timeSlots![index].startTime!, context)} '
                                      '- ${DateConverterHelper.dateToTimeOnly(checkoutProvider.timeSlots![index].endTime!, context)}',
                                  isSelected: checkoutProvider.selectTimeSlot == index,
                                  onTap: () => checkoutProvider.updateTimeSlot(index),
                                );
                              },
                            ) : Center(child: Text("Slot Tidak Tersedia")) : const Center(child: CircularProgressIndicator()),
                          ),
                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      PaymentDetailsWidget(total: (widget.amount ?? 0) + (checkoutProvider.deliveryCharge)),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor.withOpacity(0.5), blurRadius: Dimensions.radiusDefault)],
                        ),
                        padding:  const EdgeInsets.all(Dimensions.paddingSizeLarge),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Tambah Catatan', style: rubikBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            fontWeight: FontWeight.w600,
                          )),
                          const SizedBox(height: Dimensions.fontSizeSmall),

                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                              border: Border.all(color: Theme.of(context).disabledColor.withOpacity(0.2), width: 1),
                            ),
                            child: CustomTextFieldWidget(
                              controller: _noteController,
                              hintText: "Catatan",
                              maxLines: 5,
                              inputType: TextInputType.multiline,
                              inputAction: TextInputAction.newline,
                              capitalization: TextCapitalization.sentences,
                              radius: Dimensions.radiusSmall,
                            ),
                          ),

                        ]),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                    ]),
                  )),
                ]),

              ])));
            });
          })),
        ])),

        Consumer<CheckoutProvider>(
          builder: (context, checkoutProvider, _) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [BoxShadow(color: Theme.of(context).primaryColor.withOpacity(0.1), blurRadius: 10)],
                borderRadius: const BorderRadius.vertical(top: Radius.circular(Dimensions.radiusDefault)),
              ),
              padding: const EdgeInsets.only(
                left: Dimensions.paddingSizeDefault,
                right: Dimensions.paddingSizeDefault,
                bottom: Dimensions.paddingSizeSmall,
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(children: [

                UpsideExpansionWidget(
                  title: ItemViewWidget(
                    title: "Total Jumlah",
                    subTitle: PriceConverterHelper.convertPrice(widget.amount! + (checkoutProvider.orderType == OrderType.takeAway ? 0 : checkoutProvider.deliveryCharge)),
                    titleStyle: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeExtraLarge, color: ColorResources.primaryColor),
                  ),
                  children: [
                    SizedBox(height : 150, child: CostSummeryWidget(
                      kmWiseCharge: kmWiseCharge,
                      deliveryCharge: (takeAway ? 0 : checkoutProvider.deliveryCharge),
                      subtotal: widget.amount,
                    )),
                  ],
                ),

                ConfirmButtonWidget(
                  noteController: _noteController,
                  callBack: _callback,
                  cartList: _cartList,
                  kmWiseCharge: kmWiseCharge,
                  orderType: checkoutProvider.orderType,
                  orderAmount: widget.amount!,
                  deliveryCharge: (takeAway ? 0 : checkoutProvider.deliveryCharge),
                  scrollController: scrollController,
                  dropdownKey: dropdownKey,
                ),
              ]),
            );
          },
        ),
      ]) : const SizedBox(),
    );
  }

  Future<void> _onInitLoad() async {
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
    locationProvider.setAreaId(isUpdate: false, isReload: true);
    checkoutProvider.setDeliveryCharge(isReload: true, isUpdate: false);

    double deliveryCharge = 0;
    _cartList = [];

    widget.fromCart ? _cartList.addAll(cartProvider.cartList) : _cartList.addAll(widget.cartList!);

    if(cartProvider.cartList.isEmpty) {
      RouterHelper.getDashboardRouter('cart');
    }

    currentBranch = Provider.of<BranchProvider>(context, listen: false).getBranch();
    splashProvider.getOfflinePaymentMethod(true);

    checkoutProvider.clearPrevData();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(_isLoggedIn) {
      profileProvider.getUserInfo(false, isUpdate: false);

      checkoutProvider.initializeTimeSlot(context).then((value) {
        checkoutProvider.sortTime();
      });

      await locationProvider.initAddressList();

      await CheckOutHelper.selectDeliveryAddressAuto(
        isLoggedIn: _isLoggedIn,
        orderType: checkoutProvider.orderType,
        lastAddress: await locationProvider.getDefaultAddress()
      );

      deliveryCharge = CheckOutHelper.getDeliveryCharge(
        googleMapStatus: splashProvider.configModel!.googleMapStatus!,
        distance: checkoutProvider.distance,
        shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0,
        minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble() ?? 0,
        minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0,
        isTakeAway: checkoutProvider.orderType == OrderType.takeAway,
        kmWiseCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance'
      );

      checkoutProvider.setDeliveryCharge(deliveryCharge: deliveryCharge, isUpdate: true);
      checkoutProvider.setCheckOutData = CheckOutModel(
          orderType: checkoutProvider.orderType.name.camelCaseToSnakeCase(),
          amount: widget.amount,
          deliveryCharge: checkoutProvider.deliveryCharge,
          placeOrderDiscount: 0,
          orderNote: null
      );
    }
  }

  Future<void> _callback(bool isSuccess, String message, String orderId, int addressId) async {
    if(isSuccess) {
      if(widget.fromCart) {
        Provider.of<CartProvider>(context, listen: false).clearCartList();
      }
      Provider.of<OrderProvider>(context, listen: false).stopLoader();
      RouterHelper.getOrderSuccessScreen(orderId, 'success');
    } else {
      showCustomSnackBarHelper(message);
    }
  }

  Future<Uint8List> convertAssetToUnit8List(String imagePath, {int width = 30}) async {
    ByteData data = await rootBundle.load(imagePath);
    Codec codec = await instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ImageByteFormat.png))!.buffer.asUint8List();
  }
}
