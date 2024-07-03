import 'package:flutter/material.dart';
import 'package:mydealer/widgets/menu/custom_button_widget.dart';
// import 'package:provider/provider.dart';
// import 'package:mydealer/features/product/controllers/product_controller.dart';
import 'package:mydealer/localization/language_constrants.dart';
// import 'package:mydealer/features/auth/controllers/auth_controller.dart';
// import 'package:mydealer/features/profile/controllers/profile_controller.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
// import 'package:mydealer/common/basewidgets/custom_button_widget.dart';
// import 'package:mydealer/features/auth/screens/auth_screen.dart';

// import 'delete_account_warning_dialog.dart';

class SignOutConfirmationDialogWidget extends StatelessWidget {
  final bool isDelete;
  const SignOutConfirmationDialogWidget({Key? key, this.isDelete = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: ColorResources.getBottomSheetColor(context),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Column(mainAxisSize: MainAxisSize.min, children: [
                const SizedBox(height: 30),
                SizedBox(
                  width: 52,
                  height: 52,
                  child: Image.asset(
                      isDelete ? Images.accountDeleteIcon : Images.logOutIcon),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      isDelete
                          ? Dimensions.paddingSizeDefault
                          : Dimensions.paddingSizeLarge,
                      13,
                      isDelete
                          ? Dimensions.paddingSizeDefault
                          : Dimensions.paddingSizeLarge,
                      0),
                  child: Text(
                      isDelete
                          ? getTranslated('want_to_delete_account', context)!
                          : getTranslated('want_to_sign_out', context)!,
                      style: titilliumSemiBold.copyWith(
                          fontSize: isDelete
                              ? Dimensions.fontSizeDefault
                              : Dimensions.fontSizeLarge),
                      textAlign: TextAlign.center),
                ),
                isDelete
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dimensions.paddingSizeLarge,
                            13,
                            Dimensions.paddingSizeLarge,
                            0),
                        child: Text(
                            getTranslated('if_once_you_delete_your', context)!,
                            style: titilliumRegular.copyWith(
                                fontSize: Dimensions.fontSizeSmall),
                            textAlign: TextAlign.center),
                      )
                    : const SizedBox(),
                SizedBox(
                  height: 80,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                        Dimensions.paddingSizeDefault,
                        24,
                        Dimensions.paddingSizeDefault,
                        Dimensions.paddingSizeDefault),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(children: [
                        Expanded(
                          child: CustomButtonWidget(
                            borderRadius: 15,
                            btnTxt: getTranslated('yes', context),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                            fontColor: Colors.white,
                            isColor: true,
                            onTap: () {
                              // if (isDelete) {
                              //   Provider.of<ProfileController>(context,
                              //           listen: false)
                              //       .deleteCustomerAccount(context)
                              //       .then((condition) {
                              //     if (condition.response?.statusCode == null) {
                              //       Navigator.of(context).pop();
                              //       showDialog(
                              //           context: context,
                              //           builder: (_) =>
                              //               const DeleteAccountWarningDialogWidget());
                              //     } else if (condition.response!.statusCode ==
                              //         200) {
                              //       Navigator.pop(context);
                              //       Provider.of<AuthController>(context,
                              //               listen: false)
                              //           .clearSharedData();
                              //       Navigator.of(context).pushAndRemoveUntil(
                              //           MaterialPageRoute(
                              //               builder: (context) =>
                              //                   const AuthScreen()),
                              //           (route) => false);
                              //     }
                              //   });
                              // } else {
                              //   Provider.of<ProductController>(context,
                              //           listen: false)
                              //       .removeCookies();
                              //   Provider.of<AuthController>(context,
                              //           listen: false)
                              //       .clearSharedData();
                              //   Navigator.of(context).pushAndRemoveUntil(
                              //       MaterialPageRoute(
                              //           builder: (context) =>
                              //               const AuthScreen()),
                              //       (route) => false);
                              // }
                            },
                          ),
                        ),
                        const SizedBox(width: Dimensions.paddingSizeSmall),
                        Expanded(
                          child: CustomButtonWidget(
                            borderRadius: 15,
                            btnTxt: getTranslated('no', context),
                            isColor: true,
                            fontColor: ColorResources.getTextColor(context),
                            backgroundColor:
                                Theme.of(context).hintColor.withOpacity(.25),
                            onTap: () => Navigator.pop(context),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ),
              ]),
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Padding(
                    padding:
                        const EdgeInsets.all(Dimensions.paddingSizeDefault),
                    child: SizedBox(
                        width: 18,
                        child: Image.asset(Images.cross,
                            color: ColorResources.getTextColor(context))),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
