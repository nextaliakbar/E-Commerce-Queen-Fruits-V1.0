class ConfigModel {
  String? _storeName;
  String? _storeLogo;
  String? _storeAddress;
  String? _storePhone;
  String? _storeEmail;
  BaseUrls? _baseUrls;
  String? _termsAndConditions;
  String? _privacyPolicy;
  String? _aboutUs;
  bool? _selfPickup;
  bool? _homeDelivery;
  StoreLocationCoverage? _storeLocationCoverage;
  double? _minimumOrderValue;
  List<Branches?>? _branches;
  PlayStoreConfig? _playStoreConfig;
  AppStoreConfig? _appStoreConfig;
  List<StoreScheduleTime>? _storeScheduleTime;
  int? _scheduleOrderSlotDuration;
  Whatsapp? _whatsapp;
  CookiesManagement? _cookiesManagement;
  List<PaymentMethod>? _activePaymentMethodList;
  bool? _isOfflinePayment;
  AppleLogin? _appleLogin;
  CustomerLogin? _customerLogin;
  int? _googleMapStatus;

  ConfigModel({
    String? storeName,
    String? storeLogo,
    String? storeAddress,
    String? storePhone,
    String? storeEmail,
    BaseUrls? baseUrls,
    String? termsAndConditions,
    String? privacyPolicy,
    String? aboutUs,
    bool? selfPickup,
    bool? homeDelivery,
    StoreLocationCoverage? storeLocationCoverage,
    double? minimumOrderValue,
    List<Branches>? branches,
    PlayStoreConfig? playStoreConfig,
    AppStoreConfig? appStoreConfig,
    List<StoreScheduleTime>? storeScheduleTime,
    int? scheduleOrderSlotDuration,
    Whatsapp? whatsapp,
    CookiesManagement? cookiesManagement,
    List<PaymentMethod>? activePaymentMethodList,
    bool? isOfflinePayment,
    AppleLogin? appleLogin,
    CustomerLogin? customerLogin,
    int? googleMapStatus
  }) {
    _storeName = storeName;
    _storeLogo = storeLogo;
    _storeAddress = storeAddress;
    _storePhone = storePhone;
    _storeEmail = storeEmail;
    _baseUrls = baseUrls;
    _termsAndConditions = termsAndConditions;
    _aboutUs = aboutUs;
    _privacyPolicy = privacyPolicy;
    _storeLocationCoverage = storeLocationCoverage;
    _minimumOrderValue = minimumOrderValue;
    _branches = branches;
    _selfPickup = selfPickup;
    _homeDelivery = homeDelivery;

    if (playStoreConfig != null) {
      _playStoreConfig = playStoreConfig;
    }
    if (appStoreConfig != null) {
      _appStoreConfig = appStoreConfig;
    }

    if(customerLogin != null){
      _customerLogin = customerLogin;
    }

    _storeScheduleTime = storeScheduleTime;
    _scheduleOrderSlotDuration = scheduleOrderSlotDuration;
    _activePaymentMethodList = activePaymentMethodList;
    _whatsapp = whatsapp;
    _cookiesManagement = cookiesManagement;
    _isOfflinePayment = isOfflinePayment;
    _appleLogin = appleLogin;
    _googleMapStatus = googleMapStatus;
  }

  int? get googleMapStatus => _googleMapStatus;

  CustomerLogin? get customerLogin => _customerLogin;

  AppleLogin? get appleLogin => _appleLogin;

  bool? get isOfflinePayment => _isOfflinePayment;

  List<PaymentMethod>? get activePaymentMethodList => _activePaymentMethodList;

  CookiesManagement? get cookiesManagement => _cookiesManagement;

  Whatsapp? get whatsapp => _whatsapp;

  int? get scheduleOrderSlotDuration => _scheduleOrderSlotDuration;

  List<StoreScheduleTime>? get storeScheduleTime => _storeScheduleTime;

  AppStoreConfig? get appStoreConfig => _appStoreConfig;

  PlayStoreConfig? get playStoreConfig => _playStoreConfig;

  List<Branches?>? get branches => _branches;

  double? get minimumOrderValue => _minimumOrderValue;

  StoreLocationCoverage? get storeLocationCoverage => _storeLocationCoverage;

  bool? get homeDelivery => _homeDelivery;

  bool? get selfPickup => _selfPickup;

  String? get aboutUs => _aboutUs;

  String? get privacyPolicy => _privacyPolicy;

  String? get termsAndConditions => _termsAndConditions;

  BaseUrls? get baseUrls => _baseUrls;

  String? get storeEmail => _storeEmail;

  String? get storePhone => _storePhone;

  String? get storeAddress => _storeAddress;

  String? get storeLogo => _storeLogo;

  String? get storeName => _storeName;

  ConfigModel.fromJson(Map<String, dynamic> json) {
    _storeName = json['store_name'];
    _storeLogo = json['store_logo'];
    _storeAddress = json['store_address'];
    _storePhone = json['store_phone'];
    _storeEmail = json['store_email'];
    _baseUrls = json['base_urls'] != null
        ? BaseUrls.fromJson(json['base_urls'])
        : null;
    _termsAndConditions = json['terms_and_conditions'];
    _privacyPolicy = json['privacy_policy'];
    _aboutUs = json['about_us'];
    _selfPickup = json['self_pickup'];
    _homeDelivery = json['delivery'];
    _storeLocationCoverage = json['restaurant_location_coverage'] != null
        ? StoreLocationCoverage.fromJson(json['restaurant_location_coverage']) : null;
    _minimumOrderValue = json['minimum_order_value'] != null ? json['minimum_order_value'].toDouble() : 0;
    if (json['branches'] != null) {
      _branches = [];
      json['branches'].forEach((v) {
        _branches!.add(Branches.fromJson(v));
      });
    }
    _playStoreConfig = json['play_store_config'] != null
        ? PlayStoreConfig.fromJson(json['play_store_config'])
        : null;
    _customerLogin = json['customer_login'] != null
        ? CustomerLogin.fromJson(json['customer_login'])
        : null;
    _appStoreConfig = json['app_store_config'] != null
        ? AppStoreConfig.fromJson(json['app_store_config'])
        : null;

    _storeScheduleTime = List<StoreScheduleTime>.from(json["restaurant_schedule_time"].map((x) => StoreScheduleTime.fromJson(x)));

    try {
      _scheduleOrderSlotDuration = json['schedule_order_slot_duration'] ?? 30;
    }catch(_){
      _scheduleOrderSlotDuration = int.tryParse(json['schedule_order_slot_duration'] ?? 30 as String);
    }

    _whatsapp = json['whatsapp'] != null
        ? Whatsapp.fromJson(json['whatsapp'])
        : null;
    _cookiesManagement = json['cookies_management'] != null
        ? CookiesManagement.fromJson(json['cookies_management'])
        : null;

    if (json['active_payment_method_list'] != null) {
      _activePaymentMethodList = <PaymentMethod>[];
      json['active_payment_method_list'].forEach((v) {
        activePaymentMethodList!.add(PaymentMethod.fromJson(v));
      });
    }

    _isOfflinePayment = json['offline_payment'] == 'true';
    _appleLogin = AppleLogin.fromJson(json['apple_login']);
    _googleMapStatus = json['google_map_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_name'] = _storeName;
    data['store_logo'] = _storeLogo;
    data['store_address'] = _storeAddress;
    data['store_phone'] = _storePhone;
    data['restaurant_email'] = _storeEmail;
    if (_baseUrls != null) {
      data['base_urls'] = _baseUrls!.toJson();
    }
    data['terms_and_conditions'] = _termsAndConditions;
    data['privacy_policy'] = privacyPolicy;
    data['about_us'] = aboutUs;
    data['self_pickup'] = selfPickup;
    data['delivery'] = homeDelivery;
    if (_storeLocationCoverage != null) {
      data['restaurant_location_coverage'] = _storeLocationCoverage!.toJson();
    }
    data['minimum_order_value'] = _minimumOrderValue;
    if (_branches != null) {
      data['branches'] = _branches!.map((v) => v!.toJson()).toList();
    }
    if (_playStoreConfig != null) {
      data['play_store_config'] = _playStoreConfig!.toJson();
    }
    if (_appStoreConfig != null) {
      data['app_store_config'] = _appStoreConfig!.toJson();
    }
    if (_whatsapp != null) {
      data['whatsapp'] = _whatsapp!.toJson();
    }
    if (customerLogin != null) {
      data['customer_login'] = customerLogin!.toJson();
    }
    data['google_map_status'] = _googleMapStatus;

    return data;
  }
}

