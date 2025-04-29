import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/remote/dio/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepo {
  final DioClient? dioClient;
  final SharedPreferences? sharedPreferences;

  OrderRepo({required this.dioClient, required this.sharedPreferences});
}