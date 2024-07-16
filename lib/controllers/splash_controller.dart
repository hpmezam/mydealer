import 'package:flutter/material.dart';
import 'package:mydealer/models/config_model.dart';

class SplashController extends ChangeNotifier {
  bool _fromSetting = false;
  BaseUrls? _baseUrls;
  bool get fromSetting => _fromSetting;
  bool _firstTimeConnectionCheck = true;
  bool get firstTimeConnectionCheck => _firstTimeConnectionCheck;
  BaseUrls? get baseUrls => _baseUrls;
  
  void setFromSetting(bool isSetting) {
    _fromSetting = isSetting;
  }

  void setFirstTimeConnectionCheck(bool isChecked) {
    _firstTimeConnectionCheck = isChecked;
  }
}
