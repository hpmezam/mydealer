import 'package:flutter/material.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/styles.dart';

class CustomButtonWidget extends StatelessWidget {
  final Function? onTap;
  final String? btnTxt;
  final bool isColor;
  final Color? backgroundColor;
  final Color? fontColor;
  final double? borderRadius;
  const CustomButtonWidget(
      {Key? key,
      this.onTap,
      required this.btnTxt,
      this.backgroundColor,
      this.isColor = false,
      this.fontColor,
      this.borderRadius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap as void Function()?,
      child: Container(
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isColor
                ? backgroundColor
                : backgroundColor ?? Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(borderRadius != null
                ? borderRadius!
                : Dimensions.paddingSizeExtraSmall)),
        child: Text(btnTxt!,
            style: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeDefault,
              color: fontColor ?? Colors.white,
            )),
      ),
    );
  }
}
