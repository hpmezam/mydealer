import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mydealer/controllers/custom_snackbar_widget.dart';
import 'package:mydealer/dataBaseHelper/api_response.dart';
import 'package:mydealer/main.dart';
import 'package:mydealer/views/auth_screen.dart';

class ApiChecker {
  static void checkApi(ApiResponse apiResponse) {
    if (apiResponse.error.toString() ==
        'Failed to load data - status code: 401') {
      Navigator.of(Get.context!).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false);
    } else {
      String? errorMessage;
      if (apiResponse.error is String) {
        errorMessage = apiResponse.error.toString();
      } else {
        errorMessage = apiResponse.error.errors[0].message;
      }
      if (kDebugMode) {
        print(errorMessage);
      }
      if (errorMessage != '') {
        showCustomSnackBarWidget(errorMessage, Get.context!,
            sanckBarType: SnackBarType.error);
      }
    }
  }
}
