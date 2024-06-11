import 'package:flutter/material.dart';
import 'package:mydealer/widgets/download/dowload_widge.dart';
import 'package:mydealer/widgets/profile/profile_widget.dart';

enum MenuOption { profile, language, logout, version }

void showCustomMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return GridView.count(
        crossAxisCount: 3,
        children: <Widget>[
          _buildMenuItem(context, Icons.account_circle, "Perfil"),
          _buildMenuItem(context, Icons.language, "Idioma"),
          _buildMenuItem(context, Icons.download, "Descargas"),
          _buildMenuItem(context, Icons.exit_to_app, "Salir"),
          _buildMenuItem(context, Icons.info_outline, "Versión"),
        ],
      );
    },
  );
}

Widget _buildMenuItem(BuildContext context, IconData icon, String label) {
  return InkWell(
    onTap: () {
      switch (label) {
        case "Perfil":
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ProfileScreen()));
          break;
        case "Language":
          // Implementa lo que debe suceder para "Language"
          break;
        case "Descargas":
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DownloadPage()));
          break;
        case "Logout":
          // Implementa lo que debe suceder para "Logout"
          break;
        case "Version":
          // Implementa lo que debe suceder para "Version"
          break;
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 50),
        Text(label),
      ],
    ),
  );
}
