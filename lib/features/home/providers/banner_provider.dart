import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/domain/repositories/banner_repo.dart';

class BannerProvider extends DataSyncProvider {
  final BannerRepo? bannerRepo;

  BannerProvider({required this.bannerRepo});
}