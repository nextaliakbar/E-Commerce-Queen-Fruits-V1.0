import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/repositories/location_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/permission_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:universal_html/js_util.dart';

class LocationProvider with ChangeNotifier {
  final LocationRepo? locationRepo;
  final SharedPreferences? sharedPreferences;

  LocationProvider({required this.locationRepo, required this.sharedPreferences});

  bool _loading = false;
  Position _position = Position(
    latitude: 0, longitude: 0, timestamp: DateTime.now(), accuracy: 1,
    altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1,
    headingAccuracy: 1
  );

  Position _pickPosition = Position(
    latitude: 0, longitude: 0, timestamp: DateTime.now(), accuracy: 1,
    altitude: 1, heading: 1, speed: 1, speedAccuracy: 1, altitudeAccuracy: 1,
    headingAccuracy: 1
  );

  String? _address = '';
  String? _pickAddress = '';
  String? _currentAddress;
  List<AddressModel>? _addressList;
  String? _addressStatusMessage = '';
  List<String> _getAllAddressType = [];
  String? _errorMessage = '';
  bool _isDefault = false;
  String? _pickedAddressLatitude;
  String? _pickedAddressLongitude;
  bool _updateAddAddressData = true;
  bool _changeAddress = true;
  int _selectAddressIndex = 0;
  bool _isLoading = false;
  int _selectedAreaId = -1;


  GoogleMapController? mapController;
  CameraPosition? cameraPosition;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  String? get address => _address;
  String? get pickAddress => _pickAddress;
  String? get currentAddress => _currentAddress;
  List<AddressModel>? get addressList => _addressList;
  String? get addressStatusMessage => _addressStatusMessage;
  List<String> get getAllAddressType => _getAllAddressType;
  String? get errorMessage => _errorMessage;
  bool get isDefault => _isDefault;
  String? get pickedAddressLatitude => _pickedAddressLatitude;
  String? get pickedAddressLongitude => _pickedAddressLongitude;
  bool get updateAddAddressData => _updateAddAddressData;
  bool get changeAddress => _changeAddress;
  int get selectAddressIndex => _selectAddressIndex;
  bool get isLoading => _isLoading;
  int get selectedAreaId => _selectedAreaId;

  Future<LatLng?> getCurrentLatLong() async {
    Position? position;
    try {
      position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    } catch(e) {
      debugPrint('Location Provider');
      debugPrint('error : $e');
    }

    return position != null ? LatLng(position.latitude, position.longitude) : null;
  }

  Future<void> checkPermission(Function callback, {bool canBeIgnoreDialog = false}) async {
    LocationPermission permission = await Geolocator.requestPermission();

    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else if(permission == LocationPermission.deniedForever) {
      showDialog(context: Get.context!, barrierDismissible: false, builder: (context) => const PermissionDialogWidget());
    } else {
      callback();
    }
  }

