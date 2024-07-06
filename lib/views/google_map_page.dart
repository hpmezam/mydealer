import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mydealer/utils/app_constants.dart';
import 'package:mydealer/models/customers.dart';

class GoogleMapPage extends StatefulWidget {
  final LatLng destination;
  final Customer customer;

  const GoogleMapPage({super.key, required this.destination, required this.customer});

  @override
  State<GoogleMapPage> createState() => _GoogleMapPageState();
}

class _GoogleMapPageState extends State<GoogleMapPage> {
  final locationController = Location();
  LatLng? currentPosition;
  Map<PolylineId, Polyline> polylines = {};
  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor? carIcon;
  BitmapDescriptor? destinationIcon;
  StreamSubscription<LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initializeMap();
      carIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(size: Size(48, 48)),
        'assets/images/car.png',
      );
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
    final coordinates = await fetchPolylinePoints();
    if (coordinates.isNotEmpty) {
      generatePolyLineFromPoints(coordinates);
      _setCameraToFitBounds();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Ubicación"),
    ),
    body: Column(
      children: [
        Expanded(
          flex: 2,
          child: currentPosition == null
              ? const Center(child: CircularProgressIndicator())
              : GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.destination,
              zoom: 13,
            ),
            markers: {
              if (currentPosition != null)
                Marker(
                  markerId: const MarkerId('currentLocation'),
                  icon: carIcon ?? BitmapDescriptor.defaultMarker,
                  position: currentPosition!,
                  infoWindow: const InfoWindow(
                    title: 'Mi Ubicación',
                    snippet: 'Esta es tu ubicación actual',
                  ),
                ),
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
            polylines: Set<Polyline>.of(polylines.values),
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              _setCameraToFitBounds();
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Código Cliente - ${widget.customer.codCliente} ',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Text('${widget.customer.nombreCliente}',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 12),
                Text('Dirección: ${widget.customer.direccion}'),
                Text('Límite Crédito: ${widget.customer.limiteCredito}'),
                Text('Saldo Disponible: ${widget.customer.saldoPendiente}'),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Acción para "Entregado"
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pedido entregado.')),
                        );
                      },
                      child: const Text('Entregado'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Acción para "No entregado"
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Pedido no entregado.')),
                        );
                      },
                      child: const Text('No entregado'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    ),
  );

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

    _locationSubscription = locationController.onLocationChanged.listen((currentLocation) async {
      if (currentLocation.latitude != null && currentLocation.longitude != null) {
        if (!mounted) return; // Verifica si el widget aún está montado

        setState(() {
          currentPosition = LatLng(
            currentLocation.latitude!,
            currentLocation.longitude!,
          );
        });

        // Animate camera to the new position
        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(
          CameraUpdate.newLatLng(currentPosition!),
        );

        if (polylines.isEmpty) {
          initializeMap();
        } else {
          _setCameraToFitBounds();
        }
      }
    });
  }

  Future<List<LatLng>> fetchPolylinePoints() async {
    final polylinePoints = PolylinePoints();

    final result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: AppConstants.googleMapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(currentPosition!.latitude, currentPosition!.longitude),
        destination: PointLatLng(widget.destination.latitude, widget.destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      return result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();
    } else {
      debugPrint('Error fetching polyline points: ${result.errorMessage}');
      return [];
    }
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    setState(() => polylines[id] = polyline);
  }

  void _setCameraToFitBounds() async {
    if (currentPosition == null || polylines.isEmpty) return;

    final GoogleMapController controller = await _controller.future;
    LatLngBounds bounds;

    if (currentPosition!.latitude > widget.destination.latitude &&
        currentPosition!.longitude > widget.destination.longitude) {
      bounds = LatLngBounds(
        southwest: widget.destination,
        northeast: currentPosition!,
      );
    } else if (currentPosition!.longitude > widget.destination.longitude) {
      bounds = LatLngBounds(
        southwest: LatLng(currentPosition!.latitude, widget.destination.longitude),
        northeast: LatLng(widget.destination.latitude, currentPosition!.longitude),
      );
    } else if (currentPosition!.latitude > widget.destination.latitude) {
      bounds = LatLngBounds(
        southwest: LatLng(widget.destination.latitude, currentPosition!.longitude),
        northeast: LatLng(currentPosition!.latitude, widget.destination.longitude),
      );
    } else {
      bounds = LatLngBounds(
        southwest: currentPosition!,
        northeast: widget.destination,
      );
    }

    controller.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }
}
