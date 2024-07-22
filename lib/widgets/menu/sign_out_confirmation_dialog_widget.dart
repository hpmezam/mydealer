import 'package:flutter/material.dart';
import 'package:mydealer/services/auth_service.dart';
import 'package:mydealer/views/auth_screen.dart';
import 'package:mydealer/widgets/menu/custom_button_widget.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';

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
                            onTap: () async {
                              AuthService authService = AuthService();
                              // Eliminar el token local
                              await authService.clearToken();
                              // Navegar al login y eliminar todas las rutas anteriores
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AuthScreen()),
                                (route) => false,
                              );
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
