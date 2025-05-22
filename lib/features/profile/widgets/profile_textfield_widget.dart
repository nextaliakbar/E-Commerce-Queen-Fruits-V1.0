import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_asset_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ProfileTextFieldWidget extends StatefulWidget {
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final Color? fillColor;
  final int maxLines;
  final bool isPassword;
  final bool isCountryPicker;
  final bool isShowBorder;
  final bool isIcon;
  final bool isShowSuffixIcon;
  final bool isShowPrefixIcon;
  final Function? onTap;
  final Function? onChanged;
  final Function? onSuffixTap;
  final String? suffixIconUrl;
  final String? prefixIconUrl;
  final bool isSearch;
  final Function? onSubmit;
  final bool isEnabled;
  final TextCapitalization capitalization;
  final InputDecoration? inputDecoration;
  final String? Function(String? )? onValidate;
  final double? radius;
  final String? level;
  final bool isFieldRequired;
  final bool isToolTipSuffix;
  final String? toolTipMessage;
  final GlobalKey? toolTipKey;

  const ProfileTextFieldWidget({
    super.key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.nextFocus,
    this.isEnabled = true,
    this.inputType = TextInputType.text,
    this.inputAction = TextInputAction.next,
    this.maxLines = 1,
    this.onSuffixTap,
    this.fillColor,
    this.onSubmit,
    this.onChanged,
    this.capitalization = TextCapitalization.none,
    this.isCountryPicker = false,
    this.isShowBorder = false,
    this.isShowSuffixIcon = false,
    this.isShowPrefixIcon = false,
    this.onTap,
    this.isIcon = false,
    this.isPassword = false,
    this.suffixIconUrl,
    this.prefixIconUrl,
    this.isSearch = false,
    this.inputDecoration,
    this.onValidate,
    this.radius,
    this.level,
    this.isFieldRequired = false,
    this.isToolTipSuffix = false,
    this.toolTipMessage,
    this.toolTipKey
  });

  @override
  State<ProfileTextFieldWidget> createState() => _ProfileTextFieldWidgetState();
}

class _ProfileTextFieldWidgetState extends State<ProfileTextFieldWidget> {
  bool _obscureText = true;
  bool isFocusActive = false;

  @override
  void initState() {
    super.initState();

    widget.focusNode?.addListener(() {
      isFocusActive = widget.focusNode!.hasFocus;
      setState(() {});
    });

    widget.toolTipKey != null ? showAndCloseToolTip(widget.toolTipKey) : null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      focusNode: widget.focusNode,
      style: Theme.of(context).textTheme.displayMedium!.copyWith(
        color: Theme.of(context).textTheme.bodyLarge!.color,
        fontSize: Dimensions.fontSizeLarge
      ),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      cursorColor: ColorResources.primaryColor,
      textCapitalization: widget.capitalization,
      enabled: widget.isEnabled,
      autofocus: false,
      obscureText: widget.isPassword ? _obscureText : false,
      inputFormatters: widget.inputType == TextInputType.phone ? <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp('[0-9+]'))
      ] : null,
      decoration: widget.inputDecoration ?? InputDecoration(
        errorStyle: rubikRegular.copyWith(color: Theme.of(context).colorScheme.error, fontSize: Dimensions.fontSizeSmall),
        focusedBorder: getBorder(widget.radius ?? Dimensions.radiusDefault, isFocusActive),
        disabledBorder: getBorder(widget.radius ?? Dimensions.radiusDefault, isFocusActive),
        enabledBorder: getBorder(widget.radius ?? Dimensions.radiusDefault, isFocusActive),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 22),
        border: getBorder(widget.radius ?? Dimensions.radiusDefault, isFocusActive),
        isDense: true,
        hintText:  widget.hintText ?? '',
        fillColor: widget.fillColor ?? Theme.of(context).cardColor,
        hintStyle: Theme.of(context).textTheme.displayMedium!.copyWith(
          fontSize: Dimensions.fontSizeSmall,
          color: Theme.of(context).hintColor.withOpacity(0.7)
        ),
        filled: true,
        prefixIcon: widget.isShowPrefixIcon ? Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeLarge, right: Dimensions.paddingSizeSmall),
          child: CustomAssetImageWidget(
            widget.prefixIconUrl!,
            color: isFocusActive ? ColorResources.primaryColor : Theme.of(context).hintColor,
          ),
        ) : const SizedBox.shrink(),
        prefixIconConstraints: const BoxConstraints(minWidth: 23, maxHeight: 20),
        suffixIcon: widget.isShowSuffixIcon ? widget.isPassword
            ? IconButton(
              icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor.withOpacity(0.3)),
              onPressed: _toggle,
            ) : widget.isIcon
            ? IconButton(
            icon: CustomAssetImageWidget(
              widget.suffixIconUrl!,
              width: 15,
              height: 15,
            ),
            onPressed: widget.onSuffixTap as void Function()?,
            ) : widget.isToolTipSuffix
            ? Tooltip(
              key: widget.toolTipKey,
              preferBelow: false,
              margin: const EdgeInsets.only(top: Dimensions.paddingSizeSmall),
              triggerMode: TooltipTriggerMode.manual,
              message: widget.toolTipMessage,
              child: IconButton(
                icon: CustomAssetImageWidget(
                  widget.suffixIconUrl!,
                  width: 15, height: 15,
                ),
                onPressed: widget.onSuffixTap as void Function()?,
              ),
            ) : null : null,
        label: Row(mainAxisSize: MainAxisSize.min, children: [
         Text(widget.level ?? ''),

         if(widget.isFieldRequired)...[
           const SizedBox(width: Dimensions.paddingSizeExtraSmall),
           Text('*', style: rubikBold.copyWith(color: Theme.of(context).colorScheme.error))
         ]
        ]),
        labelStyle: rubikRegular.copyWith(color: Theme.of(context).textTheme.labelMedium?.color)
      ),
      onTap: widget.onTap as void Function()?,
      onFieldSubmitted: (text) => widget.nextFocus != null
          ? FocusScope.of(context).requestFocus(widget.nextFocus)
         : widget.onSubmit != null ? widget.onSubmit!(text) : null,
      onChanged: widget.onChanged as void Function(String)?,
      validator: widget.onValidate,
    );
  }

  Future<dynamic> showAndCloseToolTip(var key) async {
    await Future.delayed(const Duration(milliseconds: 10));
    final dynamic tooltip = key.currentState;
    tooltip?.ensureToolTipVisible();
    await Future.delayed(const Duration(milliseconds: 10));
    tooltip?.deactivated();
  }

  OutlineInputBorder getBorder(double radius, bool isFocusActive) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(radius),
    borderSide: BorderSide(
      style: widget.isShowBorder ? BorderStyle.solid : BorderStyle.none,
      width: widget.isShowBorder ? 1 : 0,
      color: isFocusActive ? ColorResources.primaryColor.withOpacity(0.4) : Theme.of(context).hintColor.withOpacity(0.5)
    )
  );

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
}
