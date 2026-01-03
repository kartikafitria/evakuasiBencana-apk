import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../models/evac_report.dart';
import '../../services/evac_report_service.dart';

class EditReportScreen extends StatefulWidget {
  final EvacReport report;

  const EditReportScreen({
    super.key,
    required this.report,
  });

  @override
  State<EditReportScreen> createState() => _EditReportScreenState();
}

class _EditReportScreenState extends State<EditReportScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController titleC;
  late TextEditingController descC;
  late TextEditingController locC;

  bool isLoading = false;
  bool isLocLoading = false;

  @override
  void initState() {
    super.initState();
    titleC = TextEditingController(text: widget.report.title);
    descC = TextEditingController(text: widget.report.description);
    locC = TextEditingController(text: widget.report.location);
  }

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    locC.dispose();
    super.dispose();
  }

  Future<void> _autoFillLocation() async {
    setState(() => isLocLoading = true);

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) throw "GPS tidak aktif";

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        throw "Izin lokasi ditolak";
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;
      locC.text =
          "${place.street}, ${place.subLocality}, ${place.locality}";
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengambil lokasi: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => isLocLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = EvacReportService();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          toolbarHeight: 72,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Edit Laporan",
              style: TextStyle(color: Colors.white),
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          backgroundColor: const Color(0xFF4988C4),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(22),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: SizedBox(
                  height: 420,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: titleC,
                            decoration: const InputDecoration(
                              labelText: "Judul Laporan",
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty
                                    ? "Judul tidak boleh kosong"
                                    : null,
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: locC,
                            decoration: InputDecoration(
                              labelText: "Lokasi",
                              border: const OutlineInputBorder(),
                              suffixIcon: isLocLoading
                                  ? const Padding(
                                      padding: EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : IconButton(
                                      icon: const Icon(Icons.my_location),
                                      onPressed: _autoFillLocation,
                                    ),
                            ),
                          ),

                          const SizedBox(height: 12),

                          TextFormField(
                            controller: descC,
                            decoration: const InputDecoration(
                              labelText: "Deskripsi Jalur",
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 220,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 53, 210, 58),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          try {
                            await service.updateReport(
                              report: widget.report,
                              title: titleC.text,
                              description: descC.text,
                              location: locC.text,
                            );

                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Laporan berhasil diperbarui"),
                              ),
                            );

                            Navigator.pop(context);
                          } catch (e) {
                            if (!mounted) return;
                            setState(() => isLoading = false);

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Gagal update: $e"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "SIMPAN PERUBAHAN",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
