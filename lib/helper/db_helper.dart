import 'package:ecommerce_app_queen_fruits_v1_0/data/datasource/local/cache_response.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';

class DBHelper {
  static insertOrUpdate({required String id, required CacheResponseCompanion data}) async {
    final response = await database.getCacheResponseById(id);

    if(response?.endPoint != null) {
      await database.updateCacheResponse(id, data);
    } else {
      await database.insertCacheResponse(data);
    }
  }
}