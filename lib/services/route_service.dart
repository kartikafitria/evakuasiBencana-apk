import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RouteService {
  static const String _apiKey = "AIzaSyBNfGX7f-kahA5tU_TXss-egA6gpmr_b88";


  Future<List<LatLng>> getRoute({
    required LatLng origin,
    required LatLng destination,
  }) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result =
        await polylinePoints.getRouteBetweenCoordinates(
      _apiKey, 
      PointLatLng(origin.latitude, origin.longitude), 
      PointLatLng(destination.latitude, destination.longitude), 
      travelMode: TravelMode.walking,
    );

    if (result.points.isEmpty) {
      throw Exception(
          result.errorMessage ?? "Gagal mendapatkan rute");
    }

    return result.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();
  }
}