class BaseUrls {
  String? _productImageUrl;
  String? _customerImageUrl;
  String? _bannerImageUrl;
  String? _categoryImageUrl;
  String? _categoryBannerImageUrl;
  String? _reviewImageUrl;
  String? _notificationImageUrl;
  String? _storeImageUrl;
  String? _deliveryManImageUrl;
  String? _branchImageUrl;

  BaseUrls(
      {String? productImageUrl,
        String? customerImageUrl,
        String? bannerImageUrl,
        String? categoryImageUrl,
        String? categoryBannerImageUrl,
        String? reviewImageUrl,
        String? notificationImageUrl,
        String? storeImageUrl,
        String? deliveryManImageUrl,
        String? chatImageUrl,
        String? branchImageUrl,
        String? getWayImageUrl,
      }) {
    _productImageUrl = productImageUrl;
    _customerImageUrl = customerImageUrl;
    _bannerImageUrl = bannerImageUrl;
    _categoryImageUrl = categoryImageUrl;
    _categoryBannerImageUrl = categoryBannerImageUrl;
    _reviewImageUrl = reviewImageUrl;
    _notificationImageUrl = notificationImageUrl;
    _storeImageUrl = storeImageUrl;
    _deliveryManImageUrl = deliveryManImageUrl;
    _branchImageUrl = branchImageUrl;
  }

