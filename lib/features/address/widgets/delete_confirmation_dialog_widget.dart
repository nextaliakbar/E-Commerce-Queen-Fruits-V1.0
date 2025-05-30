import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class DeleteConfirmationDialogWidget extends StatelessWidget {
  final AddressModel addressModel;
  final int index;

  const DeleteConfirmationDialogWidget({super.key, required this.addressModel, required this.index});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        width: 300, child: Column(mainAxisSize: MainAxisSize.min, children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 30,
              backgroundColor: ColorResources.primaryColor,
              child: const Icon(Icons.contact_support, color: Colors.white)
            ),

            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
              child: FittedBox(
                child: Text(
                  'Ingin menghapus alamat ini',
                  style: rubikRegular,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                )
              ),
            ),

          Divider(height: 0, color: ColorResources.hintColor),

          Row(children: [
            Expanded(child: InkWell(
              onTap: (){
                showDialog(context: context, barrierDismissible: false, builder: (context) => Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor)
                  ),
                ));

                Provider.of<LocationProvider>(context, listen: false).deleteUserAddressById(addressModel.id, index, (bool isSuccess, String message){
                  context.pop();
                  showCustomSnackBarHelper(message, isError: !isSuccess);
                  context.pop();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: const BoxDecoration(borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10))),
                child: Text("Ya", style: rubikBold.copyWith(color: ColorResources.primaryColor)),
              ),
            )),

            Expanded(child: InkWell(
              onTap: () => context.pop(),
              child: Container(
                padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorResources.primaryColor,
                    borderRadius: const BorderRadius.only(bottomRight: Radius.circular(10))
                ),
                child: Text("Tidak", style: rubikBold.copyWith(color: Colors.white)),
              ),
            ))
          ]),
        ])
      ),
    );
  }
}
