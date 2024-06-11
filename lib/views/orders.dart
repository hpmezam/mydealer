import 'package:flutter/material.dart';

// Mockup de datos para las órdenes
final List<Map<String, dynamic>> orders = [
  {
    "id": "100184",
    "amount": "\$485.00",
    "date": "9 Jan, 2023 10:59 AM",
    "status": "Pending"
  },
  {
    "id": "100180",
    "amount": "\$485.00",
    "date": "9 Jan, 2023 10:56 AM",
    "status": "Pending"
  },
  {
    "id": "100175",
    "amount": "\$485.00",
    "date": "9 Jan, 2023 10:48 AM",
    "status": "Delivered"
  },
];

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
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
          _buildOrderList(context, "Pedidos"),
          _buildOrderList(context, "P Pend"),
          _buildOrderList(context, "Cobros"),
          _buildOrderList(context, "C Pend"),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String filter) {
    List<Map<String, dynamic>> filteredOrders = orders;
    if (filter != "All") {
      filteredOrders =
          orders.where((order) => order['status'] == filter).toList();
    }

    return ListView.builder(
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
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
