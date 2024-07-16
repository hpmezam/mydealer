import 'package:flutter/material.dart';
import 'package:mydealer/main.dart';
import 'custom_toast.dart';

enum SnackBarType {
  error,
  warning,
  success,
}

void showCustomSnackBarWidget(String? message, BuildContext? context,
    {bool isError = true,
    bool isToaster = false,
    SnackBarType sanckBarType = SnackBarType.success}) {
  final scaffold = ScaffoldMessenger.of(Get.context!);
  scaffold.showSnackBar(
    SnackBar(
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      content: CustomToast(text: message ?? '', sanckBarType: sanckBarType),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
    ),
  );
}