  Future<String?> getCurrentLocation(BuildContext context, bool isUpdate, {GoogleMapController? mapController}) async {
    _loading = true;

    if(isUpdate) {
      notifyListeners();
    }

    Position myPosition;

    try {
      Position newLocalData = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      myPosition = newLocalData;
    } catch(e) {
      myPosition = Position(
        latitude: double.parse('0'),
        longitude: double.parse('0'),
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1,
        altitudeAccuracy: 1,
        headingAccuracy: 1
      );
    }

    _position = myPosition;

    if(mapController != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(myPosition.latitude, myPosition.longitude), zoom: 17)
      ));
    }

    _address = await getAddressFromGeocode(LatLng(myPosition.latitude, myPosition.longitude));

    _loading = false;
    notifyListeners();
    return _address;
  }

  Future<String> getAddressFromGeocode(LatLng latLng) async {
    ApiResponseModel response = await locationRepo!.getAddressFromGeocode(latLng);
    String address = '';

    if(response.response?.statusCode == 200 && response.response!.data['status'] == 'OK') {
      address = response.response!.data['results'][0]['formatted_address'].toString();
    }

    debugPrint("Address is empty ${address.isEmpty}");
    debugPrint("Address location is $address");
    return address;
  }

  void onChangeCurrentAddress(String? address, {bool isUpdate = false}) {
    _currentAddress = address;

    if(isUpdate) {
      notifyListeners();
    }

    debugPrint("Current address $_currentAddress");
  }

  Future<List<AddressModel>?> initAddressList() async {
    // ResponseModel? responseModel;
    ApiResponseModel apiResponse = await locationRepo!.getAllAddress();
    if(apiResponse.response?.data != null && apiResponse.response?.statusCode == 200) {
      _addressList = [];
      apiResponse.response!.data.forEach((address) => _addressList!.add(AddressModel.fromJson(address)));
      // responseModel = ResponseModel(true, 'successful');
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    notifyListeners();
    return _addressList;
  }

  void updateAddressStatusMessage({String? message}) {
    _addressStatusMessage = message;
  }

  void initializeAllAddressType({BuildContext? context}) {
    if(_getAllAddressType.isEmpty) {
      _getAllAddressType = [];
      _getAllAddressType = locationRepo!.getAllAddressType(context: context);
    }
  }

  void updateErrorMessage({String? message}) {
    _errorMessage = message;
  }

  void onChangeDefaultStatus(bool status, {bool isUpdate= true}) {
    _isDefault = status;

    if(isUpdate) {
      notifyListeners();
    }
  }

  void setPickedAddressLatLon(String? lat, String? lon, {bool isUpdate = true}) {
    _pickedAddressLatitude = lat;
    _pickedAddressLongitude = lon;

    if(isUpdate) {
      notifyListeners();
    }
  }

  Future<void> updatePosition(
      CameraPosition? position, bool fromAddress,
      String? address, BuildContext buildContext,
      bool forceNotify, {bool isUpdate = true}
      ) async {
    debugPrint("----------- Update Position -------------");
    if(_updateAddAddressData || forceNotify) {
      _loading = true;

      if(isUpdate) {
        notifyListeners();
      }

      try {
        if(fromAddress) {
          _position = Position(
            latitude: position!.target.latitude,
            longitude: position.target.longitude,
            timestamp: DateTime.now(),
            heading: 1,
            accuracy: 1,
            altitude: 1,
            speedAccuracy: 1,
            speed: 1,
            altitudeAccuracy: 1,
            headingAccuracy: 1
          );
        } else {
          _pickPosition = Position(
              latitude: position!.target.latitude,
              longitude: position.target.longitude,
              timestamp: DateTime.now(),
              heading: 1,
              accuracy: 1,
              altitude: 1,
              speedAccuracy: 1,
              speed: 1,
              altitudeAccuracy: 1,
              headingAccuracy: 1
          );
        }

        if(_changeAddress) {
          String addressFromGeocode = await getAddressFromGeocode(LatLng(position.target.latitude, position.target.longitude));
          fromAddress ? address = addressFromGeocode : _pickAddress = addressFromGeocode;
        } else {
          _changeAddress = true;
        }
      } catch(e) {
        debugPrint("Error in location provider func update position");
        debugPrint("Error =====> $e");
      }
      _loading = false;
      if(isUpdate || _changeAddress) {
        notifyListeners();
      }
    } else {
      _updateAddAddressData = true;
    }
    debugPrint("Lat Lon IDLE and position picked : ${_position.latitude} and ${_position.longitude}");
    debugPrint("Lat Lon IDLE and picked : ${_pickPosition.latitude} and ${_pickPosition.longitude}");
  }

  void updateAddressIndex(int index, bool notify) {
    _selectAddressIndex = index;
    if(notify) {
      notifyListeners();
    }
  }

  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponseModel apiResponse = await locationRepo!.addAddress(addressModel);
    ResponseModel responseModel;
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      await initAddressList();
      String? message = map["message"];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      _errorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      debugPrint("Errors message for add address $_errorMessage");
      responseModel = ResponseModel(false, _errorMessage);
    }
    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  void setAreaId({int? areaId, bool isUpdate = true, bool isReload = false}) {
    if(isReload) {
      _selectedAreaId = -1;
    } else {
      _selectedAreaId = areaId!;
    }

    if(isUpdate) {
      notifyListeners();
    }
  }

  Future<AddressModel?> getDefaultAddress() async {
    AddressModel? addressModel;

    ApiResponseModel apiResponse = await locationRepo!.getDefaultAddress();
    if(apiResponse.response?.data != null && apiResponse.response?.statusCode == 200) {
      addressModel = AddressModel.fromJson(apiResponse.response?.data);
    } else {
      ApiCheckerHelper.checkApi(apiResponse);
    }

    return addressModel;
  }

  int? getAddressIndex(AddressModel addressModel) {
    int? index;

    if(_addressList != null) {
      for(int i = 0; i < _addressList!.length; i++) {
        if(_addressList![i].id == addressModel.id) {
          index = i;
          break;
        }
      }
    }

    return index;
  }

  Future<ResponseModel> updateAddress(BuildContext context, {required AddressModel addressModel, int? addressId}) async {
    _isLoading = true;
    notifyListeners();
    _errorMessage = '';
    _addressStatusMessage = null;
    ApiResponseModel apiResponse = await locationRepo!.updateAddress(addressModel, addressId);
    ResponseModel responseModel;

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      Map map = apiResponse.response!.data;
      initAddressList();
      String? message = map['message'];
      responseModel = ResponseModel(true, message);
      _addressStatusMessage = message;
    } else {
      _errorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _errorMessage);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> deleteUserAddressById(int? id, int index, Function callback) async {
    _isLoading = true;
    notifyListeners();

    ApiResponseModel apiResponse = await locationRepo!.deleteUserAddressById(id);

    _isLoading = false;
    notifyListeners();

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      _addressList!.removeAt(index);
      callback(true, 'Alamat berhasil dihapus');
    } else {
      callback(false, "Alamat gagal dihapus, silahkan ulangi lagi");
    }
  }
}