import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/models/signup_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/models/user_log_data.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/repositories/auth_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/cart/providers/cart_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/providers/profile_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepo? authRepo;
  AuthProvider({required this.authRepo});
  bool _isLoading = false;
  bool _isPhoneNumberVerificationButtonLoading = false;
  bool _isNumberLogin = false;
  bool _isActiveRememberMe = false;
  String? _loginErrorMessage = '';
  String? _registrationErrorMessage = '';

  // registration attribute
  bool _isCheckedPhone = false;

  bool get isLoading => _isLoading;
  set setIsLoading(bool value) => _isLoading = value;
  bool get isPhoneNumberVerificationButtonLoading => _isPhoneNumberVerificationButtonLoading;
  set setIsPhoneNumberVerificationButtonLoading(bool value) => _isPhoneNumberVerificationButtonLoading = value;
  bool get isNumberLogin => _isNumberLogin;
  bool get isActiveRememberMe => _isActiveRememberMe;
  String? get loginErrorMessage => _loginErrorMessage;
  String? get registrationErrorMessage => _registrationErrorMessage;
  bool get isCheckedPhone => _isCheckedPhone;

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

  UserLogData? getUserData() {
    UserLogData? userData;

    try {
      userData = UserLogData.fromJson(jsonDecode(authRepo!.getUserLogData()));
    } catch(error) {
      debugPrint("errorr get user data ===> $error");
    }

    return userData;
  }

  void toggleIsNumberLogin({bool? value, bool isUpdate = true}) {
    if(value == null) {
      _isNumberLogin = !_isNumberLogin;
    } else {
      _isNumberLogin = value;
    }

    if(isUpdate) {
      notifyListeners();
    }
  }

  toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    notifyListeners();
  }

  Future<ResponseModel> login(String? userInput, String? password, String? type) async {
    _isLoading = true;
    _loginErrorMessage = '';
    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.login(userInput: userInput, password: password, type: type);

    ResponseModel responseModel;
    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      String? token;
      String? tempToken;
      Map map = apiResponse.response!.data;

      if(map.containsKey('temporary_token')) {
        tempToken = map['temporary_token'];
      } else if(map.containsKey('token')) {
        token = map['token'];
      }

      if(token != null) {
        await _updateAuthToken(token);
        final ProfileProvider profileProvider = Provider.of<ProfileProvider>(Get.context!, listen: false);
        profileProvider.getUserInfo(false, isUpdate: false);
      } else if(tempToken != null) {
        // Incoming
      }

      responseModel = ResponseModel(token != null, 'verification');
    } else {
      _loginErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _loginErrorMessage);
    }

    _isLoading = false;
    notifyListeners();
    return responseModel;
  }

  Future<void> _updateAuthToken(String token) async {
    authRepo!.saveUserToken(token);

    debugPrint("--------(update device token)------- from _updateAuthToken");

    await authRepo!.updateDeviceToken();
  }

  void saveUserNumberAndPassword(UserLogData userLogData) {
    debugPrint("---------User Data--------${jsonEncode(userLogData.toJson())}");
    authRepo!.saveUserNumberAndPassword(jsonEncode(userLogData.toJson()));
  }

  Future<bool> clearUserLogData() async {
    return authRepo!.userClearUserLog();
  }

  Future<ResponseModel> registration(SignUpModel signUpModel, ConfigModel configModel) async {
    _isLoading = true;
    _isCheckedPhone = false;
    _registrationErrorMessage = '';

    ResponseModel responseModel;
    String? token;
    String? tempToken;

    notifyListeners();

    ApiResponseModel apiResponse = await authRepo!.registration(signUpModel);

    if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
      showCustomSnackBarHelper("Akun berhasil dibuat", isError: false);

      Map map = apiResponse.response!.data;

      if(map.containsKey('temporary_token')) {
        tempToken = map['temporary_token'];
      } else if(map.containsKey('token')) {
        token = map['token'];
      }

      if(token != null) {
        await login(signUpModel.phone, signUpModel.password, 'phone');
      } else {
        _isCheckedPhone = true;
        String type;
        // Incoming
      }

      responseModel = ResponseModel(token != null, 'successful');
    } else {
      _registrationErrorMessage = ApiCheckerHelper.getError(apiResponse).errors![0].message;
      responseModel = ResponseModel(false, _registrationErrorMessage);
    }

    _isLoading = false;
    notifyListeners();

    return responseModel;
  }
}