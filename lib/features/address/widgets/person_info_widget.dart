import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/screens/order_search_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/widgets/profile_textfield_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PersonInfoWidget extends StatelessWidget {
  final TextEditingController contactPersonNameController;
  final TextEditingController contactPersonNumberController;
  final FocusNode nameNode;
  final FocusNode numberNode;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? addressModel;

  const PersonInfoWidget({
    super.key,
    required this.contactPersonNameController,
    required this.contactPersonNumberController,
    required this.nameNode,
    required this.numberNode,
    required this.isEnableUpdate,
    required this.fromCheckout,
    required this.addressModel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: ColorResources.cardShadowColor.withOpacity(0.2), blurRadius: 10)]
      ),
      padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Consumer<LocationProvider>(builder: (context, locationProvider, _) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: Dimensions.paddingSizeLarge),

          Text('Informasi Personal', style: rubikSemiBold.copyWith(
           fontSize: Dimensions.fontSizeDefault
          )),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          ProfileTextFieldWidget(
            isShowBorder: true,
            controller: contactPersonNameController,
            focusNode: nameNode,
            nextFocus: numberNode,
            inputType: TextInputType.name,
            capitalization: TextCapitalization.words,
            level: 'Nama',
            hintText: 'Nama',
            isFieldRequired: false,
            isShowSuffixIcon: true,
            prefixIconUrl: Images.profileIconSvg,
            inputAction: TextInputAction.next,
            onValidate: (value) => value!.isEmpty
            ? 'Masukkan informasi nama penerima' : null
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge),

          PhoneNumberFieldView(
              onValueChange: (code){},
              phoneNumberTextController: contactPersonNumberController,
              phoneFocusNode: numberNode
          ),

          const SizedBox(height: Dimensions.paddingSizeLarge,)
        ]);
      }),
    );
  }
}
