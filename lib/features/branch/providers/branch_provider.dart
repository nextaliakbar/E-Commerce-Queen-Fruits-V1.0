import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/data_sync_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/domain/repositories/splash_repo.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class BranchProvider extends DataSyncProvider {
  final SplashRepo? splashRepo;

  BranchProvider({required this.splashRepo});

  int _branchTabIndex = 0;
  int? _selectedBranchId;
  List<BranchValue>? _branchValueList;
  bool _isLoading = false;

  int get branchTabIndex => _branchTabIndex;
  int? get selectedBranchId => _selectedBranchId;
  List<BranchValue>? get branchValueList => _branchValueList;
  bool get isLoading => _isLoading;

  int getBranchId() => splashRepo?.getBranchId() ?? -1;

  void updateTabIndex(int index, {bool isUpdate = true}) {
    _branchTabIndex = index;
    if(isUpdate) {
      notifyListeners();
    }
  }

  void updateBranchId(int? value, {bool isUpdate = true}) {
    _selectedBranchId = value;
    if(isUpdate) {
      notifyListeners();
    }
  }

  Branches? getBranch({int? id}) {
    int branchId = id ?? getBranchId();
    Branches? branch;
    ConfigModel config = Provider.of<SplashProvider>(Get.context!, listen: false)
    .configModel!;

    if(config.branches != null && config.branches!.isNotEmpty) {
      branch = config.branches!.firstWhere((branch) => branch!.id == branchId, orElse: ()=> null);

      if(branch == null) {
        splashRepo!.setBranchId(-1);
      }
    }

    return branch;
  }

  Future<void> setBranch(int id, SplashProvider splashProvider) async {
    await splashRepo!.setBranchId(id);
    await splashProvider.getDeliveryInfo(id);
    await HomeScreen.loadData(true);
    notifyListeners();
  }

  List<BranchValue> branchSort(LatLng? currentLatLng) {
    _isLoading = true;
    List<BranchValue> branchValueList = [];
    List<Branches?> branches = Provider.of<SplashProvider>(Get.context!, listen: false).configModel!.branches!;
    for(var branch in branches) {
      double distance = -1;
      if(currentLatLng != null) {
        distance = Geolocator.distanceBetween(
            double.parse(branch!.latitude!),
            double.parse(branch.longitude!),
            currentLatLng.latitude,
            currentLatLng.longitude) / 1000;
      }

      branchValueList.add(BranchValue(branch, distance));
    }

    branchValueList.sort((a, b) => a.distance.compareTo(b.distance));

    _isLoading = false;

    notifyListeners();

    return branchValueList;
  }

  Future<List<BranchValue>> getBranchValueList(BuildContext context) async {
    final LocationProvider locationProvider = Provider.of<LocationProvider>(context, listen: false);
    LatLng? currentLocationLatLng;

    await locationProvider.getCurrentLatLong().then((latLong) {
      if(latLong != null) {
        currentLocationLatLng = latLong;
      }

      _branchValueList = branchSort(currentLocationLatLng);
    });

    notifyListeners();
    return _branchValueList ?? [];
  }
}