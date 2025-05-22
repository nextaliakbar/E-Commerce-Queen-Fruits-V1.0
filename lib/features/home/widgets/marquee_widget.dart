import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(milliseconds: 30000),
    this.backDuration = const Duration(milliseconds: 30000),
    this.pauseDuration = const Duration(milliseconds: 500)
  });

  @override
  State<StatefulWidget> createState()=> _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController? scrollController;
  @override
  void initState() {
    super.initState();

    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      controller: scrollController,
      child: widget.child,
    );
  }

  Future<void> scroll(_) async {
    while (scrollController!.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController!.hasClients) {
        await scrollController!.animateTo(
          scrollController!.position.maxScrollExtent,
          duration: widget.animationDuration,
          curve: Curves.ease,
        );
      }
      await Future.delayed(widget.pauseDuration);
      if (scrollController!.hasClients) {
        await scrollController!.animateTo(
          0.0,
          duration: widget.backDuration,
          curve: Curves.easeOut,
        );
      }
    }
  }
}