import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MaterialApp(
    home: OrdersPage(),
  ));
}

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
    _tabController?.addListener(_handleTabSelection);
    _loadVendedorID();
  }

  void _handleTabSelection() {
    if (_tabController!.index == 1) {
      Future<void> _loadVendedorID_estado() async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? vendedorID = prefs.getString('codvendedor');
        if (vendedorID != null) {
          _fetchPendingOrders(vendedorID, 'N');
        } else {
          print('No se encontró el codvendedor en SharedPreferences');
        }
      }
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_handleTabSelection);
    _tabController?.dispose();
    super.dispose();
  }

  Future<void> _loadVendedorID() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? vendedorID = prefs.getString('codvendedor');
    if (vendedorID != null) {
      _fetchOrders(vendedorID);
    } else {
      print('No se encontró el codvendedor en SharedPreferences');
    }
  }

  Future<void> _fetchOrders(String vendedorID) async {
    final String url =
        'http://home.mydealer.ec:8000/api/pedidosTodos/$vendedorID';
    print('Fetching orders from: $url');

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Orders data: $data');
        setState(() {
          _orders = (data['datos'] as List).map((orderData) {
            return {
              "id": orderData['srorden'].toString(),
              "client": orderData['cliente_nombre'],
              "date": orderData['fecha'],
              "total": orderData['total'] != null
                  ? '\$${orderData['total']}'
                  : '\$0.00',
              "details": orderData['detalles'],
              "estado": orderData['estado'],
            };
          }).toList();
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

  Future<void> _fetchPendingOrders(String vendedorID, String estado) async {
    final String url =
        'http://home.mydealer.ec:8000/api/pedidosEstado/$vendedorID/$estado';
    print('Fetching pending orders from: $url');

    setState(() {
      _loading = true;
    });

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Pending orders data: $data');
        setState(() {
          _orders = (data['datos'] as List).map((orderData) {
            return {
              "id": orderData['srorden'].toString(),
              "client": orderData['cliente_nombre'],
              "date": orderData['fecha'],
              "total": orderData['total'] != null
                  ? '\$${orderData['total']}'
                  : '\$0.00',
              "details": orderData['detalles'],
              "estado": orderData['estado'],
            };
          }).toList();
          _loading = false;
        });
      } else {
        print(
            'Failed to fetch pending orders, status code: ${response.statusCode}');
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print('Error fetching pending orders: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  void _showOrderDetails(BuildContext context, Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Detalles del Pedido"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Cliente: ${order['client']}"),
                Text("Fecha: ${order['date']}"),
                Text("Total: ${order['total']}"),
                //Divider(),
                Text("Detalles:"),
                Table(
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: IntrinsicColumnWidth(),
                    2: IntrinsicColumnWidth(),
                    3: IntrinsicColumnWidth(),
                    4: IntrinsicColumnWidth(),
                  },
                  border: TableBorder.all(),
                  children: [
                    TableRow(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Cant',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Precio',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Dcto',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Impto',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Subtotal',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ]),
                    ...((order['details'] as List).map((detail) {
                      return TableRow(children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(detail['cantidad'].toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${detail['precio']}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${detail['descuento']}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${detail['impuesto']}"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("\$${detail['subtotal']}"),
                        ),
                      ]);
                    }).toList()),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Cerrar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
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
          Center(
            child: _loading
                ? CircularProgressIndicator()
                : _buildPendingOrdersList(context),
          ),
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
        return _buildOrderItem(context, order);
      },
    );
  }

  Widget _buildPendingOrdersList(BuildContext context) {
    // Filtrar los pedidos con estado "N" para mostrar solo los pendientes
    List<Map<String, dynamic>> pendingOrders =
        _orders.where((order) => order['estado'] == 'N').toList();

    return ListView.builder(
      itemCount: pendingOrders.length,
      itemBuilder: (context, index) {
        final order = pendingOrders[index];
        return _buildOrderItem(context, order);
      },
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> order) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(Icons.receipt, color: Theme.of(context).primaryColor),
        title: Text("Cliente: ${order['client']}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Fecha: ${order['date']}"),
            Text("Total: ${order['total']}"),
          ],
        ),
        onTap: () => _showOrderDetails(context, order),
      ),
    );
  }
}
