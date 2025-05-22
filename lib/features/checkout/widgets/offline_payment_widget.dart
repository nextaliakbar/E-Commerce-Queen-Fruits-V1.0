import 'package:ecommerce_app_queen_fruits_v1_0/common/models/offline_payment_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/checkout/providers/checkout_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/price_converter_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/localization/app_localization.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/main.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class OfflinePaymentWidget extends StatefulWidget {
  final double totalAmount;
  const OfflinePaymentWidget({super.key, required this.totalAmount});

  @override
  State<OfflinePaymentWidget> createState() => _OfflinePaymentWidgetState();
}

class _OfflinePaymentWidgetState extends State<OfflinePaymentWidget> {
  AutoScrollController? scrollController;
  Map<String, String>? selectedValue;

  @override
  void initState() {
    super.initState();

    final CheckoutProvider checkoutProvider = Provider.of<CheckoutProvider>(context, listen: false);
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    checkoutProvider.updatePaymentVisibility(false);
    scrollController = AutoScrollController(
      viewportBoundaryGetter: ()=> Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
      axis: Axis.horizontal
    );

    int index = splashProvider.offlinePaymentModelList!.indexOf(
      checkoutProvider.selectedOfflineMethod
    );

    scrollController?.scrollToIndex(index, preferPosition: AutoScrollPosition.middle);
    scrollController?.highlight(index);
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<CheckoutProvider>(Get.context!, listen: false).updatePaymentVisibility(true);
  }

  @override
  Widget build(BuildContext context) {
    final SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    return Center(child: SizedBox(width: 600, child: Container(
      constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.9),
      margin: const EdgeInsets.all(Dimensions.paddingSizeLarge),
      padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
      ),
      child: Consumer<CheckoutProvider>(builder: (context, checkoutProvider, _) {

        // return Text('data');
        return Column(children: [
          Expanded(child: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Pembayaran Offline", style: rubikSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: ColorResources.homePageSectionTitleColor
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Image.asset(Images.offlinePayment, height: 100),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Text('bayar tagihan Anda menggunakan informasi di bawah ini dan masukkan informasi dalam formulir', textAlign: TextAlign.center, style: rubikRegular.copyWith(
                fontSize: Dimensions.fontSizeLarge, color: Theme.of(context).hintColor,
              )),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              SingleChildScrollView(
                controller: scrollController, scrollDirection: Axis.horizontal,
                child: IntrinsicHeight(
                  child: Row(children: splashProvider.offlinePaymentModelList!.map((offline) => AutoScrollTag(
                    controller: scrollController!,
                    key: ValueKey(splashProvider.offlinePaymentModelList!.indexOf(offline)),
                    index: splashProvider.offlinePaymentModelList!.indexOf(offline),
                    child: InkWell(
                      onTap: () async {
                        checkoutProvider.formKey.currentState?.reset();
                        checkoutProvider.changePaymentMethod(offlinePaymentModel: offline);

                        await scrollController!.scrollToIndex(splashProvider.offlinePaymentModelList!.indexOf(offline), preferPosition: AutoScrollPosition.middle);
                        await scrollController!.highlight(splashProvider.offlinePaymentModelList!.indexOf(offline));
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.8,
                        constraints: const BoxConstraints(minHeight: 160),
                        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                        margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(color: Theme.of(context).secondaryHeaderColor.withOpacity(0.1), width: 1),
                          borderRadius: BorderRadius.circular(Dimensions.radiusLarge),
                          boxShadow: [BoxShadow(
                            color: Theme.of(context).secondaryHeaderColor.withOpacity(0.05),
                            offset: const Offset(0, 4), blurRadius: 8,
                          )],
                        ),
                        child: Column(children: [
                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            Text(offline?.methodName ?? '', style: rubikRegular.copyWith(fontSize: Dimensions.fontSizeSmall, color: ColorResources.primaryColor)),

                            if(offline?.id == checkoutProvider.selectedOfflineMethod?.id)
                              Row(mainAxisAlignment: MainAxisAlignment.end,  children: [
                                Text("Bayar di akun ini", style: rubikRegular.copyWith(
                                  color: ColorResources.primaryColor,
                                  fontSize: Dimensions.fontSizeSmall,
                                )),
                                const SizedBox(width: Dimensions.paddingSizeExtraSmall),

                                Icon(Icons.check_circle_rounded, color: Theme.of(context).secondaryHeaderColor, size: 20,)
                              ]),

                          ]),
                          const SizedBox(height: Dimensions.paddingSizeDefault),

                          if(offline?.methodFields != null) BillInfoWidget(methodList: offline!.methodFields!),

                        ]),
                      ),
                    ),
                  )).toList()),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),

              Selector<CheckoutProvider, double?>(
                selector: (context, checkoutProvider) => null,
                builder: (BuildContext context, partialAmount , Widget? child) {

                  return Text(
                    'Jumlah : ${PriceConverterHelper.convertPrice(partialAmount ?? widget.totalAmount)}',
                    style: rubikBold.copyWith(fontSize: Dimensions.fontSizeLarge),
                  );
                },
              ),
              const SizedBox(height: Dimensions.paddingSizeExtraLarge),


              if(checkoutProvider.selectedOfflineMethod?.methodFields != null)
                PaymentInfoWidget(methodInfo: checkoutProvider.selectedOfflineMethod!.methodInformationList!),

            ]),
          )),
          const SizedBox(height: Dimensions.paddingSizeDefault),


          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            CustomButtonWidget(
              textStyle: rubikSemiBold.copyWith(
                  color: ColorResources.homePageSectionTitleColor
              ),
              borderRadius: Dimensions.radiusDefault,
              btnTxt: "Tutup", width: 100,
              backgroundColor: Theme.of(context).hintColor.withOpacity(0.2),
              onTap: ()=> context.pop(),
            ),
            const SizedBox(width: Dimensions.paddingSizeDefault),

            CustomButtonWidget(
              btnTxt: "Simpan",
              borderRadius: Dimensions.radiusDefault,
              width: 130, onTap: (){
              if(checkoutProvider.formKey.currentState!.validate()){
                checkoutProvider.setOfflineSelectedValue(null);
                List<Map<String, String>>? data = [];
                checkoutProvider.field.forEach((key, value) {
                  data.add({key : value.text});
                });
                checkoutProvider.setOfflineSelectedValue(data);
                context.pop();
              }

            },),
          ]),
        ]);
      }),
    )));
  }
}

