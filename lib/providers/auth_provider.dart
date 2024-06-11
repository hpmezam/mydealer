// // import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/auth_service.dart';

// class AuthProvider with ChangeNotifier {
//   String? _username;
//   String? _mensaje;
//   String? _password;
//   Map<String, dynamic>? _data;

//   String? get mensaje => _mensaje;
//   String? get username => _username;
//   String? get password => _password;
//   Map<String, dynamic>? get data => _data;

//   Future<void> loadUserCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     _username = prefs.getString('username');
//     _password = prefs.getString('password');
//     // _data = await _getStoredApiResponse();
//     notifyListeners();
//   }

//   Future<void> login(String username, String password) async {
//     final authService = AuthService();
//     final result = await authService.login(username, password);
//     if (result != null && result['error'] == "0") {
//       _username = username;
//       _password = password;
//       _mensaje = result['mensaje'];
//       _data = result['datos'][0];
//       await _storeUserCredentials(username, password);
//       notifyListeners();
//     } else {
//       _mensaje = result?['mensaje'];
//       _data = null;
//       notifyListeners();
//     }
//   }

//   Future<void> logout() async {
//     _username = null;
//     _password = null;
//     _mensaje = null;
//     _data = null;
//     await _clearUserCredentials();
//     notifyListeners();
//   }

//   Future<void> _storeUserCredentials(String username, String password) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('username', username);
//     await prefs.setString('password', password);
//   }

//   Future<void> _clearUserCredentials() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('username');
//     await prefs.remove('password');
//   }

// //   String? _token;
// //   String? _mensaje;
// //   Map<String, dynamic>? _data; // Agregar variable para almacenar el arreglo completo
// //   final AuthService _authService = AuthService();

// //   String? get token => _token;
// //   String? get mensaje => _mensaje;
// //   Map<String, dynamic>? get data => _data; // Agregar getter para el arreglo completo

// //   Future<void> login(String username, String password) async {
// //     Map<String, dynamic>? responseData = await _authService.login(username, password);
// //     if (responseData != null) {
// //       _token = responseData['token'];
// //       _mensaje = responseData['mensaje'];
// //       _data = responseData; // Almacenar el arreglo completo
// //     }
// //     notifyListeners();
// //   }

// //   bool get isAuthenticated => _token != null;
// }
