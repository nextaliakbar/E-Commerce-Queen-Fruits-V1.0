import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';

class ProductHelper {
  static bool isProductAvailbale({required Product product}) {
    return product.availableTimeStarts != null && product.availableTimeEnds != null
        ? DateConverterHelper.isAvailable(product.availableTimeStarts!, product.availableTimeEnds!)
        : false;
  }
}