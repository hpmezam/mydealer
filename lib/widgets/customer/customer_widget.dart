import 'package:flutter/material.dart';
import 'package:mydealer/models/customers.dart';

class CustomerWidget extends StatelessWidget {
  final Customer customer;

  const CustomerWidget({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 5,
      child: ListTile(
        title: Text('${customer.codCliente} - ${customer.nombreCliente}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(customer.direccion),
              Text('Límite Crédito: ${customer.limiteCredito}'),
              Text('Saldo Disponible: ${customer.saldoPendiente}'),
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
                  content: Text(
                      'Selecciona una acción para ${customer.nombreCliente}'),
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
      ),
    );
  }
}