import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ManagementPage extends StatefulWidget {
  @override
  _ManagementPageState createState() => _ManagementPageState();
}

class _ManagementPageState extends State<ManagementPage> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  String _selectedState = 'Todos';
  String _clientCode = '';
  List<Map<String, dynamic>> _states = [
    {'label': 'Todos', 'value': 'TODOS'},
    {'label': 'Enviado', 'value': 'E'},
    {'label': 'No atorizado', 'value': 'A'}
  ];
  List<Order> _orders = [];
  bool _loading = false;
  String _vendedorID = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Obtener y guardar datos del usuario al inicio
  }

  Future<void> _fetchUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // Obtener datos guardados del usuario
      String? codvendedor = prefs.getString('codvendedor');
      print('Codvendedor guardado: $codvendedor');

      setState(() {
        _vendedorID = codvendedor ?? '';
      });

      // Si se tiene el vendedorID, buscar pedidos
      if (_vendedorID.isNotEmpty) {
        _fetchOrders();
      } else {
        print('VendedorID no encontrado en SharedPreferences.');
      }
    } catch (e) {
      print('Error al obtener datos de usuario: $e');
    }
  }

  Future<void> _fetchOrders() async {
    if (_vendedorID.isEmpty) {
      print('Error: VendedorID no válido.');
      return;
    }

    setState(() {
      _loading = true;
    });

    final String formattedStartDate =
        "${_startDate.toIso8601String().split('T')[0]}";
    final String formattedEndDate =
        "${_endDate.toIso8601String().split('T')[0]}";
    final String estado = _selectedState != 'Todos'
        ? _states.firstWhere(
            (element) => element['label'] == _selectedState)['value']
        : '';

    final String cliente = _clientCode.isNotEmpty ? _clientCode : 'TODOS';

    final String url =
        'http://home.mydealer.ec:8000/api/pedidosCompleto/$_vendedorID/$formattedStartDate/$formattedEndDate/$cliente/$estado';

    print('Fetching data from: $url');

    try {
      final response = await http.get(Uri.parse(url));
      print('Status code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received: $data');

        if (data['datos'] != null && data['datos'].isNotEmpty) {
          setState(() {
            _orders =
                (data['datos'] as List).map((i) => Order.fromJson(i)).toList();
            _loading = false;
          });
        } else {
          print('No data found for the given date range and client.');
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
        items: _states.map((state) {
          return DropdownMenuItem<String>(
            value: state['label'],
            child: Text(state['label']!),
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
      return Center(child: Text('No se encontraron pedidos.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      itemCount: _orders.length,
      itemBuilder: (context, index) {
        final order = _orders[index];
        return Card(
          margin: EdgeInsets.all(8),
          child: InkWell(
            onTap: () {
              _showOrderDetails(context, order);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text('Pedido #: ${order.srorden}'),
                  subtitle: Text('Cliente: ${order.clienteNombre}'),
                  trailing: order.getStateIcon(),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Fecha: ${order.fecha}'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detalles del Pedido #${order.srorden}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Fecha: ${order.fecha}'),
                Text('Estado: ${order.ordenEstado}'),
                Text('Cliente: ${order.clienteNombre}'),
                Divider(),
                ...order.detalles.map((detail) {
                  return ListTile(
                    title: Text('${detail.nombre}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Cantidad: ${detail.cantidad}'),
                        Text('Precio: \$${detail.precio ?? 0}'),
                        Text('Subtotal: \$${detail.subtotal ?? 0}'),
                        Text('Impuesto: \$${detail.impuesto ?? 0}'),
                        Text('Total: \$${detail.total ?? 0}'),
                        Text('Unidad de Medida: ${detail.unidadmedida}'),
                        Text('Categoría: ${detail.categoria}'),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
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
  final double? total; // Cambiado a nullable
  final String ordenEstado;
  final String clienteNombre;
  final List<OrderDetail> detalles;

  Order({
    required this.srorden,
    required this.codcliente,
    required this.fecha,
    required this.estado,
    this.descuento,
    this.impuesto,
    this.total,
    required this.ordenEstado,
    required this.clienteNombre,
    required this.detalles,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    var detallesJson = json['detalles'] as List;
    List<OrderDetail> detallesList =
        detallesJson.map((i) => OrderDetail.fromJson(i)).toList();

    return Order(
      srorden: json['srorden'],
      codcliente: json['codcliente'] ?? '',
      fecha: json['fecha'] ?? '',
      estado: json['estado'] ?? '',
      descuento: (json['descuento'] ?? 0).toDouble(),
      impuesto: (json['impuesto'] ?? 0).toDouble(),
      total: json['total'] != null ? json['total'].toDouble() : null,
      ordenEstado: json['orden_estado'] ?? '',
      clienteNombre: json['cliente_nombre'] ?? '',
      detalles: detallesList,
    );
  }

  Widget getStateIcon() {
    IconData icon;
    Color color;

    switch (estado) {
      case 'E': // Enviado
        icon = Icons.local_shipping; // Ejemplo de ícono de camión de envío
        color = Colors.green; // Color verde para indicar enviado
        break;
      case 'A': // Activo
        icon = Icons.warning; // Ejemplo de ícono de estado activo
        color = Colors.red; // Color azul para indicar activo
        break;
      default:
        icon = Icons
            .help_outline; // Icono por defecto en caso de estado desconocido
        color = Colors.grey; // Color gris para indicar estado desconocido
    }

    return Icon(icon, color: color);
  }
}

class OrderDetail {
  final int numlinea;
  final String codproducto;
  final int cantidad;
  final double? precio; // Cambiado a nullable
  final double? subtotal; // Cambiado a nullable
  final double? impuesto; // Cambiado a nullable
  final double? total; // Cambiado a nullable
  final String unidadmedida;
  final String nombre;
  final String categoria;

  OrderDetail({
    required this.numlinea,
    required this.codproducto,
    required this.cantidad,
    this.precio,
    this.subtotal,
    this.impuesto,
    this.total,
    required this.unidadmedida,
    required this.nombre,
    required this.categoria,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      numlinea: json['numlinea'] ?? 0,
      codproducto: json['codproducto'] ?? '',
      cantidad: json['cantidad'] ?? 0,
      precio: json['precio'] != null ? json['precio'].toDouble() : 0,
      subtotal: json['subtotal'] != null ? json['subtotal'].toDouble() : 0,
      impuesto: json['impuesto'] != null ? json['impuesto'].toDouble() : 0,
      total: json['total'] != null ? json['total'].toDouble() : 0,
      unidadmedida: json['unidadmedida'] ?? '',
      nombre: json['nombre'] ?? '',
      categoria: json['categoria'] ?? '',
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ManagementPage(),
  ));
}
