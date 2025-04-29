import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:flutter/foundation.dart';

class FrequentlyBoughtProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  FrequentlyBoughtProvider({required this.productRepo});
}