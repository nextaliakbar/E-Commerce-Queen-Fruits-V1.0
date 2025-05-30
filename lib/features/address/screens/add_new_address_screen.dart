import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/input_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/app_address_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/person_info_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/save_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../../common/models/delivery_info_model.dart';

class AddNewAddressScreen extends StatefulWidget {
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? addressModel;

  const AddNewAddressScreen({
    super.key,
    this.isEnableUpdate = false,
    this.addressModel,
    this.fromCheckout = false
  });

  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController _contactPersonNameController = TextEditingController();
  final TextEditingController _contactPersonNumberController = TextEditingController();
  final TextEditingController _locationTextController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  final FocusNode _addressNode = FocusNode();
  final FocusNode _nameNode = FocusNode();
  final FocusNode _numberNode = FocusNode();

  DeliveryInfoModel? _deliveryInfoModel;

  final List<Branches?> _branches = [];
  bool _updateAddress = false;

  GlobalKey<FormState> addressFormKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _initLoading();

    if(widget.addressModel != null && !widget.fromCheckout) {
      _locationTextController.text = widget.addressModel!.address!;
    }
  }

  Future<void> _initLoading() async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    _deliveryInfoModel = splashProvider.deliveryInfoModel;

    final userModel = Provider.of<ProfileProvider>(context, listen: false).userInfoModel;

    _branches.addAll(splashProvider.configModel?.branches ?? []);
    locationProvider.initializeAllAddressType();
    locationProvider.updateAddressStatusMessage(message: '');
    locationProvider.updateErrorMessage(message: '');
    locationProvider.onChangeDefaultStatus(false, isUpdate: false);
    locationProvider.setPickedAddressLatLon(null, null, isUpdate: false);

    if(widget.isEnableUpdate && widget.addressModel != null) {

      _updateAddress = true;

      locationProvider.onChangeDefaultStatus(widget.addressModel?.isDefault ?? false, isUpdate: false);
      locationProvider.setPickedAddressLatLon(widget.addressModel!.latitude, widget.addressModel!.longitude, isUpdate: false);

      if(splashProvider.configModel?.googleMapStatus == 1) {
        if(widget.addressModel?.latitude != null && widget.addressModel?.longitude != null) {
          locationProvider.updatePosition(CameraPosition(
            target: LatLng(double.parse(widget.addressModel!.latitude!), double.parse(widget.addressModel!.longitude!))
          ), true, widget.addressModel!.address!, context, false, isUpdate: false);
        }
      }

      _contactPersonNameController.text = '${widget.addressModel!.contactPersonName}';
      _contactPersonNumberController.text = '${widget.addressModel!.contactPersonNumber}';

      if(widget.addressModel?.addressType == 'Home') {
        locationProvider.updateAddressIndex(0, false);
      } else if(widget.addressModel?.addressType == 'Workplace') {
        locationProvider.updateAddressIndex(1, false);
      } else {
        locationProvider.updateAddressIndex(2, false);
      }
    } else {
      if(authProvider.isLoggedIn()) {
        _contactPersonNameController.text = '${userModel?.fName ?? ''}'' ${userModel?.lName ?? ''}';
        _contactPersonNumberController.text = userModel?.phone ?? '';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBarWidget(
        context: context,
        title: widget.isEnableUpdate ? 'Perbarui Alamat' : 'Tambah Informasi Pengiriman',
        centerTitle: true,
      ) as PreferredSizeWidget?,
      body: Consumer<LocationProvider>(builder: (context, locationProvider, child) {
       return Form(key: addressFormKey, child: Column(children: [
          Expanded(child: SingleChildScrollView(child: Column(children: [
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: height - 400),
              child: Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge), child: Center(
                child: SizedBox(
                  child: Column(children: [
                    PersonInfoWidget(
                      contactPersonNameController: _contactPersonNameController,
                      contactPersonNumberController: _contactPersonNumberController,
                      nameNode: _nameNode,
                      numberNode: _numberNode,
                      isEnableUpdate: widget.isEnableUpdate,
                      fromCheckout: widget.fromCheckout,
                      addressModel: widget.addressModel,
                    ),

                    const SizedBox(height: Dimensions.paddingSizeDefault),

                    AppAddressWidget(
                      inputModel: InputModel(
                          nameNode: _nameNode,
                          addressNode: _addressNode,
                          locationTextController: _locationTextController,
                          branches: _branches,
                          isEnableUpdate: widget.isEnableUpdate,
                          fromCheckout: widget.fromCheckout,
                          updateAddress: _updateAddress,
                      ),
                      onUpdateAddress: (status) {
                        _updateAddress = status;
                        _locationTextController.text = locationProvider.address ?? '';
                      },
                      deliveryInfoModel: _deliveryInfoModel,
                      searchController: _searchController
                    ),

                    Row(children: [
                      const DefaultAddressStatusWidget(),
                      const SizedBox(width: Dimensions.paddingSizeSmall),
                      Text("Jadikan sebagai alamat utama",style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ])
                  ]),
                ),
              )),
            )
          ]))),

         Padding(
           padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
           child: Column(children: [
            locationProvider.addressStatusMessage != null
            ? Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              locationProvider.addressStatusMessage!.isNotEmpty
              ? const CircleAvatar(backgroundColor: Colors.green, radius: Dimensions.radiusSmall)
                  : const SizedBox.shrink(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Text(locationProvider.addressStatusMessage ?? '',
              style: rubikSemiBold.copyWith(
               fontSize: Dimensions.fontSizeSmall,
               color: Colors.green,
               height: 1
              )))
            ]) : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
             locationProvider.errorMessage!.isNotEmpty
                 ? const CircleAvatar(backgroundColor: Colors.red, radius: Dimensions.radiusSmall)
                 : const SizedBox.shrink(),
              const SizedBox(width: Dimensions.paddingSizeSmall),

              Expanded(child: Text(locationProvider.errorMessage ?? '',
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontSize: Dimensions.fontSizeSmall,
                  color: Theme.of(context).colorScheme.error,
                  height: 1
              )))
            ]),

             SaveButtonWidget(
               addressModel: widget.addressModel,
               fromCheckOut: widget.fromCheckout,
               isEnableUpdate: widget.isEnableUpdate,
               onTap: () => _saveAddress(locationProvider),
             ),
             const SizedBox(height: Dimensions.paddingSizeDefault)
           ]),
         )
       ]));
      }),
    );
  }

  void _saveAddress(LocationProvider locationProvider) {
    final ConfigModel? configModel = Provider.of<SplashProvider>(context, listen: false).configModel;

    if(addressFormKey.currentState != null && addressFormKey.currentState!.validate()) {
      List<Branches?> branches = configModel!.branches!;
      bool isAvailable = branches.length == 1 && (branches[0]!.latitude == null || branches[0]!.latitude!.isEmpty);

      if(!isAvailable) {
        for(Branches? branch in branches) {
          double distance = Geolocator.distanceBetween(
              double.parse(branch!.latitude!), double.parse(branch.longitude!),
              locationProvider.position.latitude, locationProvider.position.longitude
          ) / 1000;

          if(distance < branch.coverage!) {
            isAvailable = true;
            debugPrint("Loc Lat : ${locationProvider.position.latitude}");
            debugPrint("Loc Lon : ${locationProvider.position.longitude}");
            debugPrint("Distance $distance");
            break;
          }
        }
      }


      if(!isAvailable && configModel.googleMapStatus == 1) {
        showCustomSnackBarHelper("Area pengiriman tidak tersedia");
      } else {
        String? latitude;
        String? longitude;

        if(configModel.googleMapStatus == 1) {
          latitude = locationProvider.position.latitude.toString();
          longitude = locationProvider.position.longitude.toString();
        } else {
          latitude = null;
          longitude = null;
        }

        var addressModel = AddressModel(
            addressType: locationProvider.getAllAddressType[locationProvider.selectAddressIndex],
            contactPersonName: _contactPersonNameController.text,
            contactPersonNumber: _contactPersonNumberController.text.trim().isEmpty ? ''
                : _contactPersonNumberController.text.trim() ,
            address: _locationTextController.text,
            latitude: latitude,
            longitude: longitude,
            isDefault: locationProvider.isDefault
        );

        if(widget.isEnableUpdate) {
          addressModel.id = widget.addressModel!.id;
          addressModel.userId = widget.addressModel!.userId;
          addressModel.method = 'put';
          locationProvider.updateAddress(context, addressModel: addressModel, addressId: addressModel.id).then((value) {
            if(value.isSuccess){
              if(Get.context!.canPop()) {
                Get.context!.pop();
              }
              showCustomSnackBarHelper("Alamat berhasil diperbarui", isError: false);
            }  else {
              showCustomSnackBarHelper("Alamat gagal diperbarui, silahkan ulangi kembali");
            }
          });
        } else {
          locationProvider.addAddress(addressModel).then((value) {
            if(value.isSuccess) {
              if(Get.context!.canPop()) {
                Get.context!.pop();
              }

              if(!widget.fromCheckout || !Get.context!.canPop()) {
                showCustomSnackBarHelper("Alamat berhasil ditambahkan", isError: false);
              }
            } else {
              showCustomSnackBarHelper("Alamat gagal ditambahkan, silangkan ulangi kembali", isError: true);
            }
          });
        }
      }
    }
  }
}

class DefaultAddressStatusWidget extends StatelessWidget {
  const DefaultAddressStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, _) {
        return Checkbox(
          value: locationProvider.isDefault,
          activeColor: ColorResources.primaryColor,
          checkColor: Theme.of(context).cardColor,
          side: WidgetStateBorderSide.resolveWith((states) {
            if(states.contains(WidgetState.pressed)) {
              return BorderSide(color: ColorResources.primaryColor);
            } else {
              return BorderSide(color: ColorResources.primaryColor);
            }
          }),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
          onChanged: (bool? value) {
            locationProvider.onChangeDefaultStatus(value ?? false);
          },
          visualDensity: const VisualDensity(horizontal: -3, vertical: -3),
        );
      },
    );
  }
}

