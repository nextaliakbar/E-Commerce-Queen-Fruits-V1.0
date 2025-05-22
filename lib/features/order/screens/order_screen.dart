import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/providers/order_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/order/widgets/order_list_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with TickerProviderStateMixin{
  late TabController _tabController;
  late bool _isLoggedIn;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2,  initialIndex: _selectedIndex, vsync: this);
    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(_isLoggedIn) {
      Provider.of<OrderProvider>(context, listen: false).getOrderList(context);
    }

    _tabController.addListener(() {
      _selectedIndex = _tabController.index;

      if(mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        context: context,
        title: 'Pesanan Saya',
        isBackButtonExist: false,
      ) as PreferredSizeWidget?,
      body: _isLoggedIn ? Consumer<OrderProvider>(
        builder: (context, order, child) {
          return Column(children: [

            Expanded(child: Center(child: SizedBox(width: Dimensions.webScreenWidth, child: Column(children: [
              Center(
                child: Container(
                  //width: 320,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    border: Border.all(color: Theme.of(context).hintColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                  ),
                  padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                  margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeDefault, horizontal: Dimensions.paddingSizeLarge),
                  child: TabBar(
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    controller: _tabController,
                    dividerHeight: 0,
                    indicator: const UnderlineTabIndicator(borderSide: BorderSide.none),
                    tabs: [
                      Tab(iconMargin: EdgeInsets.zero, child: Container(
                        height: double.maxFinite, width: double.maxFinite,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: _selectedIndex == 0 ? ColorResources.primaryColor : Theme.of(context).canvasColor,
                        ),
                        child: Center(child: Text(
                          'Berlangsung',
                          style: rubikRegular.copyWith(
                            color: _selectedIndex == 0 ? Theme.of(context).cardColor : ColorResources.primaryColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        )),
                      )),

                      Tab(iconMargin: EdgeInsets.zero, child: Container(
                        height: double.maxFinite, width: double.maxFinite,
                        margin: EdgeInsets.zero,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
                          color: _selectedIndex == 1 ? ColorResources.primaryColor : Theme.of(context).canvasColor,
                        ),
                        child: Center(child: Text(
                          'Riwayat',
                          style: rubikRegular.copyWith(
                            color: _selectedIndex == 1 ? Theme.of(context).cardColor : ColorResources.primaryColor,
                            fontWeight: _selectedIndex == 0 ? FontWeight.w700 : FontWeight.w400,
                          ),
                        )),
                      )),
                    ],
                  ),
                ),
              ),

              Expanded(child: TabBarView(
                controller: _tabController,
                children: const [
                  OrderListWidget(isRunning: true),

                  OrderListWidget(isRunning: false),
                ],
              )),
            ])))),

          ]);
        },
      ) : const SizedBox(),
    );
  }
}
