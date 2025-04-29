import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/repositories/location_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider with ChangeNotifier {
  final LocationRepo? locationRepo;
  final SharedPreferences? sharedPreferences;

  LocationProvider({required this.locationRepo, required this.sharedPreferences});

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
}