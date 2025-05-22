import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/debounce_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchBarFocus = FocusNode();
  final DebounceHelper debounce = DebounceHelper(miliseconds: 500);

  @override
  void initState() {
    super.initState();

    final SearchProvider searchProvider = Provider.of<SearchProvider>(context, listen: false);

    searchProvider.initHistoryList();
    searchProvider.onClearSearchSuggestion();

    _searchController.addListener(_onChange);

    _searchBarFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if(mounted) {
      setState(() {});
    }
  }

  void _onChange() {
    if(_searchController.text.isEmpty) {
      Provider.of<SearchProvider>(context, listen: false).onClearSearchSuggestion();
    }

    if(mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();

    _searchBarFocus.removeListener(_onFocusChange);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        leadingWidth: 0,
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Consumer<SearchProvider>(builder: (context, searchProvider, _) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: ColorResources.primaryColor,
                  blurRadius: Dimensions.radiusSmall,
                  spreadRadius: 1,
                  offset: const Offset(0, 4)
                )
              ]
            ),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.02,
              bottom: Dimensions.paddingSizeDefault,
              right: Dimensions.paddingSizeLarge,
              left: Dimensions.paddingSizeSmall
            ),
            child: Row(children: [
             IconButton(onPressed: ()=> context.pop(), icon: const Icon(Icons.arrow_back_ios)),
              Expanded(
                child: CustomTextFieldWidget(
                  hintText: "Cari produk favoritmu disini",
                  isShowBorder: true,
                  controller: _searchController,
                  focusNode: _searchBarFocus,
                  inputAction: TextInputAction.search,
                  isIcon: true,
                  suffixIconUrl: Images.closeSvg,
                  isShowSuffixIcon: _searchController.text.isNotEmpty,
                  // onSuffixTap: ()=> _searchController.clear(),
                  onSubmit: (text) {
                    // if(_searchController.text.trim().isNotEmpty) {
                    //   searchProvider.saveSearchAddress(_searchController.text);
                    //   searchProvider.searchProduct(
                    //       offset: 1,
                    //       name: _searchController.text,
                    //       context: context
                    //   );

                    //   RouterHelper.getSearchResultRoute(
                    //     _searchController.text.replaceAll(' ', '-')
                    //   );
                    // }

                    showCustomSnackBarHelper("Fitur sedang tahap pengembangan");
                  },
                  // onChanged: (String text) => debounce.run(() {
                  //   if(text.isNotEmpty) {
                  //     searchProvider.onChangeAutoCompleteTag(searchText: text);
                  //   }
                  // }),
                ),
              )
            ]),
          );
        }),
      ),
    );
  }
}