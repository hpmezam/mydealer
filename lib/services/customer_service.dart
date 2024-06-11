import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/utils/app_constants.dart';

class CustomerService {
  final String baseUrl = AppConstants.baseUrl + AppConstants.curtomerUri;

  Future<List<Customer>> fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<dynamic> customersJson = data['datos'] ?? [];
      return customersJson.map((json) => Customer.fromJson(json)).toList();
    } catch (e) {
      print('Error fetching customers: $e');
      return []; 
    }
  }
}
