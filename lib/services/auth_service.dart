import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydealer/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthService {

  final String _baseUrl =AppConstants.baseUrl + AppConstants.loginUri;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'login': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      if (data['error'] == '0') {
        await _storeUserCredentials(username, password);
        await _storeApiResponse(data);
        return data;
      } else {
        return data;
      }
    } else {
      return null;
    }
  }

  Future<void> _storeUserCredentials(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('password', password);
  }

  Future<void> _storeApiResponse(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('apiResponse', jsonEncode(data));
  }

  Future<Map<String, dynamic>?> getStoredApiResponse() async {
    final prefs = await SharedPreferences.getInstance();
    final String? apiResponseString = prefs.getString('apiResponse');
    if (apiResponseString != null) {
      return jsonDecode(apiResponseString) as Map<String, dynamic>;
    }
    return null;
  }
}