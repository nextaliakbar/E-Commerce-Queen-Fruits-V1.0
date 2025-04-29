import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/repositories/product_repo.dart';

class ProductProvider extends DataSyncProvider {
  final ProductRepo? productRepo;

  ProductProvider({required this.productRepo});
}