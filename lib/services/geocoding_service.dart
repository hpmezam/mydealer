import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mydealer/utils/app_constants.dart';

class GeocodingService {
  Future<LatLng?> getCoordinatesFromAddress(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=${Uri.encodeComponent(address)}&key=${AppConstants.googleMapsApiKey}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      print('Geocoding response: $json'); // Log para depuración
      if (json['status'] == 'OK') {
        final location = json['results'][0]['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      } else {
        print('Geocoding error: ${json['status']}');
      }
    } else {
      print('Geocoding request failed with status: ${response.statusCode}');
    }
    return null;
  }
}
