import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydealer/models/allCustomers.dart';
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
          onPressed: () async {
            LatLng? destination;
            if (customer.latitud != null && customer.longitud != null) {
              destination = LatLng(customer.latitud!, customer.longitud!);
            } else {
              print(
                  'Fetching coordinates for address: ${customer.direccion}'); // Log para depuración
              destination = await _geocodingService
                  .getCoordinatesFromAddress(customer.direccion);
              if (destination == null) {
                print('Failed to fetch coordinates, using default location');
                destination =
                    const LatLng(-2.8959944649509226, -79.00784635744888);
              }
            }

            if (destination != null) {
              // Abre la página de Google Maps en una ventana flotante
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: GoogleMapPage(
                              destination: destination!,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10.0,
                          right: 10.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
      ),
    );
  }
}

class AllCustomerWidget extends StatelessWidget {
  final AllCustomers allCustomers;

  const AllCustomerWidget({super.key, required this.allCustomers});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 5,
      child: InkWell(
        onTap: () {
          showCustomerDetailsDialog(context, allCustomers);
        },
        child: ListTile(
          title: Text('${allCustomers.codcliente} - ${allCustomers.nombre}',
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(allCustomers.pais),
                Text(allCustomers.provincia), //CAMBIAR SS
                Text(allCustomers.ciudad),
                Text('Límite Crédito: ${allCustomers.limitecredito}'),
                Text('Saldo Disponible: ${allCustomers.saldopendiente}'),
              ],
            ),
          ),
          leading:
              Icon(Icons.person, color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  void showCustomerDetailsDialog(
      BuildContext context, AllCustomers allCustomers) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Detalles del Cliente"),
          content: SingleChildScrollView(
            child: ListTile(
              title: Text('${allCustomers.codcliente} - ${allCustomers.nombre}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Ruc: ${allCustomers.cedularuc}'),
                    Text('País: ${allCustomers.pais}'),
                    Text('Provincia: ${allCustomers.provincia}'),
                    Text('Ciudad: ${allCustomers.ciudad}'),
                    Text('Estad: ${allCustomers.estado}'),
                    Text('Calificacion: ${allCustomers.calificacion}'),                 
                    Text('Límite Crédito: ${allCustomers.limitecredito}'),
                    Text('Saldo Disponible: ${allCustomers.saldopendiente}'),
                  ],
                ),
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
