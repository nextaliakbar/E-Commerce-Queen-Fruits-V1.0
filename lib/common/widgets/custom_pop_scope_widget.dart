import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_alert_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/responsive_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPopScopeWidget extends StatefulWidget {
  final Widget child;
  final Function()? onPopInvoked;
  final bool isExit;

  const CustomPopScopeWidget({super.key, required this.child, required this.onPopInvoked, this.isExit = true});

  @override
  State<StatefulWidget> createState()=> _CustomPopScoreWidgetState();
}

class _CustomPopScoreWidgetState extends State<CustomPopScopeWidget> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if(widget.onPopInvoked != null) {
          widget.onPopInvoked!();
        }

        if(didPop) {
          return;
        }

        if(!Navigator.canPop(context) && widget.isExit) {
          ResponsiveHelper.showDialogOrBottomShet(
              context, CustomAlertDialogWidget(
            title: "Tutup aplikasi",
            subtitle: "Kamu ingin menutup dan keluar dari aplikasi?",
            rightButtonText: "Keluar",
            image: Images.logOut,
            onPressRight: ()=> SystemNavigator.pop(),
          ));
        } else {
          if(Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        }
      },
      child: widget.child,
    );
  }
}