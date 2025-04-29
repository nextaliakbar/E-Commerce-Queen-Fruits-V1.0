import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_alert_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BranchHelper {

  static void setBranch(BuildContext context) {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final splashProvider = Provider.of<SplashProvider>(context, listen: false);

    if(branchProvider.getBranchId() != branchProvider.selectedBranchId) {
      branchProvider.setBranch(branchProvider.selectedBranchId!, splashProvider);

      if(RouterHelper.dashboard == GoRouter.of(Get.context!).routeInformationProvider.value.uri.path) {

      } else {

      }

      showCustomSnackBarHelper("Cabang berhasil dipilih", isError: false);
    } else {
      showCustomSnackBarHelper("Kamu sudah memilih cabang ini sekarang");
    }
  }

  static void dialogOrBottomSheet(BuildContext context, {required Function() onPressRight, required String title}) {
    showModalBottomSheet(
      isDismissible: true,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      context: context,
      builder: (context) => CustomAlertDialogWidget(
        rightButtonText: "Ya",
        leftButtonText: "Tidak",
        icon: Icons.question_mark,
        title: title,
        onPressRight: onPressRight,
        onPressLeft: ()=> context.pop(),
      )
    );
  }
}