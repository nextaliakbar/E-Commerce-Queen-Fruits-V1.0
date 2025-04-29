import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';
import 'package:flutter/foundation.dart';

class ReviewProvider extends ChangeNotifier {
  final ProductRepo? productRepo;

  ReviewProvider({required this.productRepo});
}