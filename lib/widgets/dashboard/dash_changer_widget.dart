import 'package:flutter/material.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/images.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:mydealer/views/customers.dart';

class DashChangerWidget extends StatelessWidget {
  const DashChangerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        SectionItemWidget(
          icon: Images.address,
          title: 'routes',
          number: '5',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CustomersPage()));
          },
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        SectionItemWidget(
          icon: Images.orderNote,
          title: 'diary',
          number: '3',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CustomersPage()));
          },
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
        SectionItemWidget(
          icon: Images.destinationMarker,
          title: 'gps',
          number: '8',
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => CustomersPage()));
          },
        ),
        const SizedBox(
          height: Dimensions.paddingSizeExtraSmall,
        ),
      ],
    );
  }
}

class SectionItemWidget extends StatelessWidget {
  final String? icon;
  final String? title;
  final String? number;
  final Function? onTap;
  const SectionItemWidget(
      {Key? key, this.onTap, this.icon, this.title, this.number})
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
                  child: Text(
                    '$number',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.iconSizeDefault,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
