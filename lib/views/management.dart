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
  String _selectedState = 'Todos';
  String _clientCode = ''; // Campo de texto para el código del cliente
  List<String> _states = [
    'Todos',
    'E',
    'A',
    'I'
  ]; // Añade los estados relevantes
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
    final String estado = _selectedState != 'Todos' ? _selectedState : '';

    final String url =
        'http://home.mydealer.ec:8000/api/pedidosCompleto/160/$formattedStartDate/$formattedEndDate/${_clientCode}/$estado';

    print('Fetching data from: $url'); // Añade un print para verificar la URL

    try {
      final response = await http.get(Uri.parse(url));
      print(
          'Status code: ${response.statusCode}'); // Añade un print para verificar el código de estado

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print(
            'Data received: $data'); // Añade un print para verificar los datos recibidos

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
            _buildClientInput(),
            _buildDateSelector(),
            _buildStateSelector(),
            _buildShowButton(),
            _loading ? CircularProgressIndicator() : _buildOrderList(),
          ],
        ),
      ),
    );
  }

  Widget _buildClientInput() {
    return ListTile(
      leading: Icon(Icons.person),
      title: TextField(
        decoration: InputDecoration(
          labelText: 'Cliente',
          hintText: 'Ingrese el código del cliente',
        ),
        onChanged: (value) {
          setState(() {
            _clientCode = value;
          });
        },
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
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
      ],
    );
  }

  Widget _buildStateSelector() {
    return ListTile(
      leading: Icon(Icons.filter_list),
      title: DropdownButton<String>(
        value: _selectedState,
        items: _states.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _selectedState = newValue!;
          });
        },
      ),
    );
  }

  Widget _buildShowButton() {
    return ElevatedButton(
      onPressed: _fetchOrders,
      child: Text('Mostrar'),
    );
  }

  Widget _buildOrderList() {
    if (_orders.isEmpty) {
      return Center(child: Text('No orders found'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text('Pedido #: ${order.srorden} - Fecha: ${order.fecha}'),
            subtitle:
                Text('Cliente: ${order.nombre} - Total: \$${order.total}'),
            children: order.detalles.map((detail) {
              return ListTile(
                title: Text('${detail.nombre}'),
                subtitle: Text(
                    'Cantidad: ${detail.cantidad} - Precio: \$${detail.precio}'),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class Order {
  final int srorden;
  final String codcliente;
  final String fecha;
  final String estado;
  final double? descuento;
  final double? impuesto;
  final double? total;
  final String nombre;
  final String ordenEstado;
  final List<OrderDetail> detalles;

  Order({
    required this.srorden,
    required this.codcliente,
    required this.fecha,
    required this.estado,
    this.descuento,
    this.impuesto,
    this.total,
    required this.nombre,
    required this.ordenEstado,
    required this.detalles,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var detallesJson = json['detalles'] as List;
    List<OrderDetail> detallesList =
        detallesJson.map((i) => OrderDetail.fromJson(i)).toList();

    return Order(
      srorden: json['srorden'],
      codcliente: json['codcliente'],
      fecha: json['fecha'],
      estado: json['estado'],
      descuento: (json['descuento'] ?? 0).toDouble(),
      impuesto: (json['impuesto'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      nombre: json['nombre'],
      ordenEstado: json['orden_estado'],
      detalles: detallesList,
    );
  }
}

class OrderDetail {
  final int numlinea;
  final String codproducto;
  final int cantidad;
  final double precio;
  final double subtotal;
  final double impuesto;
  final double total;
  final String nombre;

  OrderDetail({
    required this.numlinea,
    required this.codproducto,
    required this.cantidad,
    required this.precio,
    required this.subtotal,
    required this.impuesto,
    required this.total,
    required this.nombre,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      numlinea: json['numlinea'],
      codproducto: json['codproducto'],
      cantidad: json['cantidad'],
      precio: (json['precio'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      impuesto: (json['impuesto'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      nombre: json['nombre'],
    );
  }
}
