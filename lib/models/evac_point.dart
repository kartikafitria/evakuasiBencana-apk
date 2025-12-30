import 'package:google_maps_flutter/google_maps_flutter.dart';

class EvacPoint {
  final String name;
  final String address;
  final LatLng location;

  EvacPoint({
    required this.name,
    required this.address,
    required this.location,
  });
}

final List<EvacPoint> evacPoints = [
  EvacPoint(
    name: "Lapangan Merdeka",
    address: "Jl. Merdeka No. 1",
    location: LatLng(-6.200000, 106.816666),
  ),
  EvacPoint(
    name: "Gedung Serbaguna",
    address: "Jl. Raya Utama No. 12",
    location: LatLng(-6.210000, 106.820000),
  ),
  EvacPoint(
    name: "Balai Desa",
    address: "Jl. Desa Aman No. 5",
    location: LatLng(-6.220000, 106.825000),
  ),
];
