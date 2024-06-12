import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  List<Order> _orders = [];
  bool _loading = false;

  Future<void> _fetchOrders() async {
    setState(() {
      _loading = true;
    });

    final String formattedStartDate =
        "${_startDate.toIso8601String().split('T')[0]}";
    final String formattedEndDate =
        "${_endDate.toIso8601String().split('T')[0]}";
    final String url =
        'http://home.mydealer.ec:8000/api/pedidosCompleto/ve001/$formattedStartDate/$formattedEndDate';

    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['datos'] != null && data['datos'].isNotEmpty) {
          setState(() {
            _orders =
                (data['datos'] as List).map((i) => Order.fromJson(i)).toList();
            _loading = false;
          });
        } else {
          print('No data found for the given date range.');
          setState(() {
            _orders = [];
            _loading = false;
          });
        }
      } else {
        print('Failed to load orders, status code: ${response.statusCode}');
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

  void _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta de Pedidos'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Desde: ${_startDate.toString().substring(0, 10)}'),
              onTap: () => _selectDate(context, true),
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: Text('Hasta: ${_endDate.toString().substring(0, 10)}'),
              onTap: () => _selectDate(context, false),
            ),
            ElevatedButton(
              onPressed: _fetchOrders,
              child: Text('Mostrar'),
            ),
            _loading ? CircularProgressIndicator() : _buildOrderTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTable() {
    return DataTable(
      columns: [
        DataColumn(label: Text('Orden')),
        DataColumn(label: Text('Cliente')),
        DataColumn(label: Text('Fecha')),
      ],
      rows: _orders
          .map((order) => DataRow(cells: [
                DataCell(Text(order.srorden.toString())),
                DataCell(Text(order.codcliente)),
                DataCell(Text(order.fecha)),
              ]))
          .toList(),
    );
  }
}

class Order {
  final int srorden;
  final String codcliente;
  final String fecha;

  Order({required this.srorden, required this.codcliente, required this.fecha});

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      srorden: json['srorden'],
      codcliente: json['codcliente'],
      fecha: json['fecha'],
    );
  }
}
