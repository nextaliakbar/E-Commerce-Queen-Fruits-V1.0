import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;

  OrderProvider({required this.orderRepo, required this.sharedPreferences});

  bool _isStoreCloseNow = true;

  bool get isStoreCloseNow => _isStoreCloseNow;

  void changeStatus(bool status, {bool notify = false}) {
    _isStoreCloseNow = status;

    if(notify) {
      notifyListeners();
    }
  }
}