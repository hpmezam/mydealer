import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydealer/models/home_model.dart';
import 'package:mydealer/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  final String baseUrl;

  HomeService(this.baseUrl);

  Future<HomeOrders?> fetchOrders() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codvendedor = prefs.getString('codvendedor');

    if (codvendedor == null) {
      throw Exception('Código de vendedor no disponible');
    }
    try {
      String url = '$baseUrl/AppConstants.numberOrders/$codvendedor';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, parseamos el JSON
        return HomeOrders.fromJson(json.decode(response.body));
      } else {
        // Si la respuesta no fue OK, lanzamos un error
        throw Exception('Failed to load home data');
      }
    } catch (e) {
      // Para manejar errores en la petición o el parsing
      throw Exception('Failed to load home data: $e');
    }
  }

  Future<HomePayments?> fetchPayments() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codvendedor = prefs.getString('codvendedor');

    if (codvendedor == null) {
      throw Exception('Código de vendedor no disponible');
    }

    try {
      String url = '$baseUrl/AppConstants.numberPayments/$codvendedor';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // Si el servidor devuelve una respuesta OK, parseamos el JSON
        return HomePayments.fromJson(json.decode(response.body));
      } else {
        // Si la respuesta no fue OK, lanzamos un error
        throw Exception(
            'Failed to load home data: Status code ${response.statusCode}');
      }
    } catch (e) {
      // Para manejar errores en la petición o el parsing
      throw Exception('Failed to load home data: $e');
    }
  }

  Future<List<HomeOrders>> fetchOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? codvendedor = prefs.getString('codvendedor');
    String baseUrl =
        '${AppConstants.baseUrl}${AppConstants.numberOrders}/$codvendedor';

    try {
      final response = await http.get(Uri.parse(baseUrl));
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> customersJson = data['datos'] ?? [];
      return customersJson.map((json) => HomeOrders.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return [];
    }
  }

  Future<HomePayments> fetchPayment() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? codvendedor = prefs.getString('codvendedor');
  String baseUrl =
      '${AppConstants.baseUrl}${AppConstants.numberOrders}/$codvendedor';

  try {
    final response = await http.get(Uri.parse(baseUrl));
    final data = json.decode(response.body) as Map<String, dynamic>;
    return HomePayments.fromJson(data);
  } catch (e) {
    print('Error fetching customers: $e');
    return HomePayments(
        realizados: 0, pendientes: 0); // Valor por defecto en caso de error
  }
}
}
