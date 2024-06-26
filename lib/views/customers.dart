import 'package:flutter/material.dart';
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/services/customer_service.dart';
import 'package:mydealer/widgets/customer/customer_widget.dart';

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
  bool _isLoading = true;
  List<Customer> allCustomers = [];
  List<Customer> filteredCustomers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    CustomerService customerService = CustomerService();
    try {
      List<Customer> loadedCustomers = await customerService.fetchCustomers();
      setState(() {
        customers = loadedCustomers;
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
            : const Text("Clientes"),
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
          ],
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCustomerList("Rutas"),
                _buildCustomerList("Todos"),
                _buildCustomerList("Agenda"),
              ],
            ),
    );
  }

  Widget _buildCustomerList(String filter) {
    List<Customer> filteredCustomers = _filterLogic(customers, filter);
    return ListView.builder(
      itemCount: filteredCustomers.length,
      itemBuilder: (context, index) =>
          CustomerWidget(customer: filteredCustomers[index]),
    );
  }

  List<Customer> _filterLogic(List<Customer> customers, String filter) {
    switch (filter) {
      case "Rutas":
        return customers
            .where((customer) => customer.limiteCredito > 0)
            .toList();
      case "Todos":
        return customers;
      case "Agenda":
        return customers
            .where((customer) => customer.saldoPendiente > 0)
            .toList();
      default:
        return customers;
    }
  }

  void _filterCustomers(String query) {
    List<Customer> results = customers.where((customer) {
      return customer.nombreCliente.toLowerCase().contains(query.toLowerCase()) ||
          customer.codCliente.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() {
      customers = results;
    });
  }
}
