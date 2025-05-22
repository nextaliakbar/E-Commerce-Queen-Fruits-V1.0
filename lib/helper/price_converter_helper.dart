import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PriceConverterHelper {
  
  static String convertPrice(double? price, {double? discount, String? discountType}) {
    final configModel = Provider.of<SplashProvider>(Get.context!, listen: false).configModel!;
    
    if(discount != null && discountType != null) {
      
      if(discountType == 'amount') {
        price = price! - discount;
      } else if(discountType == 'percent') {
        price = price! - ((discount / 100) * price);
      }
    }
    
    return 'Rp ${price?.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=\d{3})+(?!\d)'), (Match m) => '${m[1]}')}';
  }

  static double? convertWithDiscount(double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price = price! - discount!;
    } else if(discountType == 'percent') {
      price = price! - ((discount! / 100) * price);
    }

    return price;
  }

  static double? convertDiscount(double? price, double? discount, String? discountType) {
    if(discountType == 'amount') {
      price =  discount!;
    } else if(discountType == 'percent') {
      price = (discount! / 100) * price!;
    }

    return price;
  }

  static String getDiscountType({required double? discount, required String? discountType}) {
    return '${discountType == 'percent' ? '${discount?.toInt()}%' : PriceConverterHelper.convertPrice(discount)} OFF';
  }
}