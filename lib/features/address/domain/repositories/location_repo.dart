import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  LocationRepo({required this.dioClient, required this.sharedPreferences});
}