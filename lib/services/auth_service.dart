import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydealer/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String _baseUrl = AppConstants.baseUrl + AppConstants.loginUri;

  Future<Map<String, dynamic>?> login(String username, String password) async {
    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'login': username, 'password': password}),
          )
          .timeout(Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['error'] == '0') {
          await _storeUserCredentials(username, password);
          await _storeApiResponse(data);
          await saveUserData(data);
          String? token = data['token'];
          if (token != null) {
            await _storeToken(token);
          }
          return data;
        } else {
          return data;
        }
      } else {
        return {
          'error': '1',
          'message':
              'Invalid response from server with status code: ${response.statusCode}'
        };
      }
    } catch (e) {
      // Crear y devolver un mapa de error cuando ocurre una excepción
      print('Error making login request: $e');
      return {'error': '1', 'message': 'Connection was refused by the server.'};
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

  Future<bool> saveUserData(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Acceder a la lista de datos y luego al mapa de data_usuario
      List<dynamic> datos = userData['datos'];
      Map<String, dynamic> dataUsuario = datos[0]['data_usuario'];
      // Guardar el nombre en SharedPreferences
      String nombre = dataUsuario['nombre'];
      await prefs.setString('nombre', nombre);
      String login = dataUsuario['login'];
      await prefs.setString('login', login);
      String codruta = dataUsuario['codruta'];
      await prefs.setString('codruta', codruta);
      String codvendedor = dataUsuario['codvendedor'];
      await prefs.setString('codvendedor', codvendedor);
      print(codvendedor);
      return true;
    } catch (e) {
      print('Failed to save user data: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userDataString = prefs.getString('data_usuario');
    if (userDataString != null) {
      return jsonDecode(userDataString) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> _storeToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }
}
