import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/views/google_map_page.dart';
import 'package:mydealer/services/geocoding_service.dart';

class CustomerWidget extends StatelessWidget {
  final Customer customer;
  final GeocodingService _geocodingService = GeocodingService();

  CustomerWidget({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 5,
      child: ListTile(
        title: Text(
          '${customer.codCliente} - ${customer.nombre}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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
        leading: Icon(
          Icons.person_outline,
          color: Theme.of(context).primaryColor,
        ),
        trailing: Icon(
          Icons.location_on_outlined,
          color: Theme.of(context).primaryColor,
        ),
        onTap: () async {
          LatLng? destination;
          if (customer.latitud != null && customer.longitud != null) {
            destination = LatLng(customer.latitud!, customer.longitud!);
          } else {
            destination = await _geocodingService
                .getCoordinatesFromAddress(customer.direccion);
            if (destination == null) {
              destination =
                  const LatLng(0.3235301158630212, -78.20971500086232);
            }
          }

          if (destination != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GoogleMapPage(
                    destination: destination!, customer: customer),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    'No se pudieron obtener las coordenadas para la dirección proporcionada.'),
                backgroundColor: Colors.redAccent,
              ),
            );
          }
        },
      ),
    );
  }
}
