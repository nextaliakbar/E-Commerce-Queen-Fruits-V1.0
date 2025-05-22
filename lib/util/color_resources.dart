import 'dart:ui';

import 'package:flutter/cupertino.dart';

class ColorResources {
  static const Color primaryColor = Color.fromRGBO(65, 181, 74, 1.0);
  // static const Color primaryColor = Color.fromRGBO(65, 181, 74, 1.0);
  static const Color splashBackgroundColor = Color.fromRGBO(65, 181, 74, 1.0);
  static const Color tertiaryColor = Color(0xFFF3F8FF);
  static const Color homePageSectionTitleColor = Color(0xff583A3A);
  static const Color secondaryColor = Color(0xFFFFBA08);
  static const Color hintColor = Color(0xFF52575C);
  static const Color greyBunkerColor = Color(0xFF25282B);
  static const Color cardShadowColor = Color(0xFFA7A7A7);
  static const Color borderCardColor = Color(0xFFDCDCDC);

  static const Map<String, Color> buttonBackgroundColorMap ={
    'pending': Color(0xffe9f3ff),
    'confirmed': Color(0xffe5f2ee),
    'processing': Color(0xffe5f3fe),
    'out_for_delivery': Color(0xfffff5da),
    'delivered': Color(0xffe5f2ee),
    'canceled' : Color(0xffffeeee),
    'returned' : Color(0xffffeeee),
    'failed' : Color(0xffffeeee),
    'completed': Color(0xffe5f2ee),
  };


  static const Map<String, Color> buttonTextColorMap ={
    'pending': Color(0xff5686c6),
    'confirmed': Color(0xff72b89f),
    'processing': Color(0xff2b9ff4),
    'out_for_delivery': Color(0xffebb936),
    'delivered': Color(0xff72b89f),
    'canceled' : Color(0xffff6060),
    'returned' : Color(0xffff6060),
    'failed' : Color(0xffff6060),
    'completed': Color(0xff72b89f),
  };
}