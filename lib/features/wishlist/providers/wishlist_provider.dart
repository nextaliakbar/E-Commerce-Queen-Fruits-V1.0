import 'package:ecommerce_app_queen_fruits_v1_0/features/wishlist/domain/repositories/wishlist_repo.dart';
import 'package:flutter/cupertino.dart';

class WishlistProvider extends ChangeNotifier {
  final WishlistRepo? wishlistRepo;

  WishlistProvider({required this.wishlistRepo});
}