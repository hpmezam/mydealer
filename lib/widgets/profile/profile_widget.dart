import 'package:flutter/material.dart';
// import 'package:flutter_switch/flutter_switch.dart'; // Necesitarás añadir este paquete en tu pubspec.yaml para el switch de modo oscuro

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // bool isDarkMode = false;

    return Scaffold(
      appBar: AppBar(
        title: Text("My Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                        "https://via.placeholder.com/150"), // Cambia por una imagen real del usuario
                  ),
                  ListTile(
                    leading: Icon(Icons.account_balance_wallet),
                    title: Text("Bank Info"),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, dynamic value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(value.toString(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
      ],
    );
  }
}
