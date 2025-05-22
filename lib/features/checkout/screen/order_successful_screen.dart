import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/widgets/order_successful_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/screens/home_screen.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderSuccessfulScreen extends StatefulWidget {
  final String? orderId;
  final int status;

  const OrderSuccessfulScreen({super.key, required this.orderId, required this.status});

  @override
  State<OrderSuccessfulScreen> createState() => _OrderSuccessfulScreenState();
}

class _OrderSuccessfulScreenState extends State<OrderSuccessfulScreen> {
  bool _isReload = true;

  @override
  void initState() {
    Future.delayed(const Duration(milliseconds: 300)).then((_) {
      HomeScreen.loadData(true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: SafeArea(
        child: Consumer<OrderProvider>(
          builder: (context, orderProvider, _) {
            double total = 0;
            bool success = true;

            return orderProvider.isLoading ? const Center(child: CircularProgressIndicator())
                : OrderSuccessfulWidget(widget: widget, success: success, total: total, size: size);
          }
        ),
      ),
    );
  }
}
