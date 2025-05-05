import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/repositories/location_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/permission_dialog_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _address = '';
  String? _currentAddress;

  bool get loading => _loading;
  Position get position => _position;
  String? get address => _address;
  String? get currentAddress => _currentAddress;

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

    return address;
  }

  void onChangeCurrentAddress(String? address, {bool isUpdate = false}) {
    _currentAddress = address;

    if(isUpdate) {
      notifyListeners();
    }
  }
}