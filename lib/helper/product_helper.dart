import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:flutter/cupertino.dart';

class ProductHelper {
  static bool isProductAvailable({required Product product}) {
    return product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!)
        : false;
  }

  static void addToCart({required int cartIndex, required Product product}) {

  }

  static ({List<Variation>? variations, double? price}) getBranchProductVariationWithPrice(Product? product) {
    List<Variation>? variationList;

    double? price;

    if(product?.branchProduct != null && (product?.branchProduct?.isAvailable ?? false)) {
      variationList = product?.branchProduct?.variations;
      price = product?.branchProduct?.price;
    } else {
      variationList = product?.variations;
      price = product?.price;
    }
    return (variations: variationList, price: price);
  }
}