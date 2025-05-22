import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/category/providers/category_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchResultScreen extends StatefulWidget {
  final String? searchString;

  const SearchResultScreen({super.key, required this.searchString});

  @override
  State<StatefulWidget> createState()=> _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  String type = 'all';

  @override
  void initState() {
    super.initState();

    final CategoryProvider categoryProvider = Provider.of<CategoryProvider>(context, listen: false);
    final SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.resetFilterData(isUpdate: false);

    int atamp = 0;

    if(atamp == 0) {
      _searchController.text = widget.searchString!.replaceAll('-', ' ');
      atamp = 1;
    }

    if(categoryProvider.categoryList == null) {
      categoryProvider.getCategoryList(true);
    }

    searchProvider.saveSearchAddress(_searchController.text);
    searchProvider.searchProduct(offset: 1, name: _searchController.text, context: context, isUpdate: false);
  }

  @override
  void dispose() {
    super.dispose();

    Provider.of<SearchProvider>(Get.context!, listen: false).resetFilterData(isUpdate: false);
  }

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(preferredSize: const Size.fromHeight(100), child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)],
        ),
        padding: const EdgeInsets.only(
          top: Dimensions.paddingSizeExtraLarge + Dimensions.paddingSizeDefault,
          bottom: Dimensions.paddingSizeDefault,
          right: Dimensions.paddingSizeLarge,
          left: Dimensions.paddingSizeSmall
        ),
        child: Row(children: [
         IconButton(onPressed: ()=> context.pop(), icon: const Icon(Icons.arrow_back_ios)),

         Consumer<SearchProvider>(builder: (context, searchProvider, _) {
           return Expanded(child: CustomTextFieldWidget(
             hintText: "Cari produkmu disini",
             isShowBorder: true,
             isShowSuffixIcon: true,
             suffixIconUrl: Images.closeSvg,
             suffixIconColor: null,
             controller: _searchController,
             inputAction: TextInputAction.search,
             isIcon: true,
             onSubmit: (value) {
               searchProvider.saveSearchAddress(value);
               searchProvider.searchProduct(offset: 1, name: value, context: context);
             },
             onSuffixTap: ()=> _searchController.clear(),
           ));
         }),

          const SearchFilterButtonWidget()
        ]),
      )),
    );
  }
}

class SearchFilterButtonWidget extends StatelessWidget {
  const SearchFilterButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault), child: InkWell(

    ));
  }
}