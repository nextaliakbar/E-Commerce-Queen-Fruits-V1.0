import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:flutter/foundation.dart';

class ProductModel {
  int? totalSize;
  int? limit;
  int? offset;
  double? productMaxPrice;
  List<Product>? products;

  ProductModel({
    this.totalSize,
    this.limit,
    this.offset,
    this.products,
    this.productMaxPrice
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    totalSize = int.tryParse('${json['total_size']}');
    limit = int.tryParse('${json['limit']}');
    offset = int.tryParse('${json['offset']}');

    if(json.containsKey('product_max_price')) {
      productMaxPrice = double.tryParse('${json['product_max_price']}');
    }

    if(json['products'] != null) {
      products = [];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['total_size'] = totalSize;
    data['limit'] = limit;
    data['product_max_price'] = productMaxPrice;
    if(products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}

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

  Product.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _description = json['description'];
    _image = json['image'];
    _price = json['price'].toDouble();

    if(json['variations'] != null) {
      _variations = [];
      json['variations'].forEach((v) {
        if(!v.containsKey('price')) {
          _variations!.add(Variation.fromJson(v));
        }
      });
    }

    _tax = json['tax'].toDouble();
    _availableTimeStarts = json['available_time_starts'] ?? '';
    _availableTimeEnds = json['available_time_ends'] ?? '';
    _status = json['status'] ?? 0;
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];

    if(json['category_ids'] != null) {
      _categoryIds = [];
      json['category_ids'].forEach((v) {
        _categoryIds!.add(CategoryId.fromJson(v));
      });
    }

    if(json['choice_options'] != null) {
      _choiceOptions = [];
      json['choice_options'].forEach((v) {
        _choiceOptions!.add(ChoiceOption.fromJson(v));
      });
    }

    _discount = json['discount'].toDouble();
    _discountType = json['discount_type'];
    _taxType = json['tax_type'];

    if(json['rating'] != null) {
      _rating = [];
      json['rating'].forEach((v) {
        _rating!.add(Rating.fromJson(v));
      });
    }

    if(json['branch_product'] != null) {
      _branchProduct = BranchProduct.fromJson(json['branch_product']);
      _price = branchProduct!.price;
      _discount = _branchProduct!.price;
      _discount = _branchProduct!.discount;
      _discountType = _branchProduct!.discountType;
    } else {
      _branchProduct = null;
    }

    _mainPrice = double.tryParse('${json['price']}');

    if(json.containsKey('is_changed')) {
      _isChanged = '${json['is_changed']}' .contains('1');
    }

    if(json.containsKey('change_reason')) {
      _changedReason = json['change_reason'];
    }
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['description'] = _description;
    data['image'] = _image;
    data['price'] = _price;

    if(_variations != null) {
      data['variations'] = _variations!.map((v) => v.toJson()).toList();
    }

    data['tax'] = _tax;
    data['available_time_starts'] = _availableTimeStarts;
    data['available_time_ends'] = _availableTimeEnds;
    data['status'] = _status;
    data['created_at'] = _createdAt;
    data['updated_at'] = _updatedAt;

    if(_categoryIds != null) {
      data['category_ids'] = _categoryIds!.map((v) => v.toJson()).toList();
    }

    if(_choiceOptions != null) {
      data['choice_options'] = _choiceOptions!.map((v) => v.toJson()).toList();
    }

    data['discount'] = _discount;
    data['discount_type'] = _discountType;
    data['tax_type'] = _taxType;
    data['main_price'] = _mainPrice;

    if(rating != null) {
      data['rating'] = _rating!.map((v) => v.toJson()).toList();
    }

    data['branch_product'] = _branchProduct;

    return data;
  }

  @override
  String toString() {
    return 'Product{_id: $_id, _name: $_name, _description: $_description, _image: $_image, _price: $_price, _variations: $_variations, _tax: $_tax, _availableTimeStarts: $_availableTimeStarts, _availableTimeEnds: $_availableTimeEnds, _status: $_status, _createdAt: $_createdAt, _updatedAt: $_updatedAt, _categoryIds: $_categoryIds, _choiceOptions: $_choiceOptions, _discount: $_discount, _discountType: $_discountType, _taxType: $_taxType, _rating: $_rating, _branchProduct: $_branchProduct, _mainPrice: $_mainPrice, _isChanged: $_isChanged, _changedReason: $_changedReason}';
  }
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic> {};
    data['name'] = name;
    data['type'] = isMultiSelect! ? 'multi' : 'single';
    data['min'] = min;
    data['max'] = max;
    data['required'] = isRequired! ? 'on' : 'off';

    if(variationValues != null) {
      data['values'] = variationValues!.map((v) => v.toJson()).toList();
    }

    return data;
  }

  @override
  String toString() {
    return 'Variation{name: $name, min: $min, max: $max, isRequired: $isRequired, isMultiSelect: $isMultiSelect, variationValues: $variationValues}';
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

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['level'] = level;
    data['optionsPrice'] = optionPrice;

    return data;
  }

  @override
  String toString() {
    return 'VariationValue{level: $level, optionPrice: $optionPrice}';
  }
}

class CategoryId {
  String? _id;

  CategoryId({String? id}) {
    _id = id;
  }

  String? get id => _id;

  CategoryId.fromJson(Map<String, dynamic> json) {
    _id = json['id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic> {};
    data['id'] = _id;
    return data;
  }
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

  ChoiceOption.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _title = json['title'];
    _options = json['options'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic> {};
    data['name'] = _name;
    data['title'] = _title;
    data['options'] = _options;

    return data;
  }

  @override
  String toString() {
    return 'ChoiceOption{_name: $_name, _title: $_title, _options: $_options}';
  }
}

class Rating {
  double? _average;
  int? _productId;

  Rating({double? avarage, int? productId}) {
    _average = avarage;
    _productId = productId;
  }

  double? get avarage => _average;
  int? get productId => _productId;

  Rating.fromJson(Map<String, dynamic> json) {
    _average = double.tryParse('${json['average']}');
    _productId = json['product_id'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic>{};
    data['average'] = _average;
    data['product_id'] = _productId;

    return data;
  }

  @override
  String toString() {
    return 'Rating{_avarage: $_average, _productId: $_productId}';
  }
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

  BranchProduct.fromJson(Map<String, dynamic> json) {
   id = json['id'];
   productId = json['product_id'];
   branchId = json['branch_id'];
   price = double.tryParse('${json['price']}');
   isAvailable = ('${json['is_available']}' == '1') || '${json['is_available']}' == 'true';

   if(json['variations'] != null) {
     variations = [];
     json['variations'].forEach((v) {
       if(!v.containsKey('price')) {
         variations!.add(Variation.fromJson(v));
       }
     });
   }

   discount = json['discount'].toDouble();
   discountType = json['discount_type'];
   stockType = json['stock_type'];
   stock = json['stock'];
   soldQuantity = json['sold_quantity'];
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = <String, dynamic> {};
    data['id'] = id;
    data['product_id'] = productId;
    data['branch_id'] = branchId;
    data['price'] = price;
    data['is_available'] = isAvailable;
    data['variations'] = variations;
    data['discount'] = discount;
    data['discount_type'] = discountType;
    data['stock'] = stock;
    data['stock_type'] = stockType;
    data['sold_quantity'] = soldQuantity;

    return data;

  }

  @override
  String toString() {
    return 'BranchProduct{id: $id, productId: $productId, branchId: $branchId, price: $price, isAvailable: $isAvailable, variations: $variations, discount: $discount, discountType: $discountType, stock: $stock, soldQuantity: $soldQuantity, stockType: $stockType}';
  }
}