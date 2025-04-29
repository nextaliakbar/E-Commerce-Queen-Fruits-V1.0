import 'package:ecommerce_app_queen_fruits_v1_0/features/onboarding/models/onboarding_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/onboarding/repositories/onboarding_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/app_constant.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnBoardingProvider with ChangeNotifier {
  final OnBoardingRepo? onBoardingRepo;
  final SharedPreferences? sharedPreferences;

  OnBoardingProvider({required this.onBoardingRepo, required this.sharedPreferences}) {
    _loadShowOnBoardingStatus();
  }

  final List<OnBoardingModel> _onBoardingList = [];
  bool _showOnBoardingStatus = false;
  bool get showOnBoardingStatus => _showOnBoardingStatus;
  List<OnBoardingModel> get onBoardingList => _onBoardingList;

  void _loadShowOnBoardingStatus() {
    _showOnBoardingStatus = sharedPreferences!.getBool(AppConstants.onBoardingSkip) ?? true;
  }
}