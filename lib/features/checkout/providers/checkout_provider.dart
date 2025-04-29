import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:flutter/foundation.dart';

class CheckoutProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;

  CheckoutProvider({required this.orderRepo});
}