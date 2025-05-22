import 'dart:collection';

import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_pop_scope_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_close_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_item_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_simmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/branch_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class BranchListScreen extends StatefulWidget {
  const BranchListScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _BranchListScreenState();
}

class _BranchListScreenState extends State<BranchListScreen> {
  Set<Marker> _markers = HashSet<Marker>();
  late GoogleMapController _mapController;
  LatLng? _currentLocationLatLng;
  AutoScrollController? scrollController;


  @override
  void initState() {
    super.initState();

    _onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);
    final CartProvider cartProvider = Provider.of<CartProvider>(context, listen: false);

    final double height = MediaQuery.sizeOf(context).height;

    return Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return CustomPopScopeWidget(
          onPopInvoked: () {
            if(branchProvider.branchTabIndex != 0) {
              branchProvider.updateTabIndex(0);
            }
          },
          child: Scaffold(
            appBar: CustomAppBarWidget(
              context: context,
              title: "Pilih cabang",
              centerTitle: !Navigator.canPop(context),
              isBackButtonExist: branchProvider.branchTabIndex == 1 || context.canPop(),
              onBackPressed: ()=> branchProvider.branchTabIndex == 1 ? branchProvider.updateTabIndex(0) : context.canPop() ? context.pop() : null
            ) as PreferredSizeWidget?,
            body: splashProvider.getActiveBranch() == 0 ? const BranchCloseWidget() : Column(children: [
             Expanded(child: SingleChildScrollView(
               child: Column(children: [
                Container(
                  width: Dimensions.webScreenWidth,
                  constraints: BoxConstraints(minHeight: height),
                  child: Column(children: [

                    if(branchProvider.branchTabIndex == 1) ...[
                      const SizedBox(height: Dimensions.paddingSizeDefault)
                    ],

                    branchProvider.branchTabIndex == 1 ? SizedBox(
                      height: height - 170, child: Stack(children: [
                        GoogleMap(
                          mapType: MapType.normal,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(
                              double.tryParse(branchProvider.branchValueList?[0].branches?.latitude ?? '0') ?? 0,
                              double.tryParse(branchProvider.branchValueList?[0].branches?.longitude ?? '0') ?? 0,
                            ), zoom: 5),
                          minMaxZoomPreference: const MinMaxZoomPreference(0, 16),
                          zoomControlsEnabled: true,
                          markers: _markers,
                          onMapCreated: (GoogleMapController controller) async {
                            await Geolocator.requestPermission();
                            _mapController = controller;
                            _setMarkers(1, branchProvider);
                          }),

                        Positioned.fill(child: Align(alignment: Alignment.bottomCenter, child: SizedBox(
                          height: 170,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: branchProvider.branchValueList?.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) => Padding(
                                padding: EdgeInsets.only(
                                  left: Dimensions.paddingSizeLarge, bottom: Dimensions.paddingSizeLarge,
                                  right: index == (branchProvider.branchValueList?.length ?? 0) - 1 ? Dimensions.paddingSizeLarge : 0
                                ),
                              child: BranchCardWidget(
                                branchModel: branchProvider.branchValueList?[index],
                                branchModelList: branchProvider.branchValueList,
                                onTap: ()=> _setMarkers(index, branchProvider, fromBranchSelect: true),
                              ),
                            ),
                          ),
                        )))
                      ])
                    ) : Container(
                      padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeDefault),
                      child: Column(children: [
                        
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('Cabang terdekat (${branchProvider.branchValueList?.length ?? 0})', style: rubikBold),
                          
                          splashProvider.configModel?.googleMapStatus == 1 ? GestureDetector(
                            onTap: ()=> branchProvider.updateTabIndex(1),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                                border: Border.all(color: ColorResources.primaryColor)
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Row(children: [
                               Container(
                                 height: 25, width: 28,
                                 decoration: BoxDecoration(color: ColorResources.primaryColor),
                                 child: const Icon(Icons.location_on, color: Colors.white, size: Dimensions.paddingSizeDefault),
                               ) ,
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
                                  child: Text("Lihat peta", style: poppinsRegular.copyWith(color: ColorResources.primaryColor)),
                                )
                              ]),
                            ),
                          ) : const SizedBox.shrink()
                        ]),

                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        (branchProvider.branchValueList?.isNotEmpty ?? false) ? GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisSpacing: Dimensions.paddingSizeDefault,
                            mainAxisSpacing: Dimensions.paddingSizeDefault,
                            mainAxisExtent: 190,
                            crossAxisCount: 1
                          ),
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: branchProvider.branchValueList?.length,
                          itemBuilder: (context, index) => BranchItemCardWidget(
                            branchesValue: branchProvider.branchValueList?[index]
                          ),
                        ) : GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: Dimensions.paddingSizeDefault,
                                mainAxisSpacing: 0.01,
                                childAspectRatio: 2,
                                crossAxisCount: 1
                            ),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder: (context, index) => BranchShimmerCardWidget(isEnabled: (branchProvider.branchValueList?.isEmpty ?? true))
                        )
                      ]),
                    ),
                    _BranchSelectButtonWidget(cartProvider: cartProvider)
                  ])
                )
               ]),
             ))
            ]),
          ),
        );
    });
  }

  Future<void> _onInit() async {
    final BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);

    await Geolocator.requestPermission();

    branchProvider.updateTabIndex(0, isUpdate: false);

    if(branchProvider.getBranchId() == -1) {
      branchProvider.updateBranchId(null, isUpdate: false);
    } else {
      branchProvider.updateBranchId(branchProvider.getBranchId(), isUpdate: false);
    }

    if(branchProvider.branchValueList == null && mounted) {
      await branchProvider.getBranchValueList(context);
    }

    scrollController = AutoScrollController(
      viewportBoundaryGetter: ()=> Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal
    );
  }

  void _setMarkers(int selectedIndex, BranchProvider branchProvider, {bool fromBranchSelect = false}) async {
    await scrollController!.scrollToIndex(selectedIndex, preferPosition: AutoScrollPosition.middle);
    await scrollController!.highlight(selectedIndex);

    late BitmapDescriptor bitmapDescriptor;
    late BitmapDescriptor bitmapDescriptorUnSelect;
    late BitmapDescriptor currentLocationDescriptor;

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(35, 60)), Images.storeMarker).then((marker) {
      bitmapDescriptor = marker;
    });

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(35, 60)), Images.storeMarkerUnSelect).then((marker) {
      bitmapDescriptorUnSelect = marker;
    });

    await BitmapDescriptor.fromAssetImage(const ImageConfiguration(size: Size(35, 60)), Images.currentLocationMarker).then((marker) {
      currentLocationDescriptor = marker;
    });

    _markers = HashSet<Marker>();

    for(int index = 0; index < (branchProvider.branchValueList?.length ?? 0); index++) {
      _markers.add(Marker(
        onTap: () async {
            if(branchProvider.branchValueList?[index].branches?.status ?? false) {
              Provider.of<BranchProvider>(context, listen: false)
                  .updateBranchId(branchProvider.branchValueList?[index].branches!.id);
            }
          },
        markerId: MarkerId('branch_$index'),
        position: LatLng(
            double.parse(branchProvider.branchValueList?[index].branches?.latitude ?? '0'),
            double.parse(branchProvider.branchValueList?[index].branches?.longitude ?? '0')
        ),
        infoWindow: InfoWindow(
          title: branchProvider.branchValueList?[index].branches?.name,
          snippet: branchProvider.branchValueList?[index].branches?.address
        ),
        visible: branchProvider.branchValueList?[index].branches?.status ?? false,
        icon: selectedIndex == index ? bitmapDescriptor : bitmapDescriptorUnSelect
      ));
    }

    if(_currentLocationLatLng != null) {
      _markers.add(Marker(
          markerId: const MarkerId('current_location'),
          position: _currentLocationLatLng!,
          infoWindow: InfoWindow(title: 'Lokasi saat ini', snippet: ''),
          icon: currentLocationDescriptor
        ));
    }

    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: _currentLocationLatLng != null && !fromBranchSelect ? _currentLocationLatLng! : LatLng(
            double.parse(branchProvider.branchValueList?[selectedIndex].branches?.latitude ?? '0'),
            double.parse(branchProvider.branchValueList?[selectedIndex].branches?.longitude ?? '0')
          ),
        zoom: 12
        )));

    if(mounted) {
      setState(() {});
    }
  }
}

class _BranchSelectButtonWidget extends StatelessWidget {

  final CartProvider cartProvider;

  const _BranchSelectButtonWidget({required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Dimensions.webScreenWidth,
      padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      child: Consumer<BranchProvider>(builder: (context, branchProvider, _) => CustomButtonWidget(
        btnTxt: branchProvider.selectedBranchId == null ? 'Pilih cabang' : 'Lanjut',
        borderRadius: Dimensions.radiusDefault,
        onTap: branchProvider.selectedBranchId == null ? null : () {
          if(branchProvider.selectedBranchId != branchProvider.getBranchId() && cartProvider.cartList.isNotEmpty) {
              BranchHelper.dialogOrBottomSheet(
                  context,
                  onPressRight: () {
                    BranchHelper.setBranch(context);
                    cartProvider.getCartData(context);
                },
                title: "test 1a"
              );
          } else {
              if(branchProvider.getBranchId() == -1) {
                if(branchProvider.branchTabIndex != 0) {
                  branchProvider.updateTabIndex(0, isUpdate: false);
                }

                BranchHelper.setBranch(context);
                cartProvider.getCartData(context);
              } else if(branchProvider.selectedBranchId == branchProvider.getBranchId()) {
                showCustomSnackBarHelper("Ini adalah cabang kamu saat ini");
              } else {
                BranchHelper.dialogOrBottomSheet(
                    context,
                    onPressRight: () {
                      if(branchProvider.branchTabIndex != 0) {
                        branchProvider.updateTabIndex(0, isUpdate: false);
                      }

                      BranchHelper.setBranch(context);
                      cartProvider.getCartData(context);
                    },
                    title: "Pindah ke cabang ini");
              }
          }
        },
      ))
    );
  }
}