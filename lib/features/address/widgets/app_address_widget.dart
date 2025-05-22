import 'package:ecommerce_app_queen_fruits_v1_0/common/models/delivery_info_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/input_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/widgets/profile_textfield_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AppAddressWidget extends StatefulWidget {
  final InputModel inputModel;
  final void Function(bool) onUpdateAddress;
  final DeliveryInfoModel? deliveryInfoModel;
  final TextEditingController searchController;
  final int? areaID;

  const AppAddressWidget({
    super.key,
    required this.inputModel,
    required this.onUpdateAddress,
    this.deliveryInfoModel,
    required this.searchController,
    this.areaID
  });

  @override
  State<AppAddressWidget> createState() => _AppAddressWidgetState();
}

class _AppAddressWidgetState extends State<AppAddressWidget> {
  late GoogleMapController controller;
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      if(widget.inputModel.locationTextController.text.isEmpty || (locationProvider.address?.isNotEmpty ?? false)) {
        Future.delayed(const Duration(milliseconds: 100), () {
          widget.inputModel.locationTextController.text = locationProvider.address ?? '';
        });
      }

      return Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          boxShadow: [BoxShadow(
              color: ColorResources.cardShadowColor.withOpacity(0.2),
              blurRadius: Dimensions.radiusDefault
          )],
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeDefault
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
         Padding(
           padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeLarge),
           child: Text("Alamat Pengiriman", style: rubikSemiBold.copyWith(
            fontSize:  Dimensions.fontSizeDefault
           )),
         ),

         Text("Jenis Alamat", style: rubikRegular.copyWith(
          color: Theme.of(context).hintColor
         )),

         const SizedBox(height: Dimensions.paddingSizeLarge),

          SizedBox(height: 30, child: ListView.builder(
           shrinkWrap: true,
           scrollDirection: Axis.horizontal,
           itemCount: locationProvider.getAllAddressType.length,
           itemBuilder: (context, index) => InkWell(
             onTap: ()=> locationProvider.updateAddressIndex(index, true),
             child: Container(
               padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall, horizontal: Dimensions.paddingSizeSmall),
               margin: const EdgeInsets.only(right: Dimensions.paddingSizeDefault),
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
                 border: Border.all(
                   color: locationProvider.selectAddressIndex == index
                       ? ColorResources.primaryColor : ColorResources.borderCardColor
                 ),
                 color: locationProvider.selectAddressIndex == index
                   ? ColorResources.primaryColor : Colors.white.withOpacity(0.8)
               ),
               child: Row(children: [
                CustomAssetImageWidget(
                  locationProvider.getAllAddressType[index].toLowerCase() == 'home' ? Images.houseSvg
                      : locationProvider.getAllAddressType[index].toLowerCase() == 'workplace' ? Images.buildingSvg
                      : Images.otherSvg
                ),

                const SizedBox(width: Dimensions.paddingSizeSmall),

                Text(
                  locationProvider.getAllAddressType[index].toLowerCase() == 'home'
                  ? "Rumah" : locationProvider.getAllAddressType[index].toLowerCase() == 'workplace'
                  ? "Kantor" : "Lainnya",
                  style: rubikRegular.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: locationProvider.selectAddressIndex == index
                        ? Colors.white : Theme.of(context).hintColor
                  ),
                )
               ]),
             ),
           ),
          )),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          if(configModel.googleMapStatus == 1
              && ((locationProvider.pickedAddressLatitude != null
                  && locationProvider.pickedAddressLongitude != null
                  ) || widget.inputModel.addressModel == null))...[
              SizedBox(
                height: 250,
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                   GoogleMap(
                     mapType: MapType.normal,
                     initialCameraPosition: CameraPosition(
                       target: widget.inputModel.isEnableUpdate
                           ? LatLng(double.parse(locationProvider.pickedAddressLatitude!), double.parse(locationProvider.pickedAddressLongitude!))
                           : LatLng(locationProvider.position.latitude == 0.0
                           ? double.parse(widget.inputModel.branches[0]!.latitude!)
                           : locationProvider.position.latitude, locationProvider.position.longitude == 0.0
                           ? double.parse(widget.inputModel.branches[0]!.longitude!)
                           : locationProvider.position.longitude),
                       zoom: 8
                     ),
                     zoomControlsEnabled: false,
                     compassEnabled: false,
                     indoorViewEnabled: true,
                     mapToolbarEnabled: false,
                     minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                     onCameraIdle: (){
                       if(widget.inputModel.addressModel != null && !widget.inputModel.fromCheckout) {
                         locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                         widget.onUpdateAddress(true);
                       } else {
                         if(widget.inputModel.updateAddress) {
                           widget.onUpdateAddress(false);

                           locationProvider.updatePosition(locationProvider.cameraPosition, true, null, context, true);
                         } else {
                           widget.onUpdateAddress(true);
                         }
                       }
                     },
                     onCameraMove: ((position) {
                       locationProvider.cameraPosition = position;
                     }),

                     onMapCreated: (GoogleMapController createdController) {
                       controller = createdController;

                       if(!widget.inputModel.isEnableUpdate) {
                         locationProvider.checkPermission(() {
                           locationProvider.getCurrentLocation(context, true, mapController: controller);
                         });
                       }
                     },
                   ),

                    locationProvider.loading
                    ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor)))
                    : const SizedBox(),

                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height,
                      child: CustomAssetImageWidget(
                        Images.marker,
                        width: 25, height: 25,
                      ),
                    ),

                   Positioned(bottom: 10, right: 0, child: InkWell(
                     onTap: (){},
                     child: Container(
                       width: 30, height: 30,
                       margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                         color: Colors.white
                       ),
                       child: Icon(Icons.my_location, color: ColorResources.primaryColor, size: 20),
                     ),
                   )),

                    Positioned(top: 10, right: 0, child: InkWell(
                      onTap: (){},
                      child: Container(
                        width: 30, height: 30,
                        margin: const EdgeInsets.only(right: Dimensions.paddingSizeLarge),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                          color: Colors.white
                        ),
                        child: Icon(
                          Icons.fullscreen,
                          color: ColorResources.primaryColor,
                          size: 20,
                        ),
                      ),
                    ))
                  ]),
                ),
              ),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            if(configModel.googleMapStatus == 1
                && ((locationProvider.pickedAddressLatitude == null
                    && locationProvider.pickedAddressLongitude == null)
                    && widget.inputModel.addressModel != null))...[

                ClipRRect(
                  borderRadius: BorderRadius.circular(Dimensions.paddingSizeSmall),
                  child: Stack(clipBehavior: Clip.none, children: [
                   CustomAssetImageWidget(
                     Images.noMapBackground,
                     fit: BoxFit.cover,
                     height: 130,
                     width: MediaQuery.of(context).size.width,
                     color: Colors.black.withOpacity(0.5),
                     colorBlendMode: BlendMode.darken,
                   ),

                   Positioned.fill(child: Center(
                     child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeLarge),
                        child: Text(
                          "Tambah lokasimu dari peta agar lebih presisi",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: robotoRegular.copyWith(
                            color: Theme.of(context).cardColor,
                            fontSize: Dimensions.fontSizeSmall
                          ),
                        ),
                      ) ,

                       const SizedBox(height: Dimensions.paddingSizeDefault),

                       Row(children: [
                        Expanded(child: CustomButtonWidget(
                          isLoading: locationProvider.loading,
                          btnTxt: "Pergi ke peta",
                          onTap: (){},
                          backgroundColor: Theme.of(context).cardColor,
                          textStyle: rubikBold.copyWith(
                            color: ColorResources.primaryColor,
                            fontSize: Dimensions.fontSizeSmall
                          ),
                        )),

                        Expanded(child: Container())
                       ])
                     ]),
                   ))
                  ]),
                ),

              const SizedBox(height: Dimensions.paddingSizeLarge)
            ],

            ProfileTextFieldWidget(
              isShowBorder: true,
              controller: widget.inputModel.locationTextController,
              focusNode: widget.inputModel.addressNode,
              inputType: TextInputType.streetAddress,
              capitalization: TextCapitalization.words,
              level: "Alamat Pengiriman",
              hintText: "Ambil alamat pengiriman dari peta di atas atau google maps",
              isFieldRequired: false,
              isShowPrefixIcon: true,
              prefixIconUrl: Images.locationPlaceMarkSvg,
              onValidate: (value) {
                return value!.isEmpty ? 'Masukkan alamat pengiriman' : null;
              },
            ),

            const SizedBox(height: Dimensions.paddingSizeLarge)
          ],

        ]),
      );
    });
  }
}
