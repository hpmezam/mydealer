import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:mydealer/models/profile_info.dart';

class ProfileController with ChangeNotifier {
  ProfileInfoModel? _userInfoModel;
  ProfileInfoModel? get userInfoModel => _userInfoModel;
  int? _userId;
  int? get userId => _userId;
}
