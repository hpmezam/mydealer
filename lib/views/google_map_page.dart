import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mydealer/localization/language_constrants.dart';
import 'package:mydealer/models/customers.dart';
import 'package:mydealer/models/customersrutas.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mydealer/controllers/custom_app_bar_widget.dart';

class GoogleMapPage extends StatefulWidget {
  final LatLng destination;
  final dynamic customer;

  const GoogleMapPage(
      {super.key, required this.destination, required this.customer});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? destinationIcon;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMap();
      destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/destination.png',
      );
    });
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<void> initializeMap() async {
    await fetchLocationUpdates();
  }

  @override
  Widget build(BuildContext context) {
    final isCustomerRutas = widget.customer is CustomerRutas;
    final customer = widget.customer;

    return Scaffold(
      appBar: CustomAppBarWidget(
          isBackButtonExist: true, title: getTranslated('location', context)),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.destination,
                zoom: 16, // Nivel de zoom ajustado para ver más cerca
              ),
              markers: {
                Marker(
                  markerId: const MarkerId('destinationLocation'),
                  icon: destinationIcon ?? BitmapDescriptor.defaultMarker,
                  position: widget.destination,
                  infoWindow: const InfoWindow(
                    title: 'Destino',
                    snippet: 'Este es tu destino',
                  ),
                ),
              },
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              final url =
                  'https://www.google.com/maps/search/?api=1&query=${widget.destination.latitude},${widget.destination.longitude}';
              _launchURL(url);
            },
            child: const Text('Abrir en Google Maps'),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Código Cliente - ${isCustomerRutas ? (customer as CustomerRutas).codCliente : (customer as Customer).codCliente} ',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        Text(
                          isCustomerRutas
                              ? (customer as CustomerRutas).nombreCliente
                              : (customer as Customer).nombre,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Dirección: ${isCustomerRutas ? (customer as CustomerRutas).direccion : (customer as Customer).direccion}',
                        ),
                        Text(
                          'Límite Crédito: ${isCustomerRutas ? (customer as CustomerRutas).limiteCredito : (customer as Customer).limiteCredito}',
                        ),
                        Text(
                          'Saldo Disponible: ${isCustomerRutas ? (customer as CustomerRutas).saldoPendiente : (customer as Customer).saldoPendiente}',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Acción para "Entregado"
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Pedido entregado.'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              child: const Text('Entregado'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Acción para "No entregado"
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text('Pedido no entregado.'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                textStyle: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              child: const Text('No entregado'),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchLocationUpdates() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await locationController.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
