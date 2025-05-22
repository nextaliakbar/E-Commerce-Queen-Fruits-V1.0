import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/place_order_body.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;

  OrderProvider({required this.orderRepo, required this.sharedPreferences});

  bool _isStoreCloseNow = true;
  bool _isLoading = false;
  List<OrderModel>? _runningOrderList;
  List<OrderModel>? _historyOrderList;

  bool get isStoreCloseNow => _isStoreCloseNow;
  bool get isLoading => _isLoading;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;

  void changeStatus(bool status, {bool notify = false}) {
    _isStoreCloseNow = status;

    if(notify) {
      notifyListeners();
    }
  }

  void stopLoader() {
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setPlaceOrder(String placeOrder) async {
    await sharedPreferences!.setString(AppConstants.placeOrderData, placeOrder);
  }

  Future<void> clearPlaceOrder() async {
    await sharedPreferences!.remove(AppConstants.placeOrderData);
  }

  Future<void> placeOrder(
    PlaceOrderBody placeOrderBody,
    Function callback,
    {bool isUpdate = true}
  ) async {
    _isLoading = true;
    if(isUpdate) {
      notifyListeners();
    }

    ApiResponseModel apiResponse = await orderRepo!.placeOrder(placeOrderBody);

    _isLoading = false;
    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String? message = apiResponse.response!.data['message'];
      String orderId = apiResponse.response!.data['order_id'].toString();
      callback(true, message, orderId, placeOrderBody.deliveryAddressId);
    } else {
      callback(false, ApiCheckerHelper.getError(apiResponse).errors![0].message, '-1', 1);
    }

    notifyListeners();
  }

  Future<void> getOrderList(BuildContext context) async {
    ApiResponseModel apiResponse = await orderRepo!.getOrderList();
    if(apiResponse.response!.data != null && apiResponse.response!.statusCode == 200) {
      _runningOrderList = [];
      _historyOrderList = [];
      apiResponse.response!.data['orders'].forEach((order) {
        OrderModel orderModel = OrderModel.fromJson(order);
        if(orderModel.orderStatus == 'pending' || orderModel.orderStatus == 'processing'
        || orderModel.orderStatus == 'out_for_delivery' || orderModel.orderStatus == 'confirmed') {
          _runningOrderList!.add(orderModel);
        } else if(orderModel.orderStatus == 'delivered' || orderModel.orderStatus == 'returned'
        || orderModel.orderStatus == 'failed' || orderModel.orderStatus == 'canceled') {
          _historyOrderList!.add(orderModel);
        }
      });
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    debugPrint("Running order list length ${_runningOrderList?.length}");
    notifyListeners();
  }
}