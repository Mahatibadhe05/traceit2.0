import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class RouteResult {
  final List<LatLng> points;
  final double distanceMeters;
  final double durationSeconds;

  const RouteResult({
    required this.points,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  double get distanceKm => distanceMeters / 1000;

  int get durationMinutes =>
      (durationSeconds / 60).round();
}

class RoutingService {
  Future<RouteResult> getRoute({
    required LatLng start,
    required LatLng destination,
  }) async {
    final url = Uri.parse(
      'https://router.project-osrm.org/route/v1/driving/'
      '${start.longitude},${start.latitude};'
      '${destination.longitude},${destination.latitude}'
      '?overview=full&geometries=geojson&steps=true',
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception(
        'Routing request failed: ${response.statusCode}',
      );
    }

    final data = jsonDecode(response.body);

    if (data['code'] != 'Ok') {
      throw Exception(
        'No route found.',
      );
    }

    final route = data['routes'][0];

    final geometry = route['geometry']['coordinates']
        as List<dynamic>;

    final points = geometry.map<LatLng>((coordinate) {
      final longitude =
          (coordinate[0] as num).toDouble();

      final latitude =
          (coordinate[1] as num).toDouble();

      return LatLng(latitude, longitude);
    }).toList();

    return RouteResult(
      points: points,
      distanceMeters:
          (route['distance'] as num).toDouble(),
      durationSeconds:
          (route['duration'] as num).toDouble(),
    );
  }
}