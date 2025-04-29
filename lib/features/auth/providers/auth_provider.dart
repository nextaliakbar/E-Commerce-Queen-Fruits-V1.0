import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/repositories/auth_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo? authRepo;

  bool _isLoading = false;

  AuthProvider({required this.authRepo});

  bool get isLoading => _isLoading;

  Future<bool> clearSharedData(BuildContext context) async {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();

    bool isSucees = await authRepo!.clearSharedData();
    await authRepo?.dioClient?.updateHeader(getToken: null);

    if(context.mounted) {
      cartProvider.getCartData(context);
    }

    _isLoading = false;
    notifyListeners();
    return isSucees;
  }

  bool isLoggedIn() {
    return authRepo!.isLoggedIn();
  }

  Future<void> updateToken() async {
    if(await authRepo!.getDeviceToken() != '@') {
      debugPrint('------------ (update device token) -------- from update');

      await authRepo!.updateDeviceToken();
    }
  }
}