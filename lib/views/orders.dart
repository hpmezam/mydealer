import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<Map<String, dynamic>> _orders = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    //_fetchVendedorID();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Future<void> _fetchVendedorID() async {
  //   setState(() {
  //     _loading = true;
  //   });

  //   final String url = 'http://home.mydealer.ec:8000/api/vendedorLogueado';
  //   print('Fetching vendedor ID from: $url');

  //   try {
  //     final response = await http.get(Uri.parse(url));
  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final String vendedorID = data['vendedorID'].toString();
  //       print('Vendedor ID: $vendedorID');
  //       _fetchOrders(vendedorID);
  //     } else {
  //       print(
  //           'Failed to fetch vendedor ID, status code: ${response.statusCode}');
  //       setState(() {
  //         _loading = false;
  //       });
  //     }
  //   } catch (e) {
  //     print('Error fetching vendedor ID: $e');
  //     setState(() {
  //       _loading = false;
  //     });
  //   }
  // }

  Future<void> _fetchOrders(String vendedorID) async {
    final String url =
        'http://home.mydealer.ec:8000/api/pedidosCompleto/$vendedorID///';
    print('Fetching orders from: $url');

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Orders data: $data');
        setState(() {
          _orders = (data['datos'] as List)
              .map((i) => {
                    "id": i['srorden'].toString(),
                    "amount": "\$${i['total']}",
                    "date": i['fecha'],
                    "status": i['estado'],
                  })
              .toList();
          _loading = false;
        });
      } else {
        print('Failed to fetch orders, status code: ${response.statusCode}');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching orders: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Pedidos"),
            Tab(text: "P Pend"),
            Tab(text: "Cobros"),
            Tab(text: "C Pend"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _loading
              ? Center(child: CircularProgressIndicator())
              : _buildOrderList(context),
          Center(child: Text('P Pend')),
          Center(child: Text('Cobros')),
          Center(child: Text('C Pend')),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context) {
    return ListView.builder(
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return _buildOrderItem(order);
      },
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.receipt, color: Theme.of(context).primaryColor),
        title: Text("Order# ${order['id']}"),
        subtitle: Text("${order['date']}"),
        trailing: Text(order['amount'],
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrdersPage(),
  ));
}
