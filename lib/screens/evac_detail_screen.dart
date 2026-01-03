import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'qr/qr_scan_screen.dart';
import 'evac_map_screen.dart';
import '../services/route_service.dart';

class EvacDetailScreen extends StatefulWidget {
  final EvacPoint evacPoint;
  final LatLng userLocation;

  const EvacDetailScreen({
    super.key,
    required this.evacPoint,
    required this.userLocation,
  });

  @override
  State<EvacDetailScreen> createState() => _EvacDetailScreenState();
}

class _EvacDetailScreenState extends State<EvacDetailScreen> {
  final RouteService _routeService = RouteService();

  List<LatLng> _routePoints = [];
  bool _loadingRoute = true;

  @override
  void initState() {
    super.initState();
    _loadRoute();
  }

  Future<void> _loadRoute() async {
    try {
      final route = await _routeService.getRoute(
        origin: widget.userLocation,
        destination: widget.evacPoint.location,
      );

      setState(() {
        _routePoints = route;
        _loadingRoute = false;
      });
    } catch (e) {
      setState(() => _loadingRoute = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 72,
        centerTitle: true,
        title: const Text(
          "Detail Evakuasi",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFFD73535),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(22),
            bottomRight: Radius.circular(22),
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.evacPoint.location,
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId("user"),
                  position: widget.userLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue,
                  ),
                ),
                Marker(
                  markerId: const MarkerId("evac"),
                  position: widget.evacPoint.location,
                ),
              },
              polylines: {
                if (_routePoints.isNotEmpty)
                  Polyline(
                    polylineId: const PolylineId("route"),
                    color: Colors.redAccent,
                    width: 5,
                    points: _routePoints,
                  ),
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.evacPoint.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.evacPoint.address,
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SizedBox(
                width: 210, 
                height: 50,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.qr_code),
                  label: const Text("Scan QR"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 53, 210, 58),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => QrScanScreen(
                          selectedEvacLocation: widget.evacPoint.name,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
