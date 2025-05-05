import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/product_sort_type.dart';
import 'package:flutter/foundation.dart';

class ProductSortProvider extends ChangeNotifier {
  ProductSortType _selectedShotType = ProductSortType.defaultType;

  ProductSortType get selectedShotType => _selectedShotType;
}