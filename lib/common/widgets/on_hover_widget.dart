import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OnHoverWidget extends StatefulWidget {

  final Widget Function(bool isHovered) builder;

  const OnHoverWidget({super.key, required this.builder});

  @override
  State<StatefulWidget> createState()=> _OnHoverWidgetState();
}

class _OnHoverWidgetState extends State<OnHoverWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    if(!kIsWeb) {
      return widget.builder(isHovered);
    }

    final matrixRtl = Matrix4.identity()..translate(-2,0,0);

    final transform  = isHovered ? matrixRtl : Matrix4.identity();

    return MouseRegion(
      onEnter: (_) {
        onEntered(true);
      },
      onExit: (_) {
        onEntered(false);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        transform: transform,
        child: widget.builder(isHovered),
      ),
    );

  }

  void onEntered(bool isHovered) {
    setState(() {
      this.isHovered = isHovered;
    });
  }
}