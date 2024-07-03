import 'package:flutter/material.dart';
import 'package:location/location.dart' as loc; // Alias para location
import 'package:mydealer/views/auth_screen.dart';
// import 'package:mydealer/views/login.dart';
import 'package:permission_handler/permission_handler.dart'
    as perm; // Alias para permission_handler

class CheckGpsPermissions extends StatefulWidget {
  const CheckGpsPermissions({super.key});

  @override
  _CheckGpsPermissionsState createState() => _CheckGpsPermissionsState();
}

class _CheckGpsPermissionsState extends State<CheckGpsPermissions> {
  final loc.Location locationController = loc.Location();

  @override
  void initState() {
    super.initState();
    _checkGpsAndPermissions();
  }

  Future<void> _checkGpsAndPermissions() async {
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;

    // Verifica si el servicio de ubicación está habilitado
    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    }

    // Si el servicio de ubicación está habilitado
    if (serviceEnabled) {
      // Verifica si los permisos están concedidos
      permissionGranted = await locationController.hasPermission();
      if (permissionGranted == loc.PermissionStatus.denied) {
        permissionGranted = await locationController.requestPermission();
        if (permissionGranted == loc.PermissionStatus.deniedForever) {
          // Si los permisos han sido denegados permanentemente, muestra el diálogo para la configuración
          _showSettingsDialog();
          return;
        }
      }

      // Si los permisos están concedidos
      if (permissionGranted == loc.PermissionStatus.granted) {
        // Navega a la pantalla de inicio de sesión
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      } else {
        // Si no se conceden los permisos, muestra un mensaje y vuelve a intentar
        _showPermissionDeniedDialog();
      }
    } else {
      // Si no se habilita el servicio de ubicación, muestra un mensaje y vuelve a intentar
      _showGpsDisabledDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos Denegados'),
        content: const Text(
            'Por favor, concede permisos de ubicación para continuar.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkGpsAndPermissions();
            },
            child: const Text('Intentar de Nuevo'),
          ),
        ],
      ),
    );
  }

  void _showGpsDisabledDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('GPS Deshabilitado'),
        content: const Text('Por favor, habilita el GPS para continuar.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkGpsAndPermissions();
            },
            child: const Text('Intentar de Nuevo'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permisos Denegados'),
        content: const Text(
            'Por favor, habilite los permisos de ubicación desde la configuración de la aplicación.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await perm.openAppSettings(); // Usar el alias perm
              _checkGpsAndPermissions(); // Revisa nuevamente después de regresar de la configuración
            },
            child: const Text('Abrir Configuración'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
