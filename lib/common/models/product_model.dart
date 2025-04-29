import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/foundation.dart';

class Product {
  int? _id;
  String? _name;
  String? _description;
  String? _image;
  double? _price;
  List<Variation>? _variations;
  double? _tax;
  String? _availableTimeStarts;
  String? _availableTimeEnds;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  List<CategoryId>? _categoryIds;
  List<ChoiceOption>? _choiceOptions;
  double? _discount;
  String? _discountType;
  String? _taxType;
  List<Rating>? _rating;
  BranchProduct? _branchProduct;
  double? _mainPrice;
  bool? _isChanged;
  String? _changedReason;

  Product({
    int? id,
    String? name,
    String? description,
    String? image,
    double? price,
    List<Variation>? variations,
    double? tax,
    String? availableTimeStarts,
    String? availableTimeEnds,
    int? status,
    String? createdAt,
    String? updatedAt,
    List<CategoryId>? categoryIds,
    List<ChoiceOption>? choiceOptions,
    double? discount,
    String? discountType,
    String? taxType,
    List<Rating>? rating,
    BranchProduct? branchProduct,
    double? mainPrice,
    bool? isChanged,
    String? changedReason
  }) {
    _id = id;
    _name = name;
    _description = description;
    _image = image;
    _price = price;
    _variations = variations;
    _tax = tax;
    _availableTimeStarts = availableTimeStarts;
    _availableTimeEnds = availableTimeEnds;
    _status = status;
    _createdAt = createdAt;
    _categoryIds = categoryIds;
    _choiceOptions = choiceOptions;
    _discount = discount;
    _discountType = discountType;
    _taxType = taxType;
    _rating = rating;
    _branchProduct = branchProduct;
    _mainPrice = mainPrice;
    _isChanged = isChanged;
    _changedReason = changedReason;
  }

  int? get id => _id;

  String? get name => _name;

  String? get description => _description;

  String? get image => _image;

  double? get price => _price;

  List<Variation>? get variations => _variations;

  double? get tax => _tax;

  String? get availableTimeStarts => _availableTimeStarts;

  String? get availableTimeEnds => _availableTimeEnds;

  int? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  List<CategoryId>? get categoryIds => _categoryIds;

  List<ChoiceOption>? get choiceOptions => _choiceOptions;

  double? get discount => _discount;

  String? get discountType => _discountType;

  String? get taxType => _taxType;

  List<Rating>? get rating => _rating;

  BranchProduct? get branchProduct => _branchProduct;

  double? get mainPrice => _mainPrice;

  bool? get isChanged => _isChanged;

  String? get changedReason => _changedReason;

}

class Variation {
  String? name;
  int? min;
  int? max;
  bool? isRequired;
  bool? isMultiSelect;
  List<VariationValue>? variationValues;

  Variation({
    this.name, this.min, this.max,
    this.isRequired, this.isMultiSelect,
    this.variationValues
  });

  Variation.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    isMultiSelect = '${json['type']}' == 'multi';
    min = isMultiSelect! ? int.parse(json['min'].toString()) : 0;
    max = isMultiSelect! ? int.parse(json['max'].toString()) : 0;
    isRequired = '${json['required']}' == 'on';
    if(json['values'] != null) {
      variationValues = [];
      json['values'].forEach((v) {
        variationValues!.add(VariationValue.fromJson(v));
      });
    }
  }
}

class VariationValue {
  String? level;
  double? optionPrice;

  VariationValue({this.level, this.optionPrice});

  VariationValue.fromJson(Map<String, dynamic> json) {
    level = json['label'];
    optionPrice = double.parse(json['optionPrice'].toString());
  }
}

class CategoryId {
  String? _id;

  CategoryId({String? id}) {
    _id = id;
  }

  String? get id => _id;
}

class ChoiceOption {
  String? _name;
  String? _title;
  List<String>? _options;

  ChoiceOption({String? name, String? title, List<String>? options}) {
    _name = name;
    _title = title;
    _options = options;
  }

  String? get name => _name;
  String? get title => _title;
  List<String>? get options => _options;
}

class Rating {
  double? _avarage;
  int? _productId;

  Rating({double? avarage, int? productId}) {
    _avarage = avarage;
    _productId = productId;
  }

  double? get avarage => _avarage;
  int? get productId => _productId;
}

class BranchProduct {
  int? id;
  int? productId;
  int? branchId;
  double? price;
  bool? isAvailable;
  List<Variation>? variations;
  double? discount;
  String? discountType;
  int? stock;
  int? soldQuantity;
  String? stockType;

  BranchProduct({
    this.id,
    this.productId,
    this.branchId,
    this.price,
    this.isAvailable,
    this.variations,
    this.discount,
    this.discountType,
    this.stock,
    this.soldQuantity,
    this.stockType
  });
}