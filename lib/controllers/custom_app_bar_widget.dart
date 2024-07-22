import 'package:flutter/material.dart';
import 'package:mydealer/theme/controllers/theme_controller.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:provider/provider.dart';

class CustomAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String? title;
  final bool isBackButtonExist;
  final Function? onBackPressed;

  const CustomAppBarWidget({
    Key? key,
    required this.title,
    this.isBackButtonExist = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color:
                Provider.of<ThemeController>(context, listen: false).darkTheme
                    ? Theme.of(context).primaryColor.withOpacity(0)
                    : Theme.of(context).primaryColor.withOpacity(.10),
            offset: const Offset(0, 2.0),
            blurRadius: 4.0,
          )
        ]),
        child: AppBar(
          shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
          titleSpacing: 0,
          title: Text(title!,
              style: titilliumSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeLarge,
                  color: Theme.of(context).textTheme.bodyLarge!.color)),
          centerTitle: true,
          leading: isBackButtonExist
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios,
                      size: Dimensions.iconSizeDefault),
                  color: Theme.of(context).textTheme.bodyLarge!.color,
                  onPressed: () => onBackPressed != null
                      ? onBackPressed!()
                      : Navigator.pop(context))
              : IconButton(
                  icon: Image.asset(
                    Images.logo,
                    scale: 5,
                  ),
                  onPressed: () {},
                ),
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite, 50);
}