class BillInfoWidget extends StatelessWidget {
  final List<MethodField> methodList;
  const BillInfoWidget({super.key, required this.methodList});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: methodList.map((method) => Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Flexible(
          child: Text('${method.fieldName ?? ''} :    ${method.fieldData}',
            style: rubikRegular, overflow: TextOverflow.ellipsis, maxLines: 1,
          ),
        ),
      ]),
    )).toList());
  }
}

class PaymentInfoWidget extends StatefulWidget {
  final List<MethodInformation> methodInfo;
  const PaymentInfoWidget({super.key, required this.methodInfo});

  @override
  State<PaymentInfoWidget> createState() => _PaymentInfoWidgetState();
}

class _PaymentInfoWidgetState extends State<PaymentInfoWidget> {
  final TextEditingController noteTextController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text("Informasi Pembayaran", style: rubikSemiBold,),
      const SizedBox(height: Dimensions.paddingSizeSmall),

      Consumer<CheckoutProvider>(
          builder: (context, orderProvider, _) {
            orderProvider.field = {};
            for(int i = 0; i < widget.methodInfo.length; i++){
              orderProvider.field.addAll({'${widget.methodInfo[i].informationName}' : TextEditingController()});
            }
            return Column(children: [
              Form(
                key: orderProvider.formKey,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orderProvider.field.length,
                  padding: const EdgeInsets.symmetric(
                    vertical: Dimensions.paddingSizeExtraSmall, horizontal: 10,
                  ),

                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeExtraSmall),
                    child: CustomTextFieldWidget(
                      onValidate: widget.methodInfo[index].informationRequired! ? (String? value){
                        return value != null && value.isEmpty ? '${widget.methodInfo[index].informationName?.replaceAll("_", " ").toCapitalized()
                        } wajib' : null;
                      }: null,
                      isShowBorder: true,
                      borderColor: Theme.of(context).hintColor.withOpacity(0.4),
                      controller: orderProvider.field['${widget.methodInfo[index].informationName}'],
                      hintText:  widget.methodInfo[index].informationPlaceholder,
                      fillColor: Theme.of(context).cardColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeDefault),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeSmall),
                child: CustomTextFieldWidget(
                  fillColor: Theme.of(context).cardColor,
                  isShowBorder: true,
                  borderColor: Theme.of(context).hintColor.withOpacity(0.4),
                  controller: noteTextController,
                  hintText: "Catatan",
                  maxLines: 5,
                  inputType: TextInputType.multiline,
                  inputAction: TextInputAction.newline,
                  capitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    orderProvider.selectedOfflineMethod?.copyWith(note: noteTextController.text);
                  },
                ),
              ),

            ]);
          }
      ),
    ]);
  }
}


