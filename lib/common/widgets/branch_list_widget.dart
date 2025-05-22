import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/title_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/providers/branch_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_item_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/branch/widgets/branch_simmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BranchListWidget extends StatefulWidget {
  final bool? isItemChange;
  final ScrollController controller;

  const BranchListWidget({
    super.key, required this.controller, this.isItemChange = false
  });

  @override
  State<StatefulWidget> createState()=> _BranchListWidgetState();
}

class _BranchListWidgetState extends State<BranchListWidget> {

  @override
  void initState() {
    super.initState();

    final BranchProvider branchProvider = Provider.of<BranchProvider>(context, listen: false);

    if(branchProvider.branchValueList == null) {
      branchProvider.getBranchValueList(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min, children: [

      Consumer<BranchProvider>(builder: (context, branchProvider, _) {
        return branchProvider.branchValueList == null ? const BranchShimmerWidget(isEnabled: true) : Column(
          children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
             child: TitleWidget(
               title: "Daftar cabang kami",
               subTitle: "Lihat semua",
               onTap: ()=> RouterHelper.getBranchListScreen(),
             ),
           ),

          const SizedBox(height: Dimensions.paddingSizeSmall),

          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeExtraSmall),
            shrinkWrap: true,
            itemCount: (branchProvider.branchValueList?.length ?? 0) > 4 ? 4 : branchProvider.branchValueList?.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) => BranchItemWidget(branchesValue: branchProvider.branchValueList?[index], isItemChange: widget.isItemChange ?? false),
          )
          ]
        );
      })
    ]);
  }
}