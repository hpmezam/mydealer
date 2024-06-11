// class HomeService {
//    static const String _loginUrl = 'http://home.mydealer.ec:8000/api/login'; // Asegúrate de tener la URL correcta aquí

//   Future<void> login(String username, String password) async {
//     final response = await http.post(
//       Uri.parse(_loginUrl),
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({"login": username, "password": password}),
//     );

//     if (response.statusCode == 200) {
//       var data = jsonDecode(response.body);
//       if (data['error'] == '0') {
//         await _saveDataLocally(data['datos'][0]['data_usuario'], data['datos'][0]['token']);
//       } else {
//         throw Exception('Login failed: ${data['mensaje']}');
//       }
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<void> _saveDataLocally(Map<String, dynamic> userData, String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('token', token);
//     await prefs.setString('codvendedor', userData['codvendedor']);
//     await prefs.setString('login', userData['login']);
//     await prefs.setString('codruta', userData['codruta']);
//   }

//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove('token');
//     await prefs.remove('codvendedor');
//     await prefs.remove('login');
//     await prefs.remove('codruta');
//   }
// }