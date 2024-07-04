import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydealer/models/customersrutas.dart';
import 'package:mydealer/views/google_map_page.dart';
import 'package:mydealer/services/geocoding_service.dart';

class CustomerRutasWidget extends StatelessWidget {
  final CustomerRutas customerRutas;
  final GeocodingService _geocodingService = GeocodingService();

  CustomerRutasWidget({super.key, required this.customerRutas});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 5,
      child: ListTile(
        title: Text('${customerRutas.codCliente} - ${customerRutas.nombreCliente}',
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(customerRutas.direccion),
              Text('Latitud: ${customerRutas.latitud}'),
              Text('Longitud: ${customerRutas.longitud}'), 
              Text('Límite Crédito: ${customerRutas.limiteCredito}'),
              Text('Saldo Disponible: ${customerRutas.saldoPendiente}'),
            ],
          ),
        ),
       
      ),
    );
  }
}
