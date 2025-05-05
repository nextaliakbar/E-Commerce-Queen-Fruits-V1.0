import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_loader.widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';

class PaginatedListWidget extends StatefulWidget {

  final ScrollController scrollController;
  final Function(int? offset) onPaginate;
  final int? totalSize;
  final int? offset;
  final int? limit;
  final bool isDisableWebLoader;
  final Widget Function(Widget loaderWidget) builder;
  final bool enabledPagination;
  final bool reverse;

  const PaginatedListWidget({
    super.key, required this.scrollController, required this.onPaginate, required this.totalSize,
    required this.offset, required this.builder, this.enabledPagination = true, this.limit = 10,
    this.reverse = false, this.isDisableWebLoader = false
  });

  @override
  State<StatefulWidget> createState()=> _PaginatedListWidgetState();
}

class _PaginatedListWidgetState extends State<PaginatedListWidget> {
  int? _offset;
  late List<int?> _offsetList;
  bool _isLoading = false;
  bool _isDisbaledLoader = true;

  @override
  void initState() {
    super.initState();

    _offset = 1;
    _offsetList = [1];

    widget.scrollController.addListener(() {
      if(widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent
      && widget.totalSize != null && !_isLoading && widget.enabledPagination) {

        if(mounted) {
          _paginate();
        }
      }
    });
  }

  void _paginate() async {
    int pageSize = (widget.totalSize! / widget.limit!).ceil();

    if(_offset! < pageSize && !_offsetList.contains(_offset!+1)) {
      setState(() {
        _offset = _offset! + 1;
        _offsetList.add(_offset);
        _isLoading = true;
      });

      await widget.onPaginate(_offset);

      if(mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if(_isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.offset != null) {
      _offset = widget.offset;
      _offsetList = [];

      for(int i = 1; i < widget.offset!; i++) {
        _offsetList.add(i);
      }
    }

    return Column(children: [
      widget.reverse ? const SizedBox() : widget.builder(_LoadingWidget(
          isLoading: _isLoading,
          isDisabledLoader: _isDisbaledLoader,
          totalSize: widget.totalSize,
          onTap: _paginate
        )),

      if(widget.isDisableWebLoader) _LoadingWidget(
          isLoading: _isLoading,
          isDisabledLoader: _isDisbaledLoader,
          totalSize: widget.totalSize,
          onTap: _paginate
      ),

      widget.reverse ? widget.builder(_LoadingWidget(
          isLoading: _isLoading,
          isDisabledLoader: _isDisbaledLoader,
          totalSize: widget.totalSize,
          onTap: _paginate
      )) : const SizedBox()
    ]);
  }
}

class _LoadingWidget extends StatelessWidget {
  final bool isLoading;
  final bool isDisabledLoader;
  final int? totalSize;
  final Function onTap;

  const _LoadingWidget({
    required this.isLoading,
    required this.isDisabledLoader,
    required this.totalSize,
    required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return isDisabledLoader ? SizedBox(height: 0) : Center(child: Padding(
        padding: isLoading ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : EdgeInsets.zero,
        child: isLoading ? CustomLoaderWidget(color: ColorResources.primaryColor) : const SizedBox()
      )
    );
  }
}
