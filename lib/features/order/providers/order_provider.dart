import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/order_details_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/place_order_body.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/expenses/domains/enums/order_state_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/expenses/domains/models/expenses_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/order_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/js_util.dart';

class OrderProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;
  final SharedPreferences? sharedPreferences;

  OrderProvider({required this.orderRepo, required this.sharedPreferences});

  bool _isStoreCloseNow = true;
  bool _isLoading = false;
  List<OrderModel>? _runningOrderList;
  List<OrderModel>? _historyOrderList;
  OrderModel? _trackModel;
  ResponseModel? _responseModel;
  bool _showCanceled = false;
  List<OrderDetailsModel>? _orderDetails;

  bool get isStoreCloseNow => _isStoreCloseNow;
  bool get isLoading => _isLoading;
  List<OrderModel>? get runningOrderList => _runningOrderList;
  List<OrderModel>? get historyOrderList => _historyOrderList;
  OrderModel? get trackModel => _trackModel;
  ResponseModel? get responseModel => _responseModel;
  bool get showCanceled => _showCanceled;
  List<OrderDetailsModel>? get orderDetails => _orderDetails;

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  OrderState _state = OrderState.initial;
  ExpensesModel? _expensesModel;

  int get selectedMonth => _selectedMonth;
  int get selectedYear => _selectedYear;
  OrderState get state => _state;
  ExpensesModel? get expensesModel => _expensesModel;
  bool get expensesIsLoading => _state == OrderState.loading;
  bool get expensesHasError => _state == OrderState.error;
  bool get expensesHasData => _state == OrderState.loaded && _expensesModel != null;
  List<double> get chartData => _expensesModel?.chartData ?? [];
  List<String> get periodLabels => _expensesModel?.periodLabels ?? [];
  double get totalAmount => _expensesModel?.totalAmount ?? 0;

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

  Future<ResponseModel?> trackOrder(String? orderId, {String? phoneNumber, bool isUpdate = false, OrderModel? orderModel, bool fromTracking = true}) async {
    _trackModel = null;
    _responseModel = null;

    if(!fromTracking) {
      _orderDetails = null;
    }

    _showCanceled = false;
    if(orderModel == null) {
      _isLoading = true;
      if(isUpdate) {
        notifyListeners();
      }

      ApiResponseModel apiResponse;

      if(phoneNumber != null) {
        apiResponse = await orderRepo!.trackOrderWithPhoneNumber(orderId, phoneNumber);
      } else {
        apiResponse = await orderRepo!.trackOrder(orderId);
      }

      if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        _trackModel = OrderModel.fromJson(apiResponse.response!.data);
        _responseModel = ResponseModel(true, apiResponse.response!.data.toString());
      } else {
        _trackModel = OrderModel(id: -1);
        _responseModel = ResponseModel(false, ApiCheckerHelper.getError(apiResponse).errors![0].message);
        ApiCheckerHelper.checkApi(apiResponse);
      }
    } else {
      _trackModel = orderModel;
      _responseModel = ResponseModel(true, 'Successful');
    }

    _isLoading = false;
    notifyListeners();
    return _responseModel;
  }

  Future<List<OrderDetailsModel>?> getOrderDetails(String orderId, {String? phoneNumber, bool isApiCheck = true}) async {
    _orderDetails = null;
    _isLoading = false;
    _showCanceled = false;

    ApiResponseModel apiResponse;

    if(phoneNumber != null) {
      apiResponse = await orderRepo!.getOrderDetailsWithPhoneNumber(orderId, phoneNumber);
    } else {
      apiResponse = await orderRepo!.getOrderDetails(orderId);
    }

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _orderDetails = [];
      apiResponse.response!.data.forEach((orderDetail) => _orderDetails!.add(OrderDetailsModel.fromJson(orderDetail)));
    } else {
      _orderDetails = [];
    }

    if(!isApiCheck) {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    _isLoading = false;
    notifyListeners();
    return _orderDetails;
  }

  Future<void> updateFilter({required int month, required int year}) async {
    _selectedMonth = month;
    _selectedYear = year;
    notifyListeners();
    await getExpenses();
  }

  Future<void> getExpenses() async {
    BranchProvider branchProvider = Provider.of<BranchProvider>(Get.context!, listen: false);
    int branchId = branchProvider.getBranchId();
    _setState(OrderState.loading);

    ApiResponseModel apiResponse = await orderRepo!.getExpenses(1, _selectedYear, _selectedMonth);
    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map<String, dynamic> data = apiResponse.response!.data;
      _expensesModel = ExpensesModel.fromJson(data);
      _setState(OrderState.loaded);
    } else {
      _expensesModel = null;
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();

  }

  Future<void> retry() async {
    await getExpenses();
  }

  void reset() {
    _state = OrderState.initial;
    _expensesModel = null;
    _selectedMonth = DateTime.now().month;
    _selectedYear = DateTime.now().year;
    notifyListeners();
  }

  void _setState(OrderState orderState) {
    _state = orderState;
    notifyListeners();
  }
}