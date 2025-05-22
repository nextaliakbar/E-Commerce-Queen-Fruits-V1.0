import 'package:ecommerce_app_queen_fruits_v1_0/common/models/cart_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/place_order_body.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/address_change_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/payment_method_bottom_sheet_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/checkout_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/localization/app_localization.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:convert' as convert;

class ConfirmButtonWidget extends StatelessWidget {
  final bool kmWiseCharge;
  final double? deliveryCharge;
  final double orderAmount;
  final List<CartModel?> cartList;
  final OrderType orderType;
  final TextEditingController noteController;
  final Function callBack;
  final ScrollController scrollController;
  final GlobalKey dropdownKey;

  const ConfirmButtonWidget({
    super.key, required this.kmWiseCharge, this.deliveryCharge,
    required this.cartList, required this.orderAmount, required this.orderType,
    required this.noteController, required this.callBack,
    required this.scrollController, required this.dropdownKey,
  });

  @override
  Widget build(BuildContext context) {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final bool takeAway = orderType.name.camelCaseToSnakeCase() == 'take_away';

    return Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {
      return Container(
        width: Dimensions.webScreenWidth,
        alignment: Alignment.center,
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) => CustomButtonWidget(
            isLoading: orderProvider.isLoading,
            btnTxt: "Pesan",
            onTap: () async {
              final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);
              final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
              final ProfileProvider profileProvider = Provider.of<ProfileProvider>(context, listen: false);
              final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
              final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);


              if(!takeAway && (locationProvider.addressList == null || locationProvider.addressList!.isEmpty || checkoutProvider.addressIndex < 0)) {
                ResponsiveHelper.showDialogOrBottomSheet(context, AddressChangeWidget(
                  amount: orderAmount,
                  currentBranch: branchProvider.getBranch(),
                  kmWiseCharge: kmWiseCharge,
                ));

              } else {
                if(checkoutProvider.selectedOfflineValue != null){
                  bool isAvailable = true;
                  DateTime scheduleStartDate = DateTime.now();
                  DateTime scheduleEndDate = DateTime.now();

                  if(checkoutProvider.timeSlots == null || checkoutProvider.timeSlots!.isEmpty) {
                    isAvailable = false;

                  }else {
                    DateTime date = checkoutProvider.selectDateSlot == 0 ? DateTime.now() : DateTime.now().add(const Duration(days: 1));
                    DateTime startTime = checkoutProvider.timeSlots![checkoutProvider.selectTimeSlot].startTime!;
                    DateTime endTime = checkoutProvider.timeSlots![checkoutProvider.selectTimeSlot].endTime!;
                    scheduleStartDate = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute+1);
                    scheduleEndDate = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute+1);
                    for (CartModel? cart in cartList) {
                      if (!DateConverterHelper.isAvailable(cart!.product!.availableTimeStarts!, cart.product!.availableTimeEnds!, time: scheduleStartDate,)
                          && !DateConverterHelper.isAvailable(cart.product!.availableTimeStarts!, cart.product!.availableTimeEnds!, time: scheduleEndDate)
                      ) {
                        isAvailable = false;
                        break;
                      }
                    }
                  }

                  if(orderAmount < configModel.minimumOrderValue!) {
                    showCustomSnackBarHelper('Minimal jumlah pemesanan adalah ${configModel.minimumOrderValue}');
                  }else if (checkoutProvider.timeSlots == null || checkoutProvider.timeSlots!.isEmpty) {
                    showCustomSnackBarHelper("Pilih waktu");
                  }else if (!isAvailable) {
                    showCustomSnackBarHelper('Satu atau lebih produk tidak tersedia untuk waktu yang dipilih ini');
                  }else if (!takeAway && kmWiseCharge && checkoutProvider.distance == -1) {
                    showCustomSnackBarHelper("Biaya pengiriman belum ditetapkan");
                  }else {
                    List<Cart> carts = [];
                    for (int index = 0; index < cartList.length; index++) {
                      CartModel cart = cartList[index]!;
                      List<OrderVariation> variations = [];

                      if(cart.product!.variations != null && cart.variations != null && cart.variations!.isNotEmpty){
                        for(int i=0; i<cart.product!.variations!.length; i++) {
                          if(  cart.variations![i].contains(true)) {
                            variations.add(OrderVariation(
                              name: cart.product!.variations![i].name,
                              values: OrderVariationValue(label: []),
                            ));

                            for(int j=0; j<cart.product!.variations![i].variationValues!.length; j++) {
                              if(cart.variations![i][j]!) {
                                variations[variations.length-1].values!.label!.add(cart.product!.variations![i].variationValues![j].level);
                              }
                            }
                          }
                        }
                      }


                      carts.add(Cart(
                        cart.product!.id.toString(), cart.discountedPrice.toString(), [], variations,
                        cart.discountAmount, cart.quantity, cart.taxAmount
                      ));
                    }

                    PlaceOrderBody placeOrderBody = PlaceOrderBody(
                      cart: carts,
                      deliveryAddressId: !takeAway ? Provider.of<LocationProvider>(context, listen: false)
                          .addressList![checkoutProvider.addressIndex].id : 0,
                      orderAmount: double.parse(orderAmount.toStringAsFixed(2)),
                      orderNote: noteController.text, orderType: orderType.name.camelCaseToSnakeCase(),
                      paymentMethod: checkoutProvider.selectedOfflineValue != null
                          ? 'offline_payment' : checkoutProvider.selectedPaymentMethod!.getWay!,
                      distance: takeAway ? 0 : checkoutProvider.distance,
                      branchId: branchProvider.getBranch()?.id,
                      deliveryDate: DateFormat('yyyy-MM-dd').format(scheduleStartDate),
                      paymentInfo: checkoutProvider.selectedOfflineValue != null ?  OfflinePaymentInfo(
                        methodFields: CheckOutHelper.getOfflineMethodJson(checkoutProvider.selectedOfflineMethod?.methodFields),
                        methodInformation: checkoutProvider.selectedOfflineValue,
                        paymentName: checkoutProvider.selectedOfflineMethod?.methodName,
                        paymentNote: checkoutProvider.selectedOfflineMethod?.paymentNote,
                      ) : null,
                      deliveryTime: (checkoutProvider.selectTimeSlot == 0 && checkoutProvider.selectDateSlot == 0) ? 'now' : DateFormat('HH:mm').format(scheduleStartDate)
                    );

                    if(placeOrderBody.paymentMethod == 'offline_payment') {
                      orderProvider.placeOrder(placeOrderBody, callBack);
                    } else {
                      String? hostname = html.window.location.hostname;
                      String protocol = html.window.location.protocol;
                      String port = html.window.location.port;
                      final String placeOrder =  convert.base64Url.encode(convert.utf8.encode(convert.jsonEncode(placeOrderBody.toJson())));

                      String url = "customer_id=${profileProvider.userInfoModel!.id}"
                          "&&callback=${AppConstants.baseUrl}${RouterHelper.orderSuccessScreen}&&order_amount=${(orderAmount + (deliveryCharge ?? 0)).toStringAsFixed(2)}";

                      // String webUrl = "customer_id=${profileProvider.userInfoModel!.id}&&is_guest=0"
                      //     "&&callback=$protocol//$hostname${kDebugMode ? ':$port' : ''}${RouterHelper.orderWebPayment}&&order_amount=${(orderAmount + (deliveryCharge ?? 0)).toStringAsFixed(2)}&&status=";


                      String tokenUrl = convert.base64Encode(convert.utf8.encode(url));
                      String selectedUrl = '${AppConstants.baseUrl}/payment-mobile?token=$tokenUrl&&payment_method=${checkoutProvider.selectedPaymentMethod?.getWay}&&payment_platform=${kIsWeb ? 'web' : 'app'}';

                      orderProvider.clearPlaceOrder().then((_) => orderProvider.setPlaceOrder(placeOrder).then((value) {
                        if(kIsWeb){
                          html.window.open(selectedUrl,"_self");
                          showCustomSnackBarHelper("Pesanan berhasil dibuat");
                        }else{
                          context.pop();
                          // RouterHelper.getPaymentRoute(selectedUrl, fromCheckout: true);
                        }

                      }));
                    }
                  }
                } else{
                  ResponsiveHelper.showDialogOrBottomSheet(context, PaymentMethodBottomSheetWidget(totalPrice: orderAmount + (deliveryCharge ?? 0)));
                }
              }
            },
          ),
        ),
      );
    }
    );
  }

  void _openDropdown() {
    final dropdownContext = dropdownKey.currentContext;

    if (dropdownContext != null) {
      GestureDetector? detector;
      void searchGestureDetector(BuildContext context) {
        context.visitChildElements((element) {
          if (element.widget is GestureDetector) {
            detector = element.widget as GestureDetector?;
          } else {
            searchGestureDetector(element);
          }
        });
      }
      searchGestureDetector(dropdownContext);

      detector?.onTap?.call();
    }
  }
}
