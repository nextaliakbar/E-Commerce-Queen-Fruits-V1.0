import 'package:ecommerce_app_queen_fruits_v1_0/common/models/config_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_app_bar_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_button_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/common/widgets/custom_text_field_widget.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/domain/models/signup_model.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/auth/providers/auth_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/features/splash/providers/splash_provider.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/custom_snackbar_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/email_checker_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/helper/router_helper.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/color_resources.dart';
import 'package:ecommerce_app_queen_fruits_v1_0/util/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<StatefulWidget> createState()=> _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _numberFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FocusNode _referTextFocus = FocusNode();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _referTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final configModel = Provider.of<SplashProvider>(context, listen: false).configModel!;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: CustomAppBarWidget(
            title: '',
            isBackButtonExist: Navigator.canPop(context),
            onBackPressed: ()=> Navigator.pop(context),
          )
      ),
      body: Consumer<AuthProvider>(builder: (context, authProvider, child) {
        return SafeArea(child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
           Padding(
             padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
             child: Center(child: Container(
               width: width > 700 ? 700 : width,
               padding: width > 700 ? const EdgeInsets.all(Dimensions.paddingSizeDefault) : null,
               decoration: width > 700 ? BoxDecoration(
                   color: Theme.of(context).canvasColor, borderRadius: BorderRadius.circular(10),
                   boxShadow: [BoxShadow(color: Theme.of(context).shadowColor, blurRadius: 5, spreadRadius: 1)]
               ): null,
               child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                 Center(child: Text("Buat Akun", style: Theme.of(context).textTheme.displaySmall!.copyWith(
                     fontSize: 24, color: ColorResources.greyBunkerColor))),

                 const SizedBox(height: 20),

                 /// First name
                 Text("Nama Depan", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: 'Nama depan',
                   isShowBorder: true,
                   controller: _firstNameController,
                   focusNode: _firstNameFocus,
                   nextFocus: _lastNameFocus,
                   inputType: TextInputType.name,
                   capitalization: TextCapitalization.words,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 /// Last name
                 Text("Nama Belakang", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: 'Nama belakang',
                   isShowBorder: true,
                   controller: _lastNameController,
                   focusNode: _lastNameFocus,
                   nextFocus: _emailFocus,
                   inputType: TextInputType.name,
                   capitalization: TextCapitalization.words,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 /// Phone number
                 Text("No.Hp", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: '08123456789',
                   isShowBorder: true,
                   controller: _numberController,
                   focusNode: _numberFocus,
                   nextFocus: _emailFocus,
                   inputType: TextInputType.phone,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 /// Email
                 Text("email", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: 'example@gmail.com',
                   isShowBorder: true,
                   controller: _emailController,
                   focusNode: _emailFocus,
                   nextFocus: _passwordFocus,
                   inputType: TextInputType.emailAddress,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 /// Password
                 Text("Kata Sandi", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: 'Masukkan minimal 6 karakter',
                   isShowBorder: true,
                   isPassword: true,
                   controller: _passwordController,
                   focusNode: _passwordFocus,
                   nextFocus: _confirmPasswordFocus,
                   isShowSuffixIcon: true,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 /// Phone number
                 Text("Konfirmasi Kata Sandi", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                     color: ColorResources.hintColor
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 CustomTextFieldWidget(
                   hintText: 'Masukkan minimal 6 karakter',
                   isShowBorder: true,
                   isPassword: true,
                   controller: _confirmPasswordController,
                   focusNode: _confirmPasswordFocus,
                   inputAction: TextInputAction.done,
                 ),

                 const SizedBox(height: Dimensions.paddingSizeLarge),

                 Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  authProvider.registrationErrorMessage!.isNotEmpty
                   ? CircleAvatar(backgroundColor: Theme.of(context).colorScheme.error, radius: 5)
                   : const SizedBox.shrink(),

                   const SizedBox(width: 8),

                   Expanded(child: Text(
                     authProvider.registrationErrorMessage ?? "",
                     style: Theme.of(context).textTheme.displayMedium!.copyWith(
                       fontSize: Dimensions.fontSizeSmall,
                       color: Theme.of(context).colorScheme.error
                     )
                   ))
                 ]),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 !authProvider.isLoading ? CustomButtonWidget(
                   btnTxt: "Masuk",
                   onTap: () async {
                     String firstName = _firstNameController.text.trim();
                     String lastName = _lastNameController.text.trim();
                     String phoneNumber = _numberController.text.trim();
                     String email = _emailController.text.trim();
                     String password = _passwordController.text.trim();
                     String confirmPassword = _confirmPasswordController.text.trim();

                     if(firstName.isEmpty) {
                       showCustomSnackBarHelper("Nama depan belum diisi");
                     } else if(lastName.isEmpty) {
                       showCustomSnackBarHelper("Nama belakang belum diisi");
                     } else if(phoneNumber.isEmpty) {
                       showCustomSnackBarHelper("No.hp belum diisi");
                     } else if(email.isEmpty)  {
                       showCustomSnackBarHelper("Email belum diisi");
                     } else if(EmailCheckerHelper.isNotValid(email))  {
                       showCustomSnackBarHelper("Email tidak valid");
                     } else if(password.isEmpty) {
                       showCustomSnackBarHelper("Password belum diisi");
                     } else if(password.length < 6) {
                       showCustomSnackBarHelper("Password harus lebih dari 6 karakter");
                     } else if(confirmPassword.isEmpty) {
                       showCustomSnackBarHelper("Konfirmasi password belum diisi");
                     } else if(password != confirmPassword) {
                       showCustomSnackBarHelper("Konfirmasi password harus sama dengan password");
                     } else {
                       SignUpModel signUpModel = SignUpModel(
                         fName: firstName,
                         lName: lastName,
                         email: email,
                         password: password,
                         phone: phoneNumber
                       );

                       await authProvider.registration(signUpModel, configModel).then((status) async {
                         if(status.isSuccess) RouterHelper.getDashboardRouter('home');
                       });
                     }
                   },
                 ) : Center(child: CircularProgressIndicator(
                   valueColor: AlwaysStoppedAnimation<Color>(ColorResources.primaryColor)
                 )),

                 const SizedBox(height: Dimensions.paddingSizeSmall),

                 InkWell(
                   onTap: ()=> RouterHelper.getLoginRoute(action: RouteAction.pushReplacement),
                   child: Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: [
                         Text("Sudah punya akun?", style: Theme.of(context).textTheme.displayMedium!.copyWith(
                           fontSize: Dimensions.fontSizeSmall, color: Theme.of(context).hintColor.withOpacity(0.7)
                         )),

                         const SizedBox(width: Dimensions.paddingSizeSmall),

                         Text("Masuk", style: Theme.of(context).textTheme.displaySmall!.copyWith(
                           fontSize: Dimensions.fontSizeSmall, color: ColorResources.greyBunkerColor
                         ))
                       ],
                     ),
                   ),
                 )
               ]),
             )),
           )
          ]),
        ));
      }),
    );
  }
}