  String? get branchImageUrl => _branchImageUrl;

  String? get deliveryManImageUrl => _deliveryManImageUrl;

  String? get storeImageUrl => _storeImageUrl;

  String? get notificationImageUrl => _notificationImageUrl;

  String? get reviewImageUrl => _reviewImageUrl;

  String? get categoryBannerImageUrl => _categoryBannerImageUrl;

  String? get categoryImageUrl => _categoryImageUrl;

  String? get bannerImageUrl => _bannerImageUrl;

  String? get customerImageUrl => _customerImageUrl;

  String? get productImageUrl => _productImageUrl;

  BaseUrls.fromJson(Map<String, dynamic> json) {
    _productImageUrl = json['product_image_url'] ?? '';
    _customerImageUrl = json['customer_image_url'] ?? '';
    _bannerImageUrl = json['banner_image_url'] ?? '';
    _categoryImageUrl = json['category_image_url'] ?? '';
    _categoryBannerImageUrl = json['category_banner_image_url'];
    _reviewImageUrl = json['review_image_url'] ?? '';
    _notificationImageUrl = json['notification_image_url'];
    _storeImageUrl = json['restaurant_image_url'] ?? '';
    _deliveryManImageUrl = json['delivery_man_image_url'] ?? '';
    _branchImageUrl = json['branch_image_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_image_url'] = _productImageUrl;
    data['customer_image_url'] = _customerImageUrl;
    data['banner_image_url'] = _bannerImageUrl;
    data['category_image_url'] = _categoryImageUrl;
    data['review_image_url'] = _reviewImageUrl;
    data['notification_image_url'] = _notificationImageUrl;
    data['restaurant_image_url'] = _storeImageUrl;
    data['delivery_man_image_url'] = _deliveryManImageUrl;
    data['branch_image_url'] = _branchImageUrl;
    return data;
  }
}

class StoreLocationCoverage {
  String? _longitude;
  String? _latitude;
  double? _coverage;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  double? get coverage => _coverage;

  StoreLocationCoverage({
    String? longitude,
    String? latitude,
    double? coverage
  }) {
    _longitude = longitude;
    _latitude = latitude;
    _coverage = coverage;
  }

  StoreLocationCoverage.fromJson(Map<String, dynamic> json) {
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _coverage = json['coverage'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['coverage'] = _coverage;
    return data;
  }
}

class Branches {
  int? _id;
  String? _name;
  String? _email;
  String? _longitude;
  String? _latitude;
  String? _address;
  double? _coverage;
  String? _coverImage;
  String? _image;
  bool? _status;
  int? _preparationTime;

  Branches(
      {int? id,
        String? name,
        String? email,
        String? longitude,
        String? latitude,
        String? address,
        double? coverage,
        String? coverImage,
        String? image,
        bool? status,
        int? preparationTime,
      }) {
    _id = id;
    _name = name;
    _email = email;
    _longitude = longitude;
    _latitude = latitude;
    _address = address;
    _coverage = coverage;
    _coverImage = coverImage;
    _image = image;
    _preparationTime = preparationTime;
  }

  int? get id => _id;
  String? get name => _name;
  String? get email => _email;
  String? get longitude => _longitude;
  String? get latitude => _latitude;
  String? get address => _address;
  double? get coverage => _coverage;
  String? get coverImage => _coverImage;
  String? get image => _image;
  bool? get status => _status;
  int? get preparationTime => _preparationTime;

  Branches.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _address = json['address'];
    _coverage = json['coverage'].toDouble();
    _image = json['image'];
    _status = '${json['status']}'.contains('1');
    _coverImage = json['cover_image'];
    _preparationTime = json['preparation_time'];

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['email'] = _email;
    data['longitude'] = _longitude;
    data['latitude'] = _latitude;
    data['address'] = _address;
    data['coverage'] = _coverage;
    data['image'] = _image;
    data['status'] = _status;
    data['preparation_time'] = _preparationTime;
    return data;
  }
}

class BranchValue {
  final Branches? branches;
  final double distance;

  BranchValue(this.branches, this.distance);
}

class PlayStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  PlayStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }
  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;

  PlayStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] != null && json['min_version'] != '' ){
      _minVersion = double.parse(json['min_version']);
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class AppStoreConfig{
  bool? _status;
  String? _link;
  double? _minVersion;

  AppStoreConfig({bool? status, String? link, double? minVersion}){
    _status = status;
    _link = link;
    _minVersion = minVersion;
  }

  bool? get status => _status;
  String? get link => _link;
  double? get minVersion =>_minVersion;


  AppStoreConfig.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    if(json['link'] != null){
      _link = json['link'];
    }
    if(json['min_version'] !=null  && json['min_version'] != ''){
      _minVersion = double.parse(json['min_version']);
    }

  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = _status;
    data['link'] = _link;
    data['min_version'] = _minVersion;

    return data;
  }
}

class StoreScheduleTime {
  StoreScheduleTime({
    this.day,
    this.openingTime,
    this.closingTime,
  });

  String? day;
  String? openingTime;
  String? closingTime;

  factory StoreScheduleTime.fromJson(Map<String, dynamic> json) => StoreScheduleTime(
    day: json["day"].toString(),
    openingTime: json["opening_time"].toString(),
    closingTime: json["closing_time"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "day": day,
    "opening_time": openingTime,
    "closing_time": closingTime,
  };
}

class Whatsapp {
  bool? status;
  String? number;

  Whatsapp({this.status, this.number});

  Whatsapp.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    number = json['number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['number'] = number;
    return data;
  }
}

class AppleLogin {
  bool? status;
  String? medium;
  String? clientId;

  AppleLogin({this.status, this.medium});

  AppleLogin.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}' == '1';
    medium = json['login_medium'];
    clientId = json['client_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['login_medium'] = medium;
    data['client_id'] = clientId;

    return data;
  }
}

class CookiesManagement {
  bool? status;
  String? content;

  CookiesManagement({this.status, this.content});

  CookiesManagement.fromJson(Map<String, dynamic> json) {
    status = '${json['status']}'.contains('1');
    content = json['text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['text'] = content;
    return data;
  }
}

class PaymentMethod {
  String? getWay;
  String? getWayTitle;
  String? getWayImage;
  String? type;

  PaymentMethod({this.getWay, this.getWayTitle, this.getWayImage, this.type});

  PaymentMethod copyWith(String type){
    this.type = type;
    return this;
  }

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    getWay = json['gateway'];
    getWayTitle = json['gateway_title'];
    getWayImage = json['gateway_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['gateway'] = getWay;
    data['gateway_title'] = getWayTitle;
    data['gateway_image'] = getWayImage;
    return data;
  }
}

class CustomerLogin {
  LoginOption? loginOption;

  CustomerLogin({this.loginOption});

  CustomerLogin.fromJson(Map<String, dynamic> json) {
    loginOption = json['login_option'] != null
        ? LoginOption.fromJson(json['login_option'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (loginOption != null) {
      data['login_option'] = loginOption!.toJson();
    }
    return data;
  }
}

class LoginOption {
  int? manualLogin;
  int? otpLogin;
  int? socialMediaLogin;

  LoginOption({this.manualLogin, this.otpLogin, this.socialMediaLogin});

  LoginOption.fromJson(Map<String, dynamic> json) {
    manualLogin = json['manual_login'];
    otpLogin = json['otp_login'];
    socialMediaLogin = json['social_media_login'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['manual_login'] = manualLogin;
    data['otp_login'] = otpLogin;
    data['social_media_login'] = socialMediaLogin;
    return data;
  }
}