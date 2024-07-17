import 'package:flutter/material.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/models/allCustomers.dart';
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/models/customersrutas.dart';
import 'package:mydealer/services/customer_service.dart';
import 'package:mydealer/widgets/customer/customer_rutas_widget.dart';
import 'package:mydealer/widgets/customer/customer_widget.dart';
import 'package:mydealer/widgets/customer/gps_widget.dart';
import 'package:mydealer/utils/styles.dart';

class CustomersPage extends StatefulWidget {
  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Customer> customers = [];
  List<CustomerRutas> customersRutas = [];
  bool _isLoading = true;
  List<AllCustomers> allCustomers = [];
  List<Customer> filteredCustomers = [];
  List<CustomerRutas> filteredCustomersRutas = [];
  List<AllCustomers> filteredAllCustomers = [];

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 4, vsync: this); // Actualizado a 4 pestañas
    _loadCustomersRutas();
    _loadCustomers();
    _loadAllCustomers();
  }

  Future<void> _loadAllCustomers() async {
    CustomerService customerService = CustomerService();
    try {
      List<AllCustomers> loadedAllCustomers =
          await customerService.fetchAllCustomers();
      setState(() {
        allCustomers = loadedAllCustomers;
        filteredAllCustomers = loadedAllCustomers;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load customers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCustomers() async {
    CustomerService customerService = CustomerService();
    try {
      List<Customer> loadedCustomers = await customerService.fetchCustomers();
      setState(() {
        customers = loadedCustomers;
        filteredCustomers = loadedCustomers;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load customers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadCustomersRutas() async {
    CustomerService customerService = CustomerService();
    try {
      List<CustomerRutas> loadedCustomersRutas =
          await customerService.customerRutas();
      setState(() {
        customersRutas = loadedCustomersRutas;
        filteredCustomersRutas = loadedCustomersRutas;
        _isLoading = false;
      });
    } catch (e) {
      print('Failed to load customers: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Buscar clientes...',
                  border: InputBorder.none,
                ),
                onChanged: (value) => _filterCustomers(value),
              )
            : const Text(
                "Clientes",
                style: TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  _filterCustomers('');
                }
                _isSearching = !_isSearching;
              });
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Rutas"),
            Tab(text: "Todos"),
            Tab(text: "Agenda"),
            Tab(text: "GPS"), // Nueva pestaña para GPS
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerRutasList(),
                _buildCustomerList(),
                _buildAgendaList(),
                GPSWidget(rutas: customersRutas), // Nueva vista para GPS
              ],
            ),
    );
  }

  Widget _buildCustomerList() {
    return filteredCustomers.isEmpty
        ? Center(
            child: Text(
            getTranslated('messageRecords', context)!,
            style: robotoRegular.copyWith(
              color: Colors.blue,
            ),
          ))
        : ListView.builder(
            itemCount: filteredCustomers.length,
            itemBuilder: (context, index) =>
                CustomerWidget(customer: filteredCustomers[index]),
          );
  }

  Widget _buildAgendaList() {
    return Center(
      child: Text(
        getTranslated('diaryNotAvailable', context)!,
        style: robotoRegular.copyWith(
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _buildCustomerRutasList() {
    return filteredCustomersRutas.isEmpty
        ? Center(
            child: Text(
            getTranslated('messageRecords', context)!,
            style: robotoRegular.copyWith(
              color: Colors.blue,
            ),
          ))
        : ListView.builder(
            itemCount: filteredCustomersRutas.length,
            itemBuilder: (context, index) => CustomerRutasWidget(
                customerRutas: filteredCustomersRutas[index]),
          );
  }

  void _filterCustomers(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredCustomers = customers;
        filteredCustomersRutas = customersRutas;
        filteredAllCustomers = allCustomers;
      });
    } else {
      setState(() {
        filteredCustomers = customers.where((customer) {
          return customer.nombre.toLowerCase().contains(query.toLowerCase()) ||
              customer.codCliente.toLowerCase().contains(query.toLowerCase());
        }).toList();

        filteredCustomersRutas = customersRutas.where((customerRutas) {
          return customerRutas.nombreCliente
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              customerRutas.codCliente
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
        filteredAllCustomers = allCustomers.where((allCustomers) {
          return allCustomers.nombrecomercial
                  .toLowerCase()
                  .contains(query.toLowerCase()) ||
              allCustomers.codcliente
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      });
    }
  }
}
