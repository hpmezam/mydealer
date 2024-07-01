import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/theme/controllers/theme_controller.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:mydealer/views/settings.dart';
import 'package:mydealer/widgets/menu/sign_out_confirmation_dialog_widget.dart';
import 'package:provider/provider.dart';
import 'package:mydealer/widgets/profile/custom_dialog_widget.dart';

class ThemeChangerWidget extends StatelessWidget {
  const ThemeChangerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: ThemeShadow.getShadow(context)),
          height: Dimensions.profileCardHeight,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: Dimensions.iconSizeDefault,
                  height: Dimensions.iconSizeDefault,
                  child: Image.asset(Images.dark),
                ),
                const SizedBox(
                  width: Dimensions.paddingSizeSmall,
                ),
                Text(
                  !Provider.of<ThemeController>(context).darkTheme
                      ? '${getTranslated('dark_theme', context)}'
                      : '${getTranslated('light_theme', context)}',
                  style: robotoRegular.copyWith(
                      fontSize: Dimensions.fontSizeDefault),
                ),
                const Expanded(child: SizedBox()),
                FlutterSwitch(
                  width: 50.0,
                  height: 28.0,
                  toggleSize: 20.0,
                  value: !Provider.of<ThemeController>(context).darkTheme,
                  borderRadius: 20.0,
                  activeColor: Theme.of(context).primaryColor.withOpacity(.5),
                  padding: 3.0,
                  activeIcon: Image.asset(Images.darkMode,
                      width: 30, height: 30, fit: BoxFit.scaleDown),
                  inactiveIcon: Image.asset(
                    Images.lightMode,
                    width: 30,
                    height: 30,
                    fit: BoxFit.scaleDown,
                  ),
                  onToggle: (bool isActive) =>
                      Provider.of<ThemeController>(context, listen: false)
                          .toggleTheme(),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        SectionItemWidget(
          icon: Images.editProfile,
          title: 'settings',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => SettingsPage()));
          },
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        SectionItemWidget(
          icon: Images.delete,
          title: 'delete_account',
          onTap: () => showAnimatedDialogWidget(
              context, const SignOutConfirmationDialogWidget(isDelete: true),
              isFlip: true),
        )
      ],
    );
  }
}

class SectionItemWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final Function? onTap;
  const SectionItemWidget({Key? key, this.onTap, this.icon, this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: ThemeShadow.getShadow(context)),
        height: Dimensions.profileCardHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Row(
            children: [
              SizedBox(
                  width: Dimensions.iconSizeDefault,
                  height: Dimensions.iconSizeDefault,
                  child: Image.asset(icon!)),
              const SizedBox(
                width: Dimensions.paddingSizeSmall,
              ),
              Expanded(
                child: Text(getTranslated(title, context)!,
                    style: robotoRegular.copyWith(
                        fontSize: Dimensions.fontSizeDefault)),
              ),
              SizedBox(
                  width: Dimensions.iconSizeDefault,
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: Theme.of(context).primaryColor,
                    size: Dimensions.iconSizeDefault,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
