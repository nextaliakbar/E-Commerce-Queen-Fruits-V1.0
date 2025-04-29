import 'dart:ui';

import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

enum SnackBarStatus {error, success, alert, info}

void showCustomSnackBarHelper(String? message, {
  bool isError = true, bool isToast = false
}) {
  final Size size = MediaQuery.of(Get.context!).size;

  ScaffoldMessenger.of(Get.context!)..hideCurrentSnackBar()..showSnackBar(SnackBar(
    elevation: 0,
    shape: OutlineInputBorder(
      borderRadius: BorderRadius.circular(50),
      borderSide: const BorderSide(color: Colors.transparent)
    ),
    content: Align(
      alignment: Alignment.center,
      child: Material(
          color: Colors.black,
          elevation: 0,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: isError ? Colors.red : Colors.green,
                  child: Icon(
                    isError ? Icons.close_rounded : Icons.check,
                    color: Colors.white,
                    size: 16,
                  ),
                ),

                const SizedBox(width: Dimensions.paddingSizeDefault),

                Flexible(
                  child: Text(
                    message ?? '',
                    style: rubikBold.copyWith(
                      color: Colors.white,
                      fontSize: Dimensions.fontSizeDefault
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          ),

      ),
    ),
    margin: EdgeInsets.only(
      bottom: size.height * 0.08
    ),
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.transparent
  ));
}