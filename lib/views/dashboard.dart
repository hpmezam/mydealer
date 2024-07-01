import 'package:flutter/material.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/utils/styles.dart';
import 'package:mydealer/views/customers.dart';
import 'package:mydealer/views/home.dart';
import 'package:mydealer/views/management.dart';
import 'package:mydealer/views/menu.dart';
import 'package:mydealer/views/orders.dart';
import 'package:mydealer/widgets/menu/menu_widget.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Lista de widgets para las páginas
  final List<Widget> _widgetOptions = [
    HomePage(),
    CustomersPage(),
    OrdersPage(),
    ManagementPage(),
    MenuPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'Pedidos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Gestión',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                showCustomMenu(context);
              },
            ),
            label: 'Menu',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: ColorResources.hintTextColor,
        selectedFontSize: Dimensions.fontSizeSmall,
        unselectedFontSize: Dimensions.fontSizeSmall,
        selectedLabelStyle: robotoBold,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}
