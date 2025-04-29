import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';

class CartModel {
  double? _price;
  double? _discountedPrice;
  List<Variation>? _variation;
  double? _discountAmount;
  int? _quantity;
  double? _taxAmount;
  Product? _product;
  List<List<bool?>>? _variations;

  CartModel({
    double? price,
    double? discountedPrice,
    List<Variation>? variation,
    double? discountAmount,
    int? quantity,
    double? taxAmount,
    Product? product,
    List<List<bool?>>? variations
  }) {
    _price = price;
    _discountedPrice = discountedPrice;
    _variation = variation;
    _discountAmount = discountAmount;
    _quantity = quantity;
    _taxAmount = taxAmount;
    _product = product;
    _variations = variations;
  }

  double? get price => _price;

  double? get discountedPrice => _discountedPrice;

  List<Variation>? get variation => _variation;

  double? get discountAmount => _discountAmount;

  int? get quantity => _quantity;

  double? get taxAmount => _taxAmount;

  Product? get product => _product;

  List<List<bool?>>? get variations => _variations;

  CartModel.fromJson(Map<String, dynamic> json) {
    _price = json['price'];
    _discountedPrice = json['discounted_price'].toDouble();
    if(json['variation'] != null) {
      _variation = [];
      json['variation'].forEach((v) {
        _variation!.add(Variation.fromJson(v));
      });
    }
  }
}