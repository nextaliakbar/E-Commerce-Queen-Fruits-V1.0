import 'package:ecommerce_app_queen_fruits_v1_0/features/search/providers/search_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/debounce_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class WebAppBarWidget extends StatefulWidget implements PreferredSizeWidget {

  const WebAppBarWidget({super.key});

  @override
  State<StatefulWidget> createState() => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => throw UnimplementedError();
}

class _WebAppBarWidgetState extends State<WebAppBarWidget> {
  final GlobalKey _searchBarKey = GlobalKey();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _appBarSearchFocusNode = FocusNode();

  Future<void> _showSearchDialog() async {
    final  SearchProvider searchProvider = Provider.of(context, listen: false);
    RenderBox renderBox = _searchBarKey.currentContext!.findRenderObject() as RenderBox;
    final searchBarPosition = renderBox.localToGlobal(Offset.zero);
    final DebounceHelper debounce = DebounceHelper(miliseconds: 500);
    searchProvider.initHistoryList();

    if(searchProvider.searchController.text.isNotEmpty) {
      searchProvider.onChangeAutoCompleteTag(searchText: searchProvider.searchController.text);
    }

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}