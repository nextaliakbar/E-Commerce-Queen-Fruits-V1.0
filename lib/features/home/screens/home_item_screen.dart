import 'package:ecommerce_app_queen_fruits_v1_0/common/models/product_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/providers/product_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/no_data_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/paginated_lis_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/product_shimmer_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_group.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/product_type_enum.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/enums/quantity_position.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/home_item_type_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/home/widgets/product_card_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeItemScreen extends StatefulWidget {
  final ProductType? productType;

  const HomeItemScreen({super.key, this.productType});

  @override
  State<StatefulWidget> createState()=> _HomeItemScreenState();
}

class _HomeItemScreenState extends State<HomeItemScreen> {
  final ScrollController scrollController = ScrollController();
  late ProductType? productType;

  @override
  void initState() {
    super.initState();

    productType = widget.productType;
    _loadData(false);

    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(productType == ProductType.localProduct) {
      productProvider.getPopularLocalProductList(1, true, isUpdate: false);
    } else if(productType == ProductType.importProduct) {
      productProvider.getImportProductList(1, true, isUpdate: false);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _loadData(bool isReload) async {
    final ProductProvider productProvider = Provider.of<ProductProvider>(context, listen: false);

    if(productType == ProductType.localProduct && productProvider.latestProductModel == null || isReload) {
      productProvider.getPopularLocalProductList(1, true, isUpdate: isReload);
    } else if(productType == ProductType.importProduct && productProvider.importProductModel == null || isReload) {
      productProvider.getImportProductList(1, true, isUpdate: isReload);
    }
  }

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: CustomAppBarWidget(
        title: productType == ProductType.localProduct ? "Produk lokal" : "Produk impor",
        actionView: HomeItemTypeWidget(onChange: (ProductType productType) {
          setState(() {
            this.productType = productType;
          });

          _loadData(true);
        }),
      ),
      body: Center(child: CustomScrollView(controller: scrollController, slivers: [
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: Dimensions.paddingSizeSmall,
            horizontal: Dimensions.paddingSizeDefault
          ),
          child: Column(children: [
            SizedBox(width: Dimensions.webScreenWidth, child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
               ProductModel? productModel;

               if(productType == ProductType.localProduct) {
                 productModel = productProvider.popularLocalProductModel;
               } else if(productType == ProductType.importProduct) {
                 productModel = productProvider.importProductModel;
               }

               if(productModel == null) {
                 return GridView.builder(
                   shrinkWrap: true,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisSpacing: Dimensions.paddingSizeSmall,
                     mainAxisSpacing: Dimensions.paddingSizeSmall,
                     crossAxisCount: 2,
                     mainAxisExtent: 240,
                   ),
                   itemCount: 12,
                   itemBuilder: (BuildContext context, int index) {
                     return const ProductShimmerWidget(isEnabled: true, width: double.minPositive, isList: false);
                   },
                   padding: EdgeInsets.zero
                 );
               }

               return (productModel.products?.isNotEmpty ?? false) ? PaginatedListWidget(
                 totalSize: productModel.totalSize,
                 offset: productModel.offset,
                 limit: productModel.limit,
                 onPaginate: (int? offset) async {
                   if(productType == ProductType.localProduct) {
                     await productProvider.getPopularLocalProductList(offset ?? 1, false);
                   } else if(productType == ProductType.importProduct) {
                     await productProvider.getImportProductList(offset ?? 1, false);
                   }
                 },
                 scrollController: scrollController,
                 builder: (_) => GridView.builder(
                   padding: EdgeInsets.zero,
                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisSpacing: Dimensions.paddingSizeSmall,
                     mainAxisSpacing: Dimensions.paddingSizeSmall,
                     crossAxisCount: 2,
                     mainAxisExtent: 300
                   ),
                   itemCount: productModel?.products?.length,
                   physics: const NeverScrollableScrollPhysics(),
                   shrinkWrap: true,
                   itemBuilder: (context, index) => ProductCardWidget(
                     product: productModel!.products![index],
                     quantityPosition: QuantityPosition.left,
                     productGroup: ProductGroup.common,
                     isShowBorder: true,
                     imageHeight: 160,
                     imageWidth: screenSize.width,
                   ),
                 ),
               ) : const NoDataWidget();
              }
            ),)
          ]),
        ))
      ])),
    );
  }

}