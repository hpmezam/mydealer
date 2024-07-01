import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mydealer/dataBaseHelper/dbh_vendedor.dart';
import 'package:mydealer/services/auth_service.dart';
import 'package:mydealer/views/dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  void _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Por favor, complete ambos campos'),
      ));
      return;
    }
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _loginOffline();
      return;
    }
    _loginOnline();
  }

  void _loginOnline() async {
    try {
      setState(() => _isLoading = true); //Activar el indicador de carga

      Map<String, dynamic>? loginResponse = await _authService.login(
          _emailController.text, _passwordController.text);
      setState(() => _isLoading = false); // Ocultar indicador de carga

      if (loginResponse != null && loginResponse['error'] == '0') {
        Map<String, dynamic> userData =
            loginResponse['datos'][0]['data_usuario'];
        saveUserData(userData);

        print("Datos guardados");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardScreen()),
        );
      } else {
        String errorMessage = loginResponse != null
            ? loginResponse['message'] ?? 'Login fallido'
            : 'Error en la conexión';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
        ));
      }
    } catch (e) {
      setState(() => _isLoading =
          false); // Asegurar que el indicador de carga se desactive
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('No se pudo conectar al servidor. Intente más tarde.'),
            backgroundColor: Colors.redAccent),
      );
      print('Login error: $e');
    }
  }

  void _loginOffline() async {

    var localUser =
        await DatabaseHelper().getUserByUsername(_emailController.text);
        //FALTA QUE EN LA API ME TRAIGA EL PASSWORD TAMBIEN

    if (localUser != null ) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se encontraron credenciales locales válidas.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  void saveUserData(Map<String, dynamic> userData) async {
    await DatabaseHelper().saveUser(userData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'MYDE@LER',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(color: Colors.redAccent),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: TextStyle(color: Colors.redAccent),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: _isLoading ? null : _login,
              child: _isLoading ? CircularProgressIndicator() : Text('Login'),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
