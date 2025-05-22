import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/delivery_info_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/offline_payment_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_loader.widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/delivery_fee_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckOutHelper {
  static bool isKmCharge({required DeliveryInfoModel? deliveryInfoModel})
  => deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance' ? true : false;

  static Future<void> selectDeliveryAddressAuto({AddressModel? lastAddress, required bool isLoggedIn, required OrderType? orderType}) async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(Get.context!, listen: false);
    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);

    AddressModel? deliveryAddress = CheckOutHelper.getDeliveryAddress(
        addressList: locationProvider.addressList,
        selectedAddress: checkoutProvider.addressIndex == -1 ? null : locationProvider.addressList?[checkoutProvider.addressIndex],
        lastOrderAddress: lastAddress
    );

    if(isLoggedIn && orderType == OrderType.delivery && deliveryAddress != null
        && locationProvider.getAddressIndex(deliveryAddress) != null) {

      await CheckOutHelper.selectDeliveryAddress(
          isAvailable: true,
          index: locationProvider.getAddressIndex(deliveryAddress)!,
          configModel: splashProvider.configModel!,
          locationProvider: locationProvider,
          checkoutProvider: checkoutProvider,
          splashProvider: splashProvider,
          fromAddressList: false
      );
    }
  }

  static AddressModel? getDeliveryAddress({
    required List<AddressModel?>? addressList,
    required AddressModel? selectedAddress,
    required AddressModel? lastOrderAddress
  }) {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(Get.context!, listen: false);

    AddressModel? deliveryAddress;

    if(selectedAddress != null) {
      deliveryAddress = selectedAddress;
    } else if(lastOrderAddress != null) {
      deliveryAddress = lastOrderAddress;
    } else if(addressList != null && addressList.isNotEmpty) {
      deliveryAddress = addressList.first;
    }

    if(deliveryAddress != null && !isAddressCoverage(branchProvider.getBranch(), deliveryAddress)
        && splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargeType == 'distance') {
      deliveryAddress = null;
    }

    return deliveryAddress;
  }

  static bool isAddressCoverage(Branches? currentBranch, AddressModel addressModel) {
    bool isAvailable = currentBranch == null || (currentBranch.latitude == null || currentBranch.latitude!.isEmpty);

    if(!isAvailable && addressModel.latitude != null && addressModel.longitude != null) {
      double distance = Geolocator.distanceBetween(
          double.parse(currentBranch.latitude!), double.parse(currentBranch.longitude!),
          double.parse(addressModel.latitude!), double.parse(addressModel.longitude!)) / 1000;

      isAvailable = distance < (currentBranch.coverage ?? 0);
    }

    return isAvailable;
  }

  static Future<void> selectDeliveryAddress({
    required bool isAvailable,
    required int index,
    required ConfigModel? configModel,
    required LocationProvider locationProvider,
    required CheckoutProvider checkoutProvider,
    required SplashProvider splashProvider,
    required bool fromAddressList
  }) async {
    if(isAvailable) {
      Branches? currentBranch = Provider.of<BranchProvider>(Get.context!, listen: false).getBranch();
      locationProvider.updateAddressIndex(index, fromAddressList);
      checkoutProvider.setAddressIndex(index, isUpdate: true);

      if(CheckOutHelper.isKmCharge(deliveryInfoModel: splashProvider.deliveryInfoModel ?? DeliveryInfoModel())) {
        showDialog(context: Get.context!, builder: (context) => Center(child: Container(
          height: 100, width: 100, alignment: Alignment.center,
          decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(10)),
          child: CustomLoaderWidget(color: ColorResources.primaryColor)
        )), barrierDismissible: false);

        bool isSuccess = await checkoutProvider.getDistanceInMeter(
          LatLng(
              double.tryParse('${currentBranch?.latitude}') ?? 0,
              double.tryParse('${currentBranch?.longitude}') ?? 0
          ),
          LatLng(
              double.tryParse('${locationProvider.addressList?[index].latitude}') ?? 0,
              double.tryParse('${locationProvider.addressList?[index].longitude}') ?? 0
          ),
        );

        Navigator.pop(Get.context!);

        if(fromAddressList) {
          await showDialog(context: Get.context!, builder: (context) => DeliveryFeeDialogWidget(
              amount: checkoutProvider.checkOutData?.amount, 
              distance: checkoutProvider.distance,
              callBack: (deliveryCharge) {
                checkoutProvider.setDeliveryCharge(deliveryCharge: deliveryCharge, isUpdate: false);
                checkoutProvider.checkOutData?.copyWith(deliveryCharge: deliveryCharge);
              }));
        } else {
          checkoutProvider.checkOutData?.copyWith(deliveryCharge: getDeliveryCharge(
              googleMapStatus: configModel?.googleMapStatus ?? 0, 
              distance: checkoutProvider.distance, 
              shippingPerKm: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.deliveryChargePerKilometer?.toDouble() ?? 0, 
              minShippingCharge: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDeliveryCharge?.toDouble() ?? 0, 
              minimumDistanceForFreeDelivery: splashProvider.deliveryInfoModel?.deliveryChargeSetup?.minimumDistanceForFreeDelivery?.toDouble() ?? 0
          ));
          checkoutProvider.setDeliveryCharge(deliveryCharge: checkoutProvider.checkOutData?.deliveryCharge, isUpdate: false);
        }
        
        if(!isSuccess) {
          showCustomSnackBarHelper('Gagal mendapatkan jarak');
        } else {
          checkoutProvider.setAddressIndex(index);
        }
      }
    } else {
      showCustomSnackBarHelper("Lokasi ini diluar cakupan radius cabang");
    }
  }

  static double getDeliveryCharge({
    // required SplashProvider splashProvider,
    required int googleMapStatus,
    // int? areaId,
    required double distance,
    required double shippingPerKm,
    required double minShippingCharge,
    // required double defaultDeliveryCharge,
    required double minimumDistanceForFreeDelivery,
    bool isTakeAway = false,
    bool kmWiseCharge = true
  }) {
    double deliveryCharge = 0;
    if(googleMapStatus == 1) {
      if(!isTakeAway && kmWiseCharge && distance != -1) {
        if(minimumDistanceForFreeDelivery != 0 && distance <= minimumDistanceForFreeDelivery) {
          deliveryCharge = 0.0;
        } else {
          deliveryCharge = distance * shippingPerKm;
          if(deliveryCharge < shippingPerKm) {
            deliveryCharge = minShippingCharge;
          }
        }
      }
    }
    return deliveryCharge;
  }

  static bool isAddressInCoverage(Branches? currentBranch, AddressModel addressModel) {
    bool isAvailable = currentBranch == null || (currentBranch.latitude == null || currentBranch.latitude!.isEmpty);
    if(!isAvailable && addressModel.longitude != null && addressModel.latitude != null) {
      double distance = Geolocator.distanceBetween(
          double.parse(currentBranch.latitude!),
          double.parse(currentBranch.longitude!),
          double.parse(addressModel.latitude!),
          double.parse(addressModel.longitude!)
      ) / 1000;

      isAvailable = distance < (currentBranch.coverage ?? 0);
    }

    return isAvailable;
  }

  static List<Map<String, dynamic>> getOfflineMethodJson(List<MethodField>? methodList) {
    List<Map<String, dynamic>> mapList = [];
    List<String?> keyList = [];
    List<String?> valueList = [];

    for(MethodField methodField in (methodList ?? [])) {
      keyList.add(methodField.fieldName);
      valueList.add(methodField.fieldData);
    }

    for(int i = 0; i < keyList.length; i++) {
      mapList.add({'${keyList[i]}': '${valueList[i]}'});
    }

    return mapList;
  }
}