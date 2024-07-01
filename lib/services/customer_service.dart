import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mydealer/dataBaseHelper/dbh_customer.dart';
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerService {
  final String baseUrl = AppConstants.baseUrl + AppConstants.curtomerUri;

  Future<List<Customer>> fetchCustomers() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // No hay conexión a Internet, cargar datos de la base de datos local
      return await _loadCustomersFromDB();
    } else {
      // Hay conexión a Internet, cargar datos de la API
      return await _customerAPI();
    }
  }

  Future<List<Customer>> _customerAPI() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? codVendedor = prefs.getString('codvendedor');
      final response = await http.get(Uri.parse(baseUrl + codVendedor!));

      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> customersJson = data['datos'] ?? [];
      List<Customer> customers =
          customersJson.map((json) => Customer.fromJson(json)).toList();

      return customers;
    } catch (e) {
      print('Error fetching customers from API: $e');
      return [];
    }
  }

  Future<List<Customer>> _loadCustomersFromDB() async {
    final dbHelper = DatabaseHelperCustomer();
    return dbHelper
        .getCustomers(); // Asegúrate de tener este método en DatabaseHelper que devuelve una lista de Customer
  }
}
