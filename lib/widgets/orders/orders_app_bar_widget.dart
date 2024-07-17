import 'package:flutter/material.dart';
import 'package:mydealer/theme/controllers/theme_controller.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:provider/provider.dart';

class OrdersAppBarWidget extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final TabController tabController;

  const OrdersAppBarWidget({
    Key? key,
    required this.title,
    required this.tabController,
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
            blurRadius: 2.0,
          )
        ]),
        child: AppBar(
          shadowColor: Theme.of(context).primaryColor.withOpacity(.5),
          titleSpacing: 0,
          title: Text(
            title,
            style: titilliumSemiBold.copyWith(
              fontSize: Dimensions.fontSizeLarge,
              color: Theme.of(context).textTheme.bodyLarge!.color,
            ),
          ),
          centerTitle: true,
          bottom: TabBar(
            controller: tabController,
            tabs: const [
              Tab(text: "Pedidos"),
              Tab(text: "P Pend"),
              Tab(text: "Cobros"),
              Tab(text: "C Pend"),
            ],
          ),
          backgroundColor: Theme.of(context).highlightColor,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size(double.maxFinite,
      100); // Ajusta el tamaño preferido para incluir el TabBar
}
