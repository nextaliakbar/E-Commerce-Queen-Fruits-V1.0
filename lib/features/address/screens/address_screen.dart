import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/domain/models/address_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/providers/location_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/address/widgets/address_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();

    _isLoggedIn = Provider.of<AuthProvider>(context, listen: false).isLoggedIn();

    if(_isLoggedIn) {
      Provider.of<LocationProvider>(context, listen: false).initAddressList();

      // debugPrint("Address list index ${Provider.of<LocationProvider>(context, listen: false).addressList?.length}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: CustomAppBarWidget(context: context, title: "Daftar Alamat", centerTitle: true)
       as PreferredSizeWidget?,
      floatingActionButton: _isLoggedIn ? Padding(
        padding: const EdgeInsets.only(top: 0),
        child: FloatingActionButton(
          backgroundColor: ColorResources.primaryColor,
          onPressed: () => RouterHelper.getAddAddressRoute('address', 'add', AddressModel()),
          child: const Icon(Icons.add, color: Colors.white)
        ),
      ) : null,
      body: CustomScrollView(slivers: [
       _isLoggedIn ? SliverToBoxAdapter(
         child: Consumer<LocationProvider>(builder: (context, locationProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              await Provider.of<LocationProvider>(context, listen: false).initAddressList();
            },
            backgroundColor: ColorResources.primaryColor,
            color: Theme.of(context).cardColor,
            child: CustomPaint(
              size: const Size(Dimensions.webScreenWidth, 150),
              child: locationProvider.addressList == null
                  ? _AddressShimmerWidget(isEnabled: locationProvider.addressList == null)
                  : locationProvider.addressList!.isNotEmpty
                  ? ListView.builder(
                    padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                    itemCount: locationProvider.addressList?.length ?? 0,
                    physics: const BouncingScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        bottom: index == (locationProvider.addressList?.length ?? 0) - 1 ? 50 : Dimensions.paddingSizeDefault
                      ),
                      child: AddressCardWidget(
                        addressModel: locationProvider.addressList![index],
                        index: index,
                      ),
                    ),
                  )
                  : SizedBox()
            ),
          );
         }),
       ) : const SliverToBoxAdapter()
      ]),
    );
  }
}

class _AddressShimmerWidget extends StatelessWidget {
  final bool isEnabled;

  const _AddressShimmerWidget({required this.isEnabled});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
      itemCount: 5,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) => Container(),
    );
  }
}