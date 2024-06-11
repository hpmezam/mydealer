import 'package:flutter/material.dart';
import 'package:mydealer/models/customers.dart';

class CustomerWidget extends StatelessWidget {
  final Customer customer;

  const CustomerWidget({Key? key, required this.customer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 5,
      child: ListTile(
        title: Text('${customer.codCliente} - ${customer.nombre}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Email: ${customer.email}'),
              Text('Ciudad: ${customer.ciudad}'),
              Text('Forma de Pago: ${customer.codFormaPago}'),
              Text(
                  'Límite de crédito: \$${customer.limiteCredito.toStringAsFixed(2)}'),
              Text(
                  'Saldo pendiente: \$${customer.saldoPendiente.toStringAsFixed(2)}'),
              Text('Calificación: ${customer.calificacion}'),
            ],
          ),
        ),
        leading:
            Icon(Icons.person_outline, color: Theme.of(context).primaryColor),
        trailing: IconButton(
          icon: const Icon(Icons.location_on_outlined),
          onPressed: () {
            // Aquí puedes definir una acción al presionar, como abrir un menú de opciones
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Acciones'),
                  content:
                      Text('Selecciona una acción para ${customer.nombre}'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Detalle'),
                    )
                  ],
                );
              },
            );
          },
        ),
        onTap: () {
          _showCustomerDetails(context, customer);
        },
      ),
    );
  }

  void _showCustomerDetails(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Detalles de Cliente'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Nombre: ${customer.nombre}'),
                Text('Email: ${customer.email}'),
                Text('Ciudad: ${customer.ciudad}'),
                Text('País: ${customer.pais}'),
                Text('Vendedor: ${customer.codVendedor}'),
                Text('Forma de Pago: ${customer.codFormaPago}'),
                Text('Estado: ${customer.estado}'),
                Text(
                    'Límite de crédito: \$${customer.limiteCredito.toStringAsFixed(2)}'),
                Text(
                    'Saldo pendiente: \$${customer.saldoPendiente.toStringAsFixed(2)}'),
                Text('Calificación: ${customer.calificacion}'),
                Text('Nombre comercial: ${customer.nombreComercial}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
