import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';

class UpsideExpansionWidget extends StatefulWidget {
  final List<Widget> children;
  final Widget title;

  const UpsideExpansionWidget({super.key, required this.children, required this.title});

  @override
  State<UpsideExpansionWidget> createState() => _UpsideExpansionWidgetState();
}

class _UpsideExpansionWidgetState extends State<UpsideExpansionWidget> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: () {
          if(expanded){
            expanded = false;
          }else{
            expanded = true;
          }
          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
          child: Icon(expanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Theme.of(context).hintColor),
        ),
      ),

      if (expanded) ... widget.children,

      Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          // controller: controller,
          tilePadding: EdgeInsets.zero,
          shape: Border.all(color: Colors.transparent, width: 0),
          collapsedShape: Border.all(color: Colors.transparent, width: 0),
          title: widget.title,
          onExpansionChanged: (newExpanded) {
            setState(() {
              expanded = newExpanded;
              // widget.onChange(expanded);
            });
          },
          trailing: const SizedBox.shrink(),
          children: const [],
        ),
      )
    ]);
  }
}
