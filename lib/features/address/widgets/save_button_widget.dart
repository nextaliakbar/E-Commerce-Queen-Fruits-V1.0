import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveButtonWidget extends StatelessWidget {
  final bool isEnableUpdate;
  final bool fromCheckOut;
  final AddressModel? addressModel;
  final Function? onTap;

  const SaveButtonWidget({super.key, this.isEnableUpdate = false,
    this.addressModel, this.fromCheckOut = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(builder: (context, locationProvider, _) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall, horizontal: Dimensions.paddingSizeExtraSmall),
        child: !locationProvider.isLoading ? CustomButtonWidget(
          width: 180, height: 50,
          btnTxt: isEnableUpdate ? "Perbarui Alamat" : "Simpan Alamat",
          onTap: locationProvider.loading ? null : onTap,
        ) : Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor),
          ),
        ),
      );
    });
  }
}
