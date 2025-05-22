import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_alert_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/delete_confirmation_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressCardWidget extends StatelessWidget {
  final AddressModel addressModel;
  final int index;

  const AddressCardWidget({super.key, required this.addressModel, required this.index});

  @override
  Widget build(BuildContext context) {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);

    return InkWell(
      hoverColor: Colors.transparent,
      onTap: (){},
      child: Container(
        decoration: BoxDecoration(
          color: ColorResources.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Stack(children: [
          Positioned(top: 0, bottom: 0, right: 20, child: Icon(
           Icons.delete,
           color: ColorResources.primaryColor,
           size: Dimensions.paddingSizeLarge,
          )),

          Dismissible(
            key: UniqueKey(),
            confirmDismiss: (value) async {
              ResponsiveHelper.showDialogOrBottomSheet(context, CustomAlertDialogWidget(
                rightButtonText: "Ya",
                leftButtonText: "Tidak",
                icon: Icons.contact_support,
                title: "Ingin menghapus alamat ini",
                onPressRight: (){},
                onPressLeft: (){}
              ));

              return null;
            },

            child: Container(
              padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeSmall),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                boxShadow: [BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.5),
                  blurRadius: Dimensions.radiusDefault
                )]
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
               Icon(
                 addressModel.addressType!.toLowerCase() == "home"
                     ? Icons.home_filled
                     : addressModel.addressType == "workplace"
                     ? Icons.work_outline
                     : Icons.list_alt_outlined,
                 color: ColorResources.primaryColor.withOpacity(0.8),
                 size: Dimensions.paddingSizeLarge,
               ),

                const SizedBox(width: Dimensions.paddingSizeDefault),

                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Text(
                     addressModel.addressType!.toLowerCase() == 'home'
                     ? 'Rumah' : addressModel.addressType!.toLowerCase() == 'workplace'
                     ? 'Kantor' : 'Lainnya', style: rubikSemiBold
                 ),

                 const SizedBox(height: Dimensions.paddingSizeDefault),

                 Text(
                   addressModel.address!,
                   maxLines: 1, overflow: TextOverflow.ellipsis,
                   style: rubikRegular.copyWith(color: Theme.of(context).hintColor, fontSize: Dimensions.fontSizeSmall),
                 )
                ])),

                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                PopupMenuButton<String>(
                  icon: Icon(Icons.edit, size: Dimensions.fontSizeLarge, color: Theme.of(context).indicatorColor),
                  padding: EdgeInsets.zero,
                  onSelected: (String result) {
                    if(result == 'delete') {
                      showDialog(context: context, barrierDismissible: false,builder: (context) =>
                          DeleteConfirmationDialogWidget(addressModel: addressModel, index: index));
                    } else {
                      locationProvider.updateAddressStatusMessage(message: '');
                      RouterHelper.getAddAddressRoute('address', 'update', addressModel);
                    }
                  },
                  itemBuilder: (BuildContext ctx) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'edit',
                      child: Text("Ubah", style: Theme.of(context).textTheme.displayMedium),
                    ),

                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Text("Hapus", style: Theme.of(context).textTheme.displayMedium),
                    )
                  ],
                )
              ]),
            ),
          )
        ]),
      ),
    );
  }
}