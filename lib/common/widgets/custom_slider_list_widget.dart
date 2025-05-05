import 'package:flutter/material.dart';

class CustomSliderListWidget extends StatefulWidget {
  final ScrollController controller;
  final double verticalPosition;
  final double horizontalPosition;
  final bool isShowForwardButton;
  final Widget child;

  const CustomSliderListWidget({
    super.key, required this.controller,
    required this.verticalPosition,
    this.horizontalPosition = 0,
    required this.child,
    this.isShowForwardButton = true
  });

  @override
  State<StatefulWidget> createState()=> _CustomSliderListWidgetState();
}

class _CustomSliderListWidgetState extends State<CustomSliderListWidget> {
  bool showBackButton = false;
  bool showForwardButton = false;
  bool isFirstTime = true;

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_checkScrollPosition);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(widget.isShowForwardButton && isFirstTime) {
      setState(() {
        showForwardButton = true;
      });
    }

    isFirstTime = false;

    return widget.child;
  }

  void _checkScrollPosition() {
    if(widget.controller.position.pixels <= 0) {
      showBackButton = false;
    } else {
      showBackButton = true;
    }

    if(widget.controller.position.pixels >= widget.controller.position.maxScrollExtent) {
      showForwardButton = false;
    } else {
      showForwardButton = true;
    }

    if(mounted) {
      setState(() {});
    }
  }
}