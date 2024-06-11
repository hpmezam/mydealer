import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Order {
  final int srorden;
  final String codcliente;
  final String fecha;
  final String fechaweb;
  final String codformaenvio;
  final String codformapago;
  final String idorden;
  final String codvendedor;
  final String coddireccionenvio;
  final String numordenerp;
  final String observaciones;
  final String loginusuario;
  final String referencia1;
  final String referencia2;
  final double subtotal;
  final double descuento;
  final double impuesto;
  final double total;
  final String estado;
  final String origen;
  final String errorws;
  final String fechamovil;
  final String fechaenvioerp;

  Order({
    required this.srorden,
    required this.codcliente,
    required this.fecha,
    required this.fechaweb,
    required this.codformaenvio,
    required this.codformapago,
    required this.idorden,
    required this.codvendedor,
    required this.coddireccionenvio,
    required this.numordenerp,
    required this.observaciones,
    required this.loginusuario,
    required this.referencia1,
    required this.referencia2,
    required this.subtotal,
    required this.descuento,
    required this.impuesto,
    required this.total,
    required this.estado,
    required this.origen,
    required this.errorws,
    required this.fechamovil,
    required this.fechaenvioerp,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      srorden: json['srorden'],
      codcliente: json['codcliente'],
      fecha: json['fecha'],
      fechaweb: json['fechaweb'],
      codformaenvio: json['codformaenvio'],
      codformapago: json['codformapago'],
      idorden: json['idorden'],
      codvendedor: json['codvendedor'],
      coddireccionenvio: json['coddireccionenvio'],
      numordenerp: json['numordenerp'],
      observaciones: json['observaciones'],
      loginusuario: json['loginusuario'],
      referencia1: json['referencia1'],
      referencia2: json['referencia2'],
      subtotal: json['subtotal'].toDouble(),
      descuento: json['descuento'].toDouble(),
      impuesto: json['impuesto'].toDouble(),
      total: json['total'].toDouble(),
      estado: json['estado'],
      origen: json['origen'],
      errorws: json['errorws'],
      fechamovil: json['fechamovil'],
      fechaenvioerp: json['fechaenvioerp'],
    );
  }
}

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  List<Order> _orders = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _startDate = DateTime.now();
    _endDate = DateTime.now();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _loading = true;
    });

    final String startDate = _startDate?.toIso8601String().split('T')[0] ?? '';
    final String endDate = _endDate?.toIso8601String().split('T')[0] ?? '';
    final String url =
        'http://home.mydealer.ec:8000/api/pedidosRangoFecha/ve001/$startDate/$endDate';

    try {
      print('Fetching data from: $url'); // Mensaje de depuración
      final response = await http.get(Uri.parse(url));
      print(
          'Status code: ${response.statusCode}'); // Imprimir el código de estado
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Response data: $data'); // Imprimir los datos de la respuesta
        setState(() {
          _orders =
              (data['datos'] as List).map((i) => Order.fromJson(i)).toList();
          _loading = false;
        });
        print('Orders: $_orders'); // Imprimir los pedidos obtenidos
      } else {
        print('Failed to load orders, status code: ${response.statusCode}');
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStart ? _startDate! : _endDate!,
      firstDate: DateTime(2020, 1),
      lastDate: DateTime(2024, 12),
    );
    if (picked != null && picked != (isStart ? _startDate : _endDate)) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _fetchOrders();
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
            _buildFilters(),
            _loading ? CircularProgressIndicator() : _buildOrderTable(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilters() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Desde: ${_startDate?.toString().substring(0, 10)}'),
            onTap: () => _selectDate(context, true),
          ),
          ListTile(
            leading: Icon(Icons.calendar_today),
            title: Text('Hasta: ${_endDate?.toString().substring(0, 10)}'),
            onTap: () => _selectDate(context, false),
          ),
          ElevatedButton(
            onPressed: _fetchOrders,
            child: Text('Mostrar'),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text('Orden')),
          DataColumn(label: Text('Cliente')),
          DataColumn(label: Text('Fecha')),
          DataColumn(label: Text('Fecha Web')),
          DataColumn(label: Text('Forma Envío')),
          DataColumn(label: Text('Forma Pago')),
          DataColumn(label: Text('ID Orden')),
          DataColumn(label: Text('Vendedor')),
          DataColumn(label: Text('Dirección Envío')),
          DataColumn(label: Text('Número Orden ERP')),
          DataColumn(label: Text('Observaciones')),
          DataColumn(label: Text('Usuario')),
          DataColumn(label: Text('Referencia 1')),
          DataColumn(label: Text('Referencia 2')),
          DataColumn(label: Text('Subtotal')),
          DataColumn(label: Text('Descuento')),
          DataColumn(label: Text('Impuesto')),
          DataColumn(label: Text('Total')),
          DataColumn(label: Text('Estado')),
          DataColumn(label: Text('Origen')),
          DataColumn(label: Text('Error WS')),
          DataColumn(label: Text('Fecha Móvil')),
          DataColumn(label: Text('Fecha Envío ERP')),
        ],
        rows: _orders
            .map(
              (order) => DataRow(cells: [
                DataCell(Text(order.srorden.toString())),
                DataCell(Text(order.codcliente)),
                DataCell(Text(order.fecha)),
                DataCell(Text(order.fechaweb)),
                DataCell(Text(order.codformaenvio)),
                DataCell(Text(order.codformapago)),
                DataCell(Text(order.idorden)),
                DataCell(Text(order.codvendedor)),
                DataCell(Text(order.coddireccionenvio)),
                DataCell(Text(order.numordenerp)),
                DataCell(Text(order.observaciones)),
                DataCell(Text(order.loginusuario)),
                DataCell(Text(order.referencia1)),
                DataCell(Text(order.referencia2)),
                DataCell(Text(order.subtotal.toStringAsFixed(2))),
                DataCell(Text(order.descuento.toStringAsFixed(2))),
                DataCell(Text(order.impuesto.toStringAsFixed(2))),
                DataCell(Text(order.total.toStringAsFixed(2))),
                DataCell(Text(order.estado)),
                DataCell(Text(order.origen)),
                DataCell(Text(order.errorws)),
                DataCell(Text(order.fechamovil)),
                DataCell(Text(order.fechaenvioerp)),
              ]),
            )
            .toList(),
      ),
    );
  }
}
