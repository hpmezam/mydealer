import 'package:flutter/material.dart';
import 'package:mydealer/utils/color_resources.dart';
import 'package:mydealer/utils/dimensions.dart';
import 'package:mydealer/widgets/download/download_widget.dart';
import 'package:mydealer/widgets/profile/profile_widget.dart';

enum MenuOption { profile, language, downloads, logout, version }

void showCustomMenu(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: ColorResources.getHomeBg(context),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: Theme.of(context).hintColor,
                size: Dimensions.iconSizeLarge,
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeVeryTiny),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeDefault,
              ),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: <Widget>[
                  _buildMenuItem(
                      context, Icons.account_circle, "Profile", Colors.blue),
                  _buildMenuItem(
                      context, Icons.language, "Language", Colors.blue),
                  _buildMenuItem(
                      context, Icons.download, "Downloads", Colors.blue),
                  _buildMenuItem(
                      context, Icons.exit_to_app, "Logout", Colors.red),
                  _buildMenuItem(
                      context, Icons.info_outline, "Version", Colors.purple),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildMenuItem(
    BuildContext context, IconData icon, String label, Color color) {
  return InkWell(
    onTap: () {
      Navigator.pop(context); // Close the menu before navigating
      switch (label) {
        case "Profile":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
          break;
        case "Language":
          // Implementa lo que debe suceder para "Language"
          break;
        case "Downloads":
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DownloadPage()),
          );
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
        Container(
          padding: const EdgeInsets.all(20.0), // Aumenta el padding aquí
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10), // Borde redondeado
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Icon(icon, size: 30, color: color),
        ),
        const SizedBox(height: 8),
        Text(label, textAlign: TextAlign.center),
      ],
    ),
  );
}
