import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../services/location_service.dart';
import 'evac_detail_screen.dart';

class EvacMapScreen extends StatefulWidget {
  const EvacMapScreen({super.key});

  @override
  State<EvacMapScreen> createState() => _EvacMapScreenState();
}

class _EvacMapScreenState extends State<EvacMapScreen> {
  LatLng? _userLocation;
  bool _loading = true;

  final List<EvacPoint> evacPoints = [
    EvacPoint(
      name: "Lapangan Puputan Badung",
      address: "Jl. Surapati, Denpasar",
      location: const LatLng(-8.656295, 115.216652),
    ),
    EvacPoint(
      name: "GOR Ngurah Rai",
      address: "Jl. Melati, Denpasar",
      location: const LatLng(-8.670458, 115.212629),
    ),
    EvacPoint(
      name: "Lapangan Niti Mandala Renon",
      address: "Jl. Raya Puputan, Renon",
      location: const LatLng(-8.671622, 115.233134),
    ),
    EvacPoint(
      name: "Balai Desa Sanur",
      address: "Jl. Danau Tamblingan, Sanur",
      location: const LatLng(-8.694292, 115.262402),
    ),
    EvacPoint(
      name: "Lapangan Mangupraja Mandala",
      address: "Puspem Badung, Mangupura",
      location: const LatLng(-8.580694, 115.173024),
    ),
    EvacPoint(
      name: "Lapangan Kapten Mudita",
      address: "Jl. Kapten Mudita, Mengwi",
      location: const LatLng(-8.541497, 115.169736),
    ),
    EvacPoint(
      name: "Alun-Alun Gianyar",
      address: "Jl. Ngurah Rai, Gianyar",
      location: const LatLng(-8.544847, 115.325511),
    ),
    EvacPoint(
      name: "Lapangan Astina",
      address: "Jl. Astina, Gianyar",
      location: const LatLng(-8.537718, 115.328554),
    ),
    EvacPoint(
      name: "Lapangan Alit Saputra",
      address: "Jl. Pahlawan, Tabanan",
      location: const LatLng(-8.538699, 115.124211),
    ),
    EvacPoint(
      name: "Lapangan Puputan Klungkung",
      address: "Jl. Untung Surapati, Semarapura",
      location: const LatLng(-8.538248, 115.402527),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _loadLocationAndSort();
  }

  Future<void> _loadLocationAndSort() async {
    final pos = await LocationService().getCurrentLocation();

    _userLocation = LatLng(pos.latitude, pos.longitude);

    for (var point in evacPoints) {
      point.distance = Geolocator.distanceBetween(
        pos.latitude,
        pos.longitude,
        point.location.latitude,
        point.location.longitude,
      );
    }

    evacPoints.sort((a, b) => a.distance!.compareTo(b.distance!));

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Evac Map"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // ================= MAP =================
                SizedBox(
                  height: 180,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: _userLocation!,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("user"),
                        position: _userLocation!,
                        infoWindow: const InfoWindow(title: "Lokasi Anda"),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueBlue,
                        ),
                      ),
                      ...evacPoints.map(
                        (e) => Marker(
                          markerId: MarkerId(e.name),
                          position: e.location,
                          infoWindow: InfoWindow(title: e.name),
                        ),
                      ),
                    },
                  ),
                ),

                const SizedBox(height: 8),

                // ================= TITLE =================
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Titik Evakuasi Terdekat",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ================= LIST =================
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: evacPoints.length,
                    itemBuilder: (context, index) {
                      final item = evacPoints[index];

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.redAccent,
                            size: 30,
                          ),
                          title: Text(
                            item.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          // 🔴 PERUBAHAN ADA DI SINI (ALAMAT DIHAPUS)
                          subtitle: Text(
                            "${(item.distance! / 1000).toStringAsFixed(2)} km dari lokasi kamu",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EvacDetailScreen(
                                  evacPoint: item,
                                  userLocation: _userLocation!,
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}

// ================= MODEL =================
class EvacPoint {
  final String name;
  final String address;
  final LatLng location;
  double? distance;

  EvacPoint({
    required this.name,
    required this.address,
    required this.location,
    this.distance,
  });
}
