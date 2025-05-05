import 'dart:convert';

import 'package:ecommerce_app_queen_fruits_v1_0/features/category/domain/models/category_model.dart';

SearchRecommendedModel searchRecommendedModelFromJson(String str) => SearchRecommendedModel.fromJson(jsonDecode(str));
String searchRecommendedModelToJson(SearchRecommendedModel data) => jsonEncode(data.toJson());

class SearchRecommendedModel {
  List<CategoryModel> categories;

  SearchRecommendedModel({required this.categories});

  factory SearchRecommendedModel.fromJson(Map<String, dynamic> json) => SearchRecommendedModel(
      categories: List<CategoryModel>.from(json['categories'].map((v) => CategoryModel.fromJson(v)))
  );

  Map<String, dynamic> toJson() => {
    "categories" : List<dynamic>.from(categories.map((v) => v.toJson()))
  };
}