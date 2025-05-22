import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';

class PhoneNumberFieldView extends StatelessWidget {
  final Function(String value) onValueChange;
  final TextEditingController phoneNumberTextController;
  final FocusNode phoneFocusNode;

  const PhoneNumberFieldView({
    super.key,
    required this.onValueChange,
    required this.phoneNumberTextController,
    required this.phoneFocusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: Dimensions.paddingSizeSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorResources.primaryColor.withOpacity(0.2))
      ),
      child: Row(children: [
       Expanded(child: CustomTextFieldWidget(
         controller: phoneNumberTextController,
         focusNode: phoneFocusNode,
         inputType: TextInputType.phone,
         hintText: '08123456789',
       ))
      ]),
    );
  }
}
