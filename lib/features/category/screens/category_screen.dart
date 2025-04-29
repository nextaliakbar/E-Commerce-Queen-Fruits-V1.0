import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  final String categoryId;
  final String? categoryName;
  final String? categoryImage;
  final String? categoryBannerImage;

  const CategoryScreen({
    super.key,
    required this.categoryId,
    this.categoryName,
    this.categoryImage,
    this.categoryBannerImage
  });

  @override
  State<StatefulWidget> createState()=> _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> with TickerProviderStateMixin{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}