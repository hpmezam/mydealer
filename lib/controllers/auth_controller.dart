import 'package:flutter/material.dart';
import 'package:mydealer/services/auth_service.dart';
import 'package:mydealer/views/dashboard.dart';

class AuthController extends ChangeNotifier {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;
  bool get isLoading => _isLoading;
  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  Future<void> login(BuildContext context) async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Por favor, complete ambos campos'),
      ));
      return;
    }

    try {
      _setLoading(true); // Activar el indicador de carga

      Map<String, dynamic>? loginResponse = await _authService.login(
          _emailController.text, _passwordController.text);

      _setLoading(false); // Ocultar indicador de carga

      if (loginResponse != null && loginResponse['error'] == '0') {
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
      _setLoading(false); // Asegurar que el indicador de carga se desactive
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo conectar al servidor. Intente más tarde.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      print('Login error: $e');
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
