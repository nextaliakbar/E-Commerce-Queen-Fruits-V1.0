import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

class PermissionDialogWidget extends StatelessWidget {
  const PermissionDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall)),
      insetPadding: const EdgeInsets.all(30),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: Padding(
        padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
        child: SizedBox(
          width: 500,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Icon(Icons.add_location_alt_rounded, color: ColorResources.primaryColor, size: 100),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Text('Izinkan akses lokasi dari perangkat anda', textAlign: TextAlign.center, style: rubikSemiBold.copyWith(fontSize: Dimensions.fontSizeLarge)),

            const SizedBox(height: Dimensions.paddingSizeLarge),

            Row(children: [
             Expanded(
                 child: TextButton(
                   style: TextButton.styleFrom(
                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimensions.radiusSmall), side: BorderSide(width: 2, color: ColorResources.primaryColor)),
                     minimumSize: const Size(1, 50)
                   ),
                   onPressed: ()=> Navigator.pop(context),
                   child: Text("Tutup")
                 )
             ),

             const SizedBox(width: Dimensions.paddingSizeSmall),

             Expanded(child: CustomButtonWidget(btnTxt: "Pengaturan", onTap: () async {
                 await Geolocator.openAppSettings();

                 if(context.mounted) {
                   context.pop();
                 }
             }))
            ])
          ]),
        ),
      ),
    );
  }
}