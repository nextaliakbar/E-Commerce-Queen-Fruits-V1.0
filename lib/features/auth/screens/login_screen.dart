import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_image_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_pop_scope_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/models/user_log_data.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/number_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _emailNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  TextEditingController? _emailPhoneController;
  TextEditingController? _passwordController;
  GlobalKey<FormState>? _formKeyLogin;

  @override
  void initState() {
    super.initState();

    _formKeyLogin = GlobalKey<FormState>();
    _emailPhoneController = TextEditingController();
    _passwordController = TextEditingController();

    final ConfigModel configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;
    final AuthProvider authProvider = Provider.of<AuthProvider>(context, listen: false);

    authProvider.setIsLoading = false;
    authProvider.setIsPhoneNumberVerificationButtonLoading = false;
    UserLogData? userData = authProvider.getUserData();
    authProvider.toggleIsNumberLogin(value: false, isUpdate: false);

    if(userData != null) {
      if(userData.phoneNumber != null) {
        _emailPhoneController!.text = userData.phoneNumber!;
        authProvider.toggleIsNumberLogin(isUpdate: false);
      } else if(userData.email != null) {
        _emailPhoneController?.text = userData.email?.trim() ?? '';
      }
      _passwordController!.text = userData.password ?? '';
    }

  }

  @override
  void dispose() {
    super.dispose();

    _emailPhoneController!.dispose();
    _passwordController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final size = MediaQuery.of(context).size;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return CustomPopScopeWidget(
        child: Scaffold(
          appBar: null,
          body: SafeArea(
              child: Center(child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                  child: Column(children: [
                   Padding(padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                   child: Center(child: Container(
                     width: width > 700 ? 500 : width,
                     padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeExtraLarge) : null,
                     decoration: width > 700 ? BoxDecoration(
                       color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                       boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)]
                     ) : null,
                     child: Consumer<AuthProvider>(builder: (context, authProvider, child) {
                        return Form(key: _formKeyLogin, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          SizedBox(height: size.height * 0.1),

                          Consumer<SplashProvider>(builder: (context, splashProvider, child) {
                            return Center(child: Padding(
                              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                              child: Directionality(textDirection: TextDirection.ltr, child: CustomImageWidget(
                                image: '${splashProvider.baseUrls?.storeImageUrl}/${splashProvider.configModel!.storeLogo}',
                                placeholder: Images.webAppBarLogo,
                                fit: BoxFit.contain,
                                width: 150, height: 150,
                              )),
                            ));
                          }),

                          const SizedBox(height: 35),

                          Selector<AuthProvider, bool>(
                              selector: (context, authProvider) => authProvider.isNumberLogin,
                              builder: (_, isNumberLogin, ___) {
                                return CustomTextFieldWidget(
                                  onChanged: (String text) {
                                    debugPrint('---- ON CHANGED---');
                                    final numberRegExp = RegExp(r'^-?[0-9]+$');

                                    if(text.isEmpty && authProvider.isNumberLogin) {
                                      authProvider.toggleIsNumberLogin(isUpdate: true);
                                      debugPrint('-----(IS AUTH PROVIDER LOGIN 1 ${authProvider.isNumberLogin})------');
                                    }

                                    if(text.startsWith(numberRegExp) && !authProvider.isNumberLogin) {
                                      authProvider.toggleIsNumberLogin(isUpdate: true);
                                      debugPrint('-----(AUTH PROVIDER LOGIN 2)------');
                                    }

                                    final emailRegExp = RegExp(r'@');

                                    if(text.contains(emailRegExp) && authProvider.isNumberLogin) {
                                      authProvider.toggleIsNumberLogin(isUpdate: true);
                                    }
                                  },

                                  hintText: '',
                                  isShowBorder: true,
                                  focusNode: _emailNumberFocus,
                                  nextFocus: _passwordFocus,
                                  controller: _emailPhoneController,
                                  inputType: TextInputType.name,
                                  label: 'Email atau No.Hp',
                                );
                              },
                          ),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          CustomTextFieldWidget(
                            hintText: 'Password',
                            label: 'Password',
                            isShowBorder: true,
                            isRequired: true,
                            isPassword: true,
                            isShowSuffixIcon: true,
                            focusNode: _passwordFocus,
                            controller: _passwordController,
                            inputAction: TextInputAction.done,
                            prefixIconUrl: Images.lockSvg,
                            isShowPrefixIcon: true,
                            prefixIconColor: ColorResources.primaryColor,
                          ),

                          const SizedBox(height: 22),

                          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                            InkWell(
                              onTap: ()=> authProvider.toggleRememberMe(),
                              child: Row(children: [
                                Container(width: 18, height: 18,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Theme.of(context).secondaryHeaderColor),
                                    borderRadius: BorderRadius.circular(3)
                                  ),
                                  child: authProvider.isActiveRememberMe
                                  ? Icon(Icons.done, color: Theme.of(context).secondaryHeaderColor, size: 14)
                                  : const SizedBox.shrink(),
                                ),

                                const SizedBox(width: Dimensions.paddingSizeSmall),

                                Text("Ingat saya", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                 fontSize: Dimensions.fontSizeSmall, color: ColorResources.hintColor
                                ))
                              ]),
                            ),

                            InkWell(
                              onTap: (){
                                showCustomSnackBarHelper("Fitur dalam tahap pengembangan");
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Lupa password ?", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                  fontSize: Dimensions.fontSizeSmall, color: ColorResources.primaryColor
                                )),
                              ),
                            )
                          ]),

                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            authProvider.loginErrorMessage!.isNotEmpty
                            ? CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: 5) : const SizedBox(width: 8),

                            Expanded(child: Text(authProvider.loginErrorMessage ?? "",
                            style: Theme.of(context).textTheme.displayMedium!.copyWith(
                              fontSize: Dimensions.fontSizeSmall,
                              color: Theme.of(context).colorScheme.error
                            )))
                          ]),

                          const SizedBox(height: 10),

                          !authProvider.isLoading && !authProvider.isPhoneNumberVerificationButtonLoading ? CustomButtonWidget(
                            btnTxt: "Masuk", onTap: () async {
                              String emailPhone = _emailPhoneController!.text;
                              String password = _passwordController!.text.trim();
                              
                              if(emailPhone.isEmpty) {
                                showCustomSnackBarHelper("Masukkan email atau no. hp");
                              } else if(password.isEmpty) {
                                showCustomSnackBarHelper("Masukkan password");
                              } else if(password.length < 6) {
                                showCustomSnackBarHelper("Password harus lebih dari 6 karakter");
                              } else {
                                String userInput = emailPhone.trim();
                                bool isNumber = NumberCheckHelper.isNumber(userInput);

                                String type = isNumber ? 'phone' : 'email';

                                await authProvider.login(userInput, password, type).then((status) async {
                                  if(status.isSuccess) {
                                    if(authProvider.isActiveRememberMe) {
                                      debugPrint("--------(User Input)--$userInput and  Is Number $isNumber");
                                      authProvider.saveUserNumberAndPassword(UserLogData(
                                        phoneNumber: isNumber ? userInput : null,
                                        email: isNumber ? null : userInput,
                                        password: password
                                      ));
                                    } else {
                                      authProvider.clearUserLogData();
                                    }
                                    RouterHelper.getDashboardRouter('home', action: RouteAction.pushNameAndRemoveUntil);
                                  }
                                });
                              }
                          },
                          ) : Center(child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor),
                          )),

                          const SizedBox(height: Dimensions.paddingSizeLarge),

                          InkWell(
                            onTap: ()=> RouterHelper.getCreateAccountRoute(),
                            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                             Text("Buat akun", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                                fontSize: Dimensions.fontSizeSmall,
                                color: Theme.of(context).textTheme.bodyMedium?.color
                             )),

                             const SizedBox(width: Dimensions.paddingSizeSmall),
                              
                              Text("Klik disini", style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                fontSize: Dimensions.fontSizeDefault,
                                decoration: TextDecoration.underline,
                                decorationColor: ColorResources.primaryColor,
                                color: ColorResources.primaryColor
                              ))
                            ]),
                          )
                        ]));
                     }),
                   )))
                  ]),
                )
              ]))
          )
        ),
    );
  }
}