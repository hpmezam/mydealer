import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:intl/intl.dart';
import 'package:mydealer/models/customersrutas.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class GPSWidget extends StatefulWidget {
  final List<CustomerRutas> rutas;

  GPSWidget({required this.rutas});

  @override
  _GPSWidgetState createState() => _GPSWidgetState();
}

class _GPSWidgetState extends State<GPSWidget> {
  final Location _location = Location();
  late GoogleMapController _mapController;
  LatLng? _currentPosition;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        setState(() {
          _currentPosition = LatLng(0, 0); // Default location in case of error
        });
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        setState(() {
          _currentPosition = LatLng(0, 0); // Default location in case of error
        });
        return;
      }
    }

    try {
      LocationData locationData = await _location.getLocation();
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);

      setState(() {
        _markers.add(
          Marker(
            markerId: MarkerId("currentLocation"),
            position: _currentPosition!,
            infoWindow: InfoWindow(
              title: "Ubicación actual",
            ),
          ),
        );

        _initializeRutas();
      });

      _location.onLocationChanged.listen((LocationData currentLocation) {
        _currentPosition = LatLng(currentLocation.latitude!, currentLocation.longitude!);
        // No actualizar la cámara a la ubicación actual cada vez
      });
    } catch (e) {
      setState(() {
        _currentPosition = LatLng(0, 0); // Default location in case of error
      });
    }
  }

  Future<void> _initializeRutas() async {
    List<LatLng> points = widget.rutas
        .where((ruta) => ruta.latitud != null && ruta.longitud != null)
        .map((ruta) => LatLng(ruta.latitud!, ruta.longitud!))
        .toList();

    // Ordenar los puntos usando el algoritmo del vecino más cercano
    List<LatLng> orderedPoints = _orderPointsByNearestNeighbor(_currentPosition!, points);

    for (var i = 0; i < widget.rutas.length; i++) {
      var ruta = widget.rutas[i];
      if (ruta.latitud != null && ruta.longitud != null) {
        LatLng point = LatLng(ruta.latitud!, ruta.longitud!);
        _markers.add(
          Marker(
            markerId: MarkerId(ruta.codCliente),
            position: point,
            infoWindow: InfoWindow(
              title: ruta.nombreCliente,
              snippet: ruta.direccion,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue,
            ),
          ),
        );
      }
    }

    // Resaltar la última ruta (la más lejana)
    if (orderedPoints.isNotEmpty) {
      LatLng lastPoint = orderedPoints.last;
      var lastRuta = widget.rutas.firstWhere(
              (ruta) => ruta.latitud == lastPoint.latitude && ruta.longitud == lastPoint.longitude);

      _markers.add(
        Marker(
          markerId: MarkerId(lastRuta.codCliente),
          position: lastPoint,
          infoWindow: InfoWindow(
            title: lastRuta.nombreCliente,
            snippet: lastRuta.direccion,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    }

    // Obtener rutas detalladas de la API de OSRM
    await _fetchRoutes(_currentPosition!, orderedPoints);

    setState(() {});
  }

  Future<void> _fetchRoutes(LatLng start, List<LatLng> points) async {
    LatLng previousPoint = start;
    for (LatLng point in points) {
      String url = 'http://router.project-osrm.org/route/v1/driving/${previousPoint.longitude},${previousPoint.latitude};${point.longitude},${point.latitude}?overview=full&geometries=polyline';

      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        var routes = data['routes'] as List;
        if (routes.isNotEmpty) {
          var route = routes.first;
          var polyline = route['geometry'];
          _addPolyline(_decodePolyline(polyline));
        }
      } else {
        print('Error fetching directions: ${response.statusCode}');
      }

      previousPoint = point;
    }
  }

  void _addPolyline(List<LatLng> polylinePoints) {
    _polylines.add(
      Polyline(
        polylineId: PolylineId(_polylines.length.toString()),
        points: polylinePoints,
        color: Colors.blue,
        width: 5,
      ),
    );
  }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1F) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      polyline.add(LatLng(lat / 1E5, lng / 1E5));
    }

    return polyline;
  }

  List<LatLng> _orderPointsByNearestNeighbor(LatLng startPoint, List<LatLng> points) {
    List<LatLng> orderedPoints = [];
    LatLng currentPoint = startPoint;
    List<LatLng> remainingPoints = List.from(points);

    while (remainingPoints.isNotEmpty) {
      remainingPoints.sort((a, b) => Geolocator.distanceBetween(
          currentPoint.latitude, currentPoint.longitude, a.latitude, a.longitude)
          .compareTo(Geolocator.distanceBetween(
          currentPoint.latitude, currentPoint.longitude, b.latitude, b.longitude)));
      currentPoint = remainingPoints.removeAt(0);
      orderedPoints.add(currentPoint);
    }

    return orderedPoints;
  }

  void _fitMapToPolylines(List<LatLng> points) {
    if (_mapController == null || points.isEmpty) return;

    LatLngBounds bounds;
    if (points.length == 1) {
      bounds = LatLngBounds(
        southwest: points.first,
        northeast: points.first,
      );
    } else {
      double x0 = points.first.latitude, x1 = points.first.latitude, y0 = points.first.longitude, y1 = points.first.longitude;
      for (LatLng point in points) {
        if (point.latitude > x1) x1 = point.latitude;
        if (point.latitude < x0) x0 = point.latitude;
        if (point.longitude > y1) y1 = point.longitude;
        if (point.longitude < y0) y0 = point.longitude;
      }
      bounds = LatLngBounds(
        southwest: LatLng(x0, y0),
        northeast: LatLng(x1, y1),
      );
    }
    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  void _launchGoogleMaps() async {
    if (_currentPosition == null || widget.rutas.isEmpty) return;

    final baseUrl = 'https://www.google.com/maps/dir/?api=1';
    final origin = 'origin=${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final waypoints = widget.rutas
        .where((ruta) => ruta.latitud != null && ruta.longitud != null)
        .map((ruta) => '${ruta.latitud},${ruta.longitud}')
        .join('|');
    final destination = waypoints.split('|').last;
    final url = '$baseUrl&$origin&destination=$destination&waypoints=$waypoints';

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (_currentPosition != null)
            Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.72, // 10% smaller in height
                width: MediaQuery.of(context).size.width * 0.85,  // 5% wider
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16), // Ajusta el radio de los bordes
                  child: GestureDetector(
                    onPanUpdate: (details) {
                      // Consume el gesto para que el PageView no lo maneje
                    },
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: _currentPosition!,
                        zoom: 14.0,
                      ),
                      markers: _markers,
                      polylines: _polylines,
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        _fitMapToPolylines(_markers.map((m) => m.position).toList());
                      },
                      gestureRecognizers: Set()
                        ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer()))
                        ..add(Factory<ScaleGestureRecognizer>(() => ScaleGestureRecognizer()))
                        ..add(Factory<TapGestureRecognizer>(() => TapGestureRecognizer()))
                        ..add(Factory<VerticalDragGestureRecognizer>(() => VerticalDragGestureRecognizer())),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 36, // Align with the top of the map
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  DateFormat('EEEE, dd-MM-yyyy', 'es_ES').format(DateTime.now()),
                  style: TextStyle(color: Colors.white, fontSize: 18), // Increased font size
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 36,
            left: 36,
            child: FloatingActionButton.extended(
              onPressed: _launchGoogleMaps,
              label: Text(
                'Navegar',
                style: TextStyle(color: Colors.white),
              ),
              icon: Icon(Icons.navigation, color: Colors.white),
              backgroundColor: Colors.blue[900],
            ),
          ),
        ],
      ),
    );
  }
}


