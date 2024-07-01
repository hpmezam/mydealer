import 'package:flutter/material.dart';
import 'package:mydealer/controllers/auth_controller.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:mydealer/widgets/login/custom_text_feild_widget.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthController>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 12,
                      bottom: 38,
                    ),
                    child: Column(
                      children: [
                        Hero(
                          tag: 'logo',
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: Dimensions.paddingSizeExtraLarge,
                            ),
                            child: Image.asset(Images.logo, width: 80),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              getTranslated('seller', context)!,
                              style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeExtraLargeTwenty,
                              ),
                            ),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall,
                            ),
                            Text(
                              getTranslated('app', context)!,
                              style: robotoMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontSize: Dimensions.fontSizeExtraLargeTwenty,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
              ),
              child: Text(
                getTranslated('login', context)!,
                style: titilliumBold.copyWith(
                  fontSize: Dimensions.fontSizeOverlarge,
                ),
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeLarge),
            Container(
              margin: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge,
                right: Dimensions.paddingSizeLarge,
                bottom: Dimensions.fontSizeSmall,
              ),
              child: CustomTextFieldWidget(
                border: true,
                prefixIconImage: Images.emailIcon,
                hintText: getTranslated('enter_email_address', context),
                controller: auth.emailController,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeSmall),
            Container(
              margin: const EdgeInsets.only(
                left: Dimensions.paddingSizeLarge,
                right: Dimensions.paddingSizeLarge,
                bottom: Dimensions.paddingSizeDefault,
              ),
              child: CustomTextFieldWidget(
                border: true,
                isPassword: true,
                prefixIconImage: Images.lock,
                hintText: getTranslated('password_hint', context),
                textInputAction: TextInputAction.done,
                controller: auth.passwordController,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeButton),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.6, // Ajustar el ancho según sea necesario
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.paddingSizeExtraLarge,
                      vertical: Dimensions.paddingSizeSmall,
                    ),
                    textStyle: TextStyle(
                      fontSize: Dimensions.fontSizeLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: auth.isLoading ? null : () => auth.login(context),
                  child: auth.isLoading
                      ? CircularProgressIndicator()
                      : Text(getTranslated('login', context)!),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
