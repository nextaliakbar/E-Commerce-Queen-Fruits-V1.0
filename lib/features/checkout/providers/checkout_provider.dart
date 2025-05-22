import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/distance_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/offline_payment_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/delivery_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/domains/models/check_out_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/models/timeslote_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/domain/repositories/order_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/date_converter_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class CheckoutProvider extends ChangeNotifier {
  final OrderRepo? orderRepo;

  CheckoutProvider({required this.orderRepo});

  double _deliveryCharge = 0;
  OfflinePaymentModel? _selectedOfflineMethod;
  int _addressIndex = -1;
  int _branchIndex = 0;
  List<Map<String, String>>? _selectedOfflineValue;
  bool _isOfflineSelected = false;
  double _distance = -1;
  List<TimeSlotModel>? _timeSlots;
  List<TimeSlotModel>? _allTimeSlots;
  int _selectDateSlot = 0;
  OrderType _orderType = OrderType.delivery;
  CheckOutModel? _checkOutData;
  int _selectTimeSlot = 0;
  int? _paymentMethodIndex;
  PaymentMethod? _paymentMethod;
  PaymentMethod? _selectedPaymentMethod;

  bool paymentVisibility = true;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  Map<String, TextEditingController> field = {};

  double get deliveryCharge => _deliveryCharge;
  OfflinePaymentModel? get selectedOfflineMethod => _selectedOfflineMethod;
  int get addressIndex => _addressIndex;
  int get branchIndex => _branchIndex;
  List<Map<String, String>>? get selectedOfflineValue => _selectedOfflineValue;
  bool get  isOfflineSelected => _isOfflineSelected;
  double get distance => _distance;
  List<TimeSlotModel>? get timeSlots => _timeSlots;
  List<TimeSlotModel>? get allTimeSlots => _allTimeSlots;
  int get selectDateSlot => _selectDateSlot;
  OrderType  get orderType => _orderType;
  CheckOutModel? get checkOutData => _checkOutData;
  set setCheckOutData(CheckOutModel checkOutModel) => _checkOutData = checkOutModel;
  int get selectTimeSlot => _selectTimeSlot;
  int? get paymentMethodIndex => _paymentMethodIndex;
  PaymentMethod? get paymentMethod => _paymentMethod;
  PaymentMethod? get selectedPaymentMethod => _selectedPaymentMethod;

  void setDeliveryCharge({double? deliveryCharge, bool isUpdate = true, bool isReload = false}) {
    if(isReload) {
      _deliveryCharge = 0;
    } else {
      _deliveryCharge = deliveryCharge ?? 0.0;
    }

    debugPrint("======== Set Delivery ===========");
    debugPrint("Delivery charge : $deliveryCharge");
    if(isUpdate) {
      notifyListeners();
    }
  }

  void clearOfflinePayment() {
    _selectedOfflineMethod = null;
    _selectedOfflineValue = null;
    _isOfflineSelected = false;
  }

  void clearPrevData({bool isUpdate = false}) {
    _addressIndex = -1;
    _branchIndex = 0;
    _selectedOfflineMethod = null;
    _selectedOfflineValue = null;
    clearOfflinePayment();
    _distance = -1;

    if(isUpdate) {
      notifyListeners();
    }
  }

  Future<void> initializeTimeSlot(BuildContext context) async {
    final scheduleTime = Provider.of<SplashProvider>(context, listen: false).configModel!.storeScheduleTime!;
    int? duration = Provider.of<SplashProvider>(context, listen: false).configModel!.scheduleOrderSlotDuration!;
    _timeSlots = [];
    _allTimeSlots = [];
    _selectDateSlot = 0;
    int minutes = 0;
    DateTime now = DateTime.now();
    for(int index = 0; index < scheduleTime.length; index++) {
      DateTime openTime = DateTime(now.year, now.month, now.day,
      DateConverterHelper.convertStringTimeToDate(scheduleTime[index].openingTime!).hour,
      DateConverterHelper.convertStringTimeToDate(scheduleTime[index].openingTime!).minute
      );

      DateTime closeTime = DateTime(now.year, now.month, now.day,
      DateConverterHelper.convertStringTimeToDate(scheduleTime[index].closingTime!).hour,
      DateConverterHelper.convertStringTimeToDate(scheduleTime[index].closingTime!).minute
      );
      
      if(closeTime.difference(openTime).isNegative) {
        minutes = openTime.difference(closeTime).inMinutes;
      } else {
        minutes = closeTime.difference(openTime).inMinutes;
      }
      
      if(duration > 0 && minutes > duration) {
        DateTime time = openTime;
        
        for(;;) {
          if(time.isBefore(closeTime)) {
            DateTime start = time;
            DateTime end = start.add(Duration(minutes: duration));
            
            if(end.isAfter(closeTime)) {
              end = closeTime;
            }
            
            _timeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), 
                startTime: start, endTime: end));
            _allTimeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!), 
                startTime: start, endTime: end));
            time = time.add(Duration(minutes: duration));
          } else {
            break;
          }
        }
      } else {
        _timeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime, endTime: closeTime));
        _allTimeSlots!.add(TimeSlotModel(day: int.tryParse(scheduleTime[index].day!),
            startTime: openTime, endTime: closeTime));
      }
    }

    validateSlot(_allTimeSlots!, 0, notify: false);
  }

  void validateSlot(List<TimeSlotModel> slots, int dateIndex, {bool notify = true}) {
    _timeSlots = [];
    int day = 0;
    if(dateIndex == 0) {
      day = DateTime.now().weekday;
    } else {
      day = DateTime.now().add(const Duration(days: 1)).weekday;
    }

    if(day == 7) {
      day = 0;
    }

    for(var slot in slots) {
      if(day == slot.day && (dateIndex == 0 ? slot.endTime!.isAfter(DateTime.now()) : true)) {
        _timeSlots!.add(slot);
      }
    }

    if(notify) {
      notifyListeners();
    }
  }

  void sortTime() {
    _timeSlots!.sort((a, b) {
      return a.startTime!.compareTo(b.startTime!);
    });

    _allTimeSlots!.sort((a, b) => a.startTime!.compareTo(b.startTime!));
  }

  void setAddressIndex(int index, {bool isUpdate = true}) {
    _addressIndex = index;

    if(isUpdate) {
      notifyListeners();
    }
  }

  Future<bool> getDistanceInMeter(LatLng originLatLng, LatLng destinationLatLng) async {
    _distance = -1;
    bool isSuccess = false;
    ApiResponseModel response = await orderRepo!.getDistanceInMeter(originLatLng, destinationLatLng);
    try {
      if(response.response!.data['status'] == 'OK' && response.response.data!.statusCode == 200) {
        isSuccess = true;
        _distance = DistanceModel.fromJson(response.response!.data).rows![0].elements![0].distance!.value! / 1000;
      } else {
        _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
      }
    } catch(e) {
      _distance = getDistanceBetween(originLatLng, destinationLatLng) / 1000;
    }
    notifyListeners();
    return isSuccess;
  }

  double getDistanceBetween(LatLng startLatLng, LatLng endLatLng) {
    debugPrint("====== Distance Between =========");
    debugPrint("Start Latitude : ${startLatLng.latitude} & Longitude : ${startLatLng.longitude}");
    debugPrint("End Latitude : ${endLatLng.latitude} & Longitude : ${endLatLng.longitude}");
    return Geolocator.distanceBetween(startLatLng.latitude, startLatLng.longitude, endLatLng.latitude, endLatLng.longitude);
  }

  void updateDateSlot(int index) {
    _selectDateSlot = index;
    if(_allTimeSlots != null) {
      validateSlot(_allTimeSlots!, index);
    }
    notifyListeners();
  }

  void updateTimeSlot(int index) {
    _selectTimeSlot = index;
    notifyListeners();
  }

  void setPaymentIndex(int? index, {bool isUpdate = true}) {
    _paymentMethodIndex = index;
    _paymentMethod = null;
    if(isUpdate) {
      notifyListeners();
    }
  }

  void changePaymentMethod({PaymentMethod? digitalMethod, bool isUpdate = true, OfflinePaymentModel? offlinePaymentModel, bool isClear = false}) {
    if(offlinePaymentModel != null) {
      _selectedOfflineMethod = offlinePaymentModel;
    } else if(digitalMethod != null) {
      _paymentMethod = digitalMethod;
      _paymentMethodIndex = null;
      _selectedPaymentMethod = null;
      _selectedOfflineValue = null;
    }

    if(isClear) {
      _paymentMethod = null;
      _selectedOfflineMethod = null;
      clearOfflinePayment();
    }

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setOfflineSelectedValue(List<Map<String, String>>? data, {bool isUpdate = true}) {
    _selectedOfflineValue = data;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setOfflineSelect(bool value) {
    _isOfflineSelected = value;
    notifyListeners();
  }

  void updatePaymentVisibility(bool value) {

  }
}