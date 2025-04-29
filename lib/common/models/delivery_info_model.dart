class DeliveryInfoModel {
  int? _id;
  String? _name;
  int? _status;
  DeliveryChargeSetup? _deliveryChargeSetup;

  DeliveryInfoModel(
      {int? id,
        String? name,
        int? status,
        DeliveryChargeSetup? deliveryChargeSetup}) {
    if (id != null) {
      _id = id;
    }
    if (name != null) {
      _name = name;
    }
    if (status != null) {
      _status = status;
    }
    if (deliveryChargeSetup != null) {
      _deliveryChargeSetup = deliveryChargeSetup;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  int? get status => _status;
  set status(int? status) => _status = status;
  DeliveryChargeSetup? get deliveryChargeSetup => _deliveryChargeSetup;
  set deliveryChargeSetup(DeliveryChargeSetup? deliveryChargeSetup) =>
      _deliveryChargeSetup = deliveryChargeSetup;

  DeliveryInfoModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _status = json['status'];
    _deliveryChargeSetup = json['delivery_charge_setup'] != null
        ? DeliveryChargeSetup.fromJson(json['delivery_charge_setup'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['status'] = _status;
    if (_deliveryChargeSetup != null) {
      data['delivery_charge_setup'] = _deliveryChargeSetup!.toJson();
    }
    return data;
  }
}

class DeliveryChargeSetup {
  int? _id;
  int? _branchId;
  String? _deliveryChargeType;
  double? _deliveryChargePerKilometer;
  double? _minimumDeliveryCharge;
  double? _minimumDistanceForFreeDelivery;
  String? _createdAt;
  String? _updatedAt;

  DeliveryChargeSetup(
      {int? id,
        int? branchId,
        String? deliveryChargeType,
        double? deliveryChargePerKilometer,
        double? minimumDeliveryCharge,
        double? minimumDistanceForFreeDelivery,
        String? createdAt,
        String? updatedAt,
        double? fixedDeliveryCharge,
      }) {
    if (id != null) {
      _id = id;
    }
    if (branchId != null) {
      _branchId = branchId;
    }
    if (deliveryChargeType != null) {
      _deliveryChargeType = deliveryChargeType;
    }
    if (deliveryChargePerKilometer != null) {
      _deliveryChargePerKilometer = deliveryChargePerKilometer;
    }
    if (minimumDeliveryCharge != null) {
      _minimumDeliveryCharge = minimumDeliveryCharge;
    }
    if (minimumDistanceForFreeDelivery != null) {
      _minimumDistanceForFreeDelivery = minimumDistanceForFreeDelivery;
    }
    if (createdAt != null) {
      _createdAt = createdAt;
    }
    if (updatedAt != null) {
      _updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  int? get branchId => _branchId;
  set branchId(int? branchId) => _branchId = branchId;
  String? get deliveryChargeType => _deliveryChargeType;
  set deliveryChargeType(String? deliveryChargeType) =>
      _deliveryChargeType = deliveryChargeType;
  double? get deliveryChargePerKilometer => _deliveryChargePerKilometer;
  set deliveryChargePerKilometer(double? deliveryChargePerKilometer) =>
      _deliveryChargePerKilometer = deliveryChargePerKilometer;
  double? get minimumDeliveryCharge => _minimumDeliveryCharge;
  set minimumDeliveryCharge(double? minimumDeliveryCharge) =>
      _minimumDeliveryCharge = minimumDeliveryCharge;
  double? get minimumDistanceForFreeDelivery => _minimumDistanceForFreeDelivery;
  set minimumDistanceForFreeDelivery(double? minimumDistanceForFreeDelivery) =>
      _minimumDistanceForFreeDelivery = minimumDistanceForFreeDelivery;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;


  DeliveryChargeSetup.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _branchId = json['branch_id'];
    _deliveryChargeType = json['delivery_charge_type'];
    _deliveryChargePerKilometer = double.tryParse('${json['delivery_charge_per_kilometer']}');
    _minimumDeliveryCharge = double.tryParse('${json['minimum_delivery_charge']}');
    _minimumDistanceForFreeDelivery = double.tryParse('${json['minimum_distance_for_free_delivery']}');
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['branch_id'] = _branchId;
    data['delivery_charge_type'] = _deliveryChargeType;
    data['delivery_charge_per_kilometer'] = _deliveryChargePerKilometer;
    data['minimum_delivery_charge'] = _minimumDeliveryCharge;
    data['minimum_distance_for_free_delivery'] =
        _minimumDistanceForFreeDelivery;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}