import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/providers/sorting_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SortingButtonWidget extends StatelessWidget {
  const SortingButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    return Consumer<ProductSortProvider>(builder: (context, productSortProvider, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Tooltip(
              message: 'Grid view',
              child: Material(

              ),
            )
          ]
        );
      },
    );
  }
}