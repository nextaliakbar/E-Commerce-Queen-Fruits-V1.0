import 'package:ecommerce_app_queen_fruits_v1_0/common/enums/product_sort_type.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/view_change_to_enum.dart';
import 'package:flutter/foundation.dart';

class ProductSortProvider extends ChangeNotifier {
  ProductSortType _selectedShotType = ProductSortType.defaultType;
  ViewChangeTo _viewChangeTo = ViewChangeTo.gridView;

  ProductSortType get selectedShotType => _selectedShotType;
  ViewChangeTo get viewChangeTo => _viewChangeTo;
}