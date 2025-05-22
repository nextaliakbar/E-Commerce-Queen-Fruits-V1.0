import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:flutter/material.dart';

class InputModel {
  final TextEditingController locationTextController;
  final FocusNode addressNode;
  final FocusNode nameNode;
  final List<Branches?> branches;
  final bool updateAddress;
  final bool isEnableUpdate;
  final bool fromCheckout;
  final AddressModel? addressModel;

  InputModel({
    required this.locationTextController,
    required this.addressNode,
    required this.nameNode,
    required this.branches,
    required this.updateAddress,
    required this.isEnableUpdate,
    required this.fromCheckout,
    this.addressModel,
  });
}