import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:flutter/cupertino.dart';

class OrderModel {
  int? _id;
  int? _userId;
  double? _orderAmount;
  double? _couponDiscountAmount;
  String? _couponDiscountTitle;
  String? _paymentStatus;
  String? _orderStatus;
  double? _totalTaxAmount;
  String? _paymentMethod;
  String? _transactionReference;
  int? _deliveryAddressId;
  String? _createdAt;
  String? _updatedAt;
  int? _deliveryManId;
  double? _deliveryCharge;
  List<Details>? _details;
  String? _orderNote;
  DeliveryMan? _deliveryMan;
  int? _detailsCount;
  String? _orderType;
  String? _deliveryTime;
  String? _deliveryDate;
  double? _extraDiscount;
  DeliveryAddress? _deliveryAddress;
  String? _preparationTime;
  bool? _isProductAvailable;
  List<String>? _productImageList;
  Branches? _branches;
  double? _durationTime;
  OfflinePaymentInformation? _offlinePaymentInformation;
  PredictionDurationTimeOrder? _predictionDurationTimeOrder;

  OrderModel({
    int? id,
    int? userId,
    double? orderAmount,
    double? couponDiscountAmount,
    String? couponDiscountTitle,
    String? paymentStatus,
    String? orderStatus,
    double? totalTaxAmount,
    String? paymentMethod,
    String? transactionReference,
    int? deliveryAddressId,
    String? createdAt,
    String? updatedAt,
    int? deliveryManId,
    double? deliveryCharge,
    String? orderNote,
    List<Details>? details,
    DeliveryMan? deliveryMan,
    int? detailsCount,
    String? deliveryTime,
    String? deliveryDate,
    String? orderType,
    double? extraDiscount,
    DeliveryAddress? deliveryAddress,
    String? preparationTime,
    bool? isProductAvailable,
    List<String>? productImageList,
    Branches? branches,
    double? durationTime,
    OfflinePaymentInformation? offlinePaymentInformation,
    PredictionDurationTimeOrder? predictionDurationTimeOrder
  }) {
    _id = id;
    _userId = userId;
    _orderAmount = orderAmount;
    _couponDiscountAmount = couponDiscountAmount;
    _couponDiscountTitle = couponDiscountTitle;
    _paymentStatus = paymentStatus;
    _orderStatus = orderStatus;
    _totalTaxAmount = totalTaxAmount;
    _paymentMethod = paymentMethod;
    _transactionReference = transactionReference;
    _deliveryAddressId = deliveryAddressId;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deliveryManId = deliveryManId;
    _deliveryCharge = deliveryCharge;
    _orderNote = orderNote;
    _details = details;
    _deliveryMan = deliveryMan;
    _detailsCount = detailsCount;
    _orderType = orderType;
    _deliveryTime = deliveryTime;
    _deliveryDate = deliveryDate;
    _extraDiscount = extraDiscount;
    _deliveryAddress = deliveryAddress;
    _preparationTime = preparationTime;
    _isProductAvailable = isProductAvailable;
    _productImageList = productImageList;
    _branches = branches;
    _durationTime = durationTime;
    _offlinePaymentInformation = offlinePaymentInformation;
    _predictionDurationTimeOrder = predictionDurationTimeOrder;
  }

  int? get id => _id;
  int? get userId => _userId;
  double? get orderAmount => _orderAmount;
  double? get couponDiscountAmount => _couponDiscountAmount;
  String? get couponDiscountTitle => _couponDiscountTitle;
  String? get paymentStatus => _paymentStatus;
  String? get orderStatus => _orderStatus;
  double? get totalTaxAmount => _totalTaxAmount;
  String? get paymentMethod => _paymentMethod;
  set paymentMethod(String? method) => _paymentMethod = method;
  String? get transactionReference => _transactionReference;
  int? get deliveryAddressId => _deliveryAddressId;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get deliveryManId => _deliveryManId;
  double? get deliveryCharge => _deliveryCharge;
  String? get orderNote => _orderNote;
  DeliveryMan? get deliveryMan => _deliveryMan;
  int? get detailsCount => _detailsCount;
  String? get orderType => _orderType;
  String? get deliveryTime => _deliveryTime;
  String? get deliveryDate => _deliveryDate;
  double? get extraDiscount => _extraDiscount;
  DeliveryAddress? get deliveryAddress => _deliveryAddress;
  String? get preparationTime => _preparationTime;
  bool? get isProductAvailable => _isProductAvailable;
  List<String>? get productImageList => _productImageList;
  Branches? get branches => _branches;
  double? get durationTime => _durationTime;
  OfflinePaymentInformation? get offlinePaymentInformation => _offlinePaymentInformation;
  PredictionDurationTimeOrder? get predictionDurationTimeOrder => _predictionDurationTimeOrder;


  OrderModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderAmount = json['order_amount'].toDouble();
    _couponDiscountAmount = json['coupon_discount_amount'] != null
        ? double.tryParse(json['coupon_discount_amount'].toString()) : json['coupon_discount_amount'];
    _couponDiscountTitle = json['coupon_discount_title'];
    _paymentStatus = json['payment_status'];
    _orderStatus = json['order_status'] == 'cooking' ||
        json['order_status'] == 'done'? 'processing' : json['order_status'];
    _totalTaxAmount = json['total_tax_amount'].toDouble();
    _paymentMethod = json['payment_method'];
    _transactionReference = json['transaction_reference'];
    _deliveryAddressId = json['delivery_address_id'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deliveryManId = json['delivery_man_id'];
    _deliveryCharge = double.tryParse(json['delivery_charge'].toString());
    _orderNote = json['order_note'];
    _detailsCount = json['details_count'];
    if (json['details'] != null) {
      _details = [];
      json['details'].forEach((v) {
        _details!.add(Details.fromJson(v));
      });
    }
    _deliveryMan = json['delivery_man'] != null
        ? DeliveryMan.fromJson(json['delivery_man'])
        : null;
    _orderType = json['order_type'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    if(json['extra_discount'] != null){
      try{
        _extraDiscount = double.parse(json['extra_discount']);
      }catch(e){
        _extraDiscount = json['extra_discount'];
      }
    }
    _deliveryAddress = json['delivery_address'] != null
        ? DeliveryAddress.fromJson(json['delivery_address'])
        : null;
    _preparationTime = json['preparation_time'].toString();
    _isProductAvailable = int.tryParse('${json['is_product_available']}') == 1 ? true : false;
    _productImageList = json.containsKey('product_images') ? json['product_images'].cast<String>() : null;

    if(json['branch'] != null) {
      _branches = Branches.fromJson(json['branch']);
    }
    _durationTime = json['duration_time'];
    _offlinePaymentInformation = json["offline_payment_information"] == null
        ? null : OfflinePaymentInformation.fromMap(json["offline_payment_information"]);

    _predictionDurationTimeOrder = json['prediction_duration_time_order'] != null
        ? PredictionDurationTimeOrder.fromJson(json['prediction_duration_time_order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['user_id'] = _userId;
    data['order_amount'] = _orderAmount;
    data['coupon_discount_amount'] = _couponDiscountAmount;
    data['coupon_discount_title'] = _couponDiscountTitle;
    data['payment_status'] = _paymentStatus;
    data['order_status'] = _orderStatus;
    data['total_tax_amount'] = _totalTaxAmount;
    data['payment_method'] = _paymentMethod;
    data['transaction_reference'] = _transactionReference;
    data['delivery_address_id'] = _deliveryAddressId;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['delivery_man_id'] = _deliveryManId;
    data['delivery_charge'] = _deliveryCharge;
    data['order_note'] = _orderNote;
    data['details_count'] = _detailsCount;
    if (_details != null) {
      data['details'] = _details!.map((v) => v.toJson()).toList();
    }
    if (_deliveryMan != null) {
      data['delivery_man'] = _deliveryMan!.toJson();
    }
    data['order_type'] = _orderType;
    data['delivery_time'] = _deliveryTime;
    data['delivery_date'] = _deliveryDate;
    data['extra_discount'] = _extraDiscount;
    if (_deliveryAddress != null) {
      data['delivery_address'] = _deliveryAddress!.toJson();
    }

    return data;
  }
}

class DeliveryAddress {
  int? _id;
  String? _addressType;
  String? _contactPersonNumber;
  String? _address;
  String? _latitude;
  String? _longitude;
  String? _createdAt;
  String? _updatedAt;
  int? _userId;
  String? _contactPersonName;

  DeliveryAddress({
    int? id,
    String? addressType,
    String? contactPersonNumber,
    String? address,
    String? latitude,
    String? longitude,
    String? createdAt,
    String? updatedAt,
    int? userId,
    String? contactPersonName
  }) {
    _id = id;
    _addressType = addressType;
    _contactPersonNumber = contactPersonNumber;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _userId = userId;
    _contactPersonName = contactPersonName;
  }

  int? get id => _id;
  String? get addressType => _addressType;
  String? get contactPersonNumber => _contactPersonNumber;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  int? get userId => _userId;
  String? get contactPersonName => _contactPersonName;

  DeliveryAddress.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type'];
    _contactPersonNumber = json['contact_person_number'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _userId = json['user_id'];
    _contactPersonName = json['contact_person_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['address_type'] = _addressType;
    data['contact_person_number'] = _contactPersonNumber;
    data['address'] = _address;
    data['latitude'] = _latitude;
    data['longitude'] = _longitude;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['user_id'] = _userId;
    data['contact_person_name'] = _contactPersonName;
    return data;
  }
}

class Details {
  int? _id;
  int? _productId;
  int? _orderId;
  double? _price;
  double? _discountOnProduct;
  String? _discountType;
  int? _quantity;
  double? _taxAmount;
  String? _createdAt;
  String? _updatedAt;

  Details({
    int? id,
    int? productId,
    int? orderId,
    double? price,
    String? productDetails,
    double? discountOnProduct,
    String? discountType,
    int? quantity,
    double? taxAmount,
    String? createdAt,
    String? updatedAt,
    String? variant
  }) {
    _id = id;
    _productId = productId;
    _orderId = orderId;
    _price = price;
    _discountOnProduct = discountOnProduct;
    _discountType = discountType;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  int? get id => _id;
  int? get productId => _productId;
  int? get orderId => _orderId;
  double? get price => _price;
  double? get discountOnProduct => _discountOnProduct;
  String? get discountType => _discountType;
  int? get quantity => _quantity;
  double? get taxAmount => _taxAmount;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Details.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _productId = json['product_id'];
    _orderId = json['order_id'];
    _price = json['price'].toDouble();
    _discountOnProduct = json['discount_on_product'].toDouble();
    _discountType = json['discount_type'];
    _quantity = json['quantity'];
    _taxAmount = json['tax_amount'].toDouble();
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['product_id'] = _productId;
    data['order_id'] = _orderId;
    data['price'] = _price;
    data['discount_on_product'] = _discountOnProduct;
    data['discount_type'] = _discountType;
    data['quantity'] = _quantity;
    data['tax_amount'] = _taxAmount;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    return data;
  }
}

class DeliveryMan {
  int? _id;
  String? _fName;
  String? _lName;
  String? _phone;
  String? _email;
  String? _identityNumber;
  String? _identityType;
  String? _identityImage;
  String? _image;
  String? _password;
  String? _createdAt;
  String? _updatedAt;
  String? _authToken;
  String? _fcmToken;
  List<Rating>? _rating;

  DeliveryMan(
      {int? id,
        String? fName,
        String? lName,
        String? phone,
        String? email,
        String? identityNumber,
        String? identityType,
        String? identityImage,
        String? image,
        String? password,
        String? createdAt,
        String? updatedAt,
        String? authToken,
        String? fcmToken,
        List<Rating>? rating}) {
    _id = id;
    _fName = fName;
    _lName = lName;
    _phone = phone;
    _email = email;
    _identityNumber = identityNumber;
    _identityType = identityType;
    _identityImage = identityImage;
    _image = image;
    _password = password;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _authToken = authToken;
    _fcmToken = fcmToken;
    _rating = rating;
  }

  int? get id => _id;
  String? get fName => _fName;
  String? get lName => _lName;
  String? get phone => _phone;
  String? get email => _email;
  String? get identityNumber => _identityNumber;
  String? get identityType => _identityType;
  String? get identityImage => _identityImage;
  String? get image => _image;
  String? get password => _password;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;
  String? get authToken => _authToken;
  String? get fcmToken => _fcmToken;
  List<Rating>? get rating => _rating;

  DeliveryMan.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _fName = json['f_name'];
    _lName = json['l_name'];
    _phone = json['phone'];
    _email = json['email'];
    _identityNumber = json['identity_number'];
    _identityType = json['identity_type'];
    _identityImage = json['identity_image'];
    _image = json['image'];
    _password = json['password'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _authToken = json['auth_token'];
    _fcmToken = json['fcm_token'];
    if (json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['f_name'] = _fName;
    data['l_name'] = _lName;
    data['phone'] = _phone;
    data['email'] = _email;
    data['identity_number'] = _identityNumber;
    data['identity_type'] = _identityType;
    data['identity_image'] = _identityImage;
    data['image'] = _image;
    data['password'] = _password;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;
    data['auth_token'] = _authToken;
    data['fcm_token'] = _fcmToken;
    if (_rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OfflinePaymentInformation {
  String? paymentName;
  String? paymentNote;
  List<MethodValue>? methodInformation;

  OfflinePaymentInformation({
    this.paymentName,
    this.paymentNote,
    this.methodInformation,
  });

  factory OfflinePaymentInformation.fromJson(String str) => OfflinePaymentInformation.fromMap(json.decode(str));


  factory OfflinePaymentInformation.fromMap(Map<String, dynamic> json) => OfflinePaymentInformation(
    paymentName: json["payment_name"],
    paymentNote: json["payment_note"],
    methodInformation: json["method_information"] == null ? [] : List<MethodValue>.from(json["method_information"]!.map((x) => MethodValue.fromMap(x))),
  );
}

class MethodValue {
  final String? key;
  final String? value;

  MethodValue({this.value, this.key});

  factory MethodValue.fromMap(Map<String, dynamic> json) => MethodValue(value: json[json.keys.first], key: json.keys.first);
}

class PredictionDurationTimeOrder {
  int? _id;
  int? _orderId;
  int? _deliveryPersonAge;
  double? _deliveryPersonRating;
  double? _distance;
  double? _predictionDurationResult;

  PredictionDurationTimeOrder({
    int? id,
    int? orderId,
    int? deliveryPersonAge,
    double? deliveryPersonRating,
    double? distance,
    double? predictionDurationResult
  }) {
    _id = id;
    _orderId = orderId;
    _deliveryPersonAge = deliveryPersonAge;
    _deliveryPersonRating = deliveryPersonRating;
    _distance = distance;
    _predictionDurationResult = predictionDurationResult;
  }

  int? get id => _id;
  int? get orderId => _orderId;
  int? get deliveryPersonAge => _deliveryPersonAge;
  double? get deliveryPersonRating => _deliveryPersonRating;
  double? get distance => _distance;
  double? get predictionDurationResult => _predictionDurationResult;

  PredictionDurationTimeOrder.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _orderId = json['order_id'];
    _deliveryPersonAge = json['delivery_person_age'];
    _deliveryPersonRating = json['delivery_person_rating'] != null
    ? double.tryParse(json['delivery_person_rating'].toString()) : 0.0;
    _distance = double.tryParse(json['distance'].toString());
    _predictionDurationResult = double.tryParse(json['prediction_duration_result'].toString());
  }


}