import 'package:ecommerce_app_queen_fruits_v1_0/common/models/api_response_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/domain/models/user_info_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/profile/domain/repositories/profile_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/api_checker_helper.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepo? profileRepo;

  ProfileProvider({required this.profileRepo});

  UserInfoModel? _userInfoModel;

  UserInfoModel? get userInfoModel => _userInfoModel;
  set setUserInfoModel(UserInfoModel? user) => _userInfoModel = user;

  Future<void> getUserInfo(bool reload, {bool isUpdate = false}) async {
    if(reload) {
      _userInfoModel = null;
    }

    if(_userInfoModel == null) {
      ApiResponseModel apiResponse = await profileRepo!.getUserInfo();
      if(apiResponse.response != null && apiResponse.response!.statusCode == 200) {
       _userInfoModel = UserInfoModel.fromJson(apiResponse.response!.data);
      } else {
        ApiCheckerHelper.checkApi(apiResponse);
      }
    }
  }
}