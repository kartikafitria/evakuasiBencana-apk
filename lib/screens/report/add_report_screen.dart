import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../../services/evac_report_service.dart';

class AddReportScreen extends StatefulWidget {
  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final titleC = TextEditingController();
  final descC = TextEditingController();
  final locC = TextEditingController();

  bool _isLoading = false;
  bool _useAutoLocation = false;
  bool _loadingLocation = false;

  @override
  void dispose() {
    titleC.dispose();
    descC.dispose();
    locC.dispose();
    super.dispose();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _loadingLocation = true);

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      setState(() => _loadingLocation = false);
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      locC.text =
          "${p.street}, ${p.subLocality}, ${p.locality}, ${p.administrativeArea}";
    }

    setState(() => _loadingLocation = false);
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await EvacReportService().addReport(
        title: titleC.text.trim(),
        description: descC.text.trim(),
        location: locC.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Laporan berhasil disimpan"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal menyimpan laporan: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          toolbarHeight: 72,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Tambah Laporan",
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Card(
                color: Colors.white,
                child: SizedBox(
                  height: 470,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: titleC,
                          decoration: const InputDecoration(
                            labelText: "Judul",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? "Judul wajib diisi"
                                  : null,
                        ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: locC,
                          enabled: !_useAutoLocation,
                          decoration: const InputDecoration(
                            labelText: "Lokasi",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? "Lokasi wajib diisi"
                                  : null,
                        ),

                        RadioListTile<bool>(
                          title: const Text("Isi lokasi manual"),
                          value: false,
                          groupValue: _useAutoLocation,
                          onChanged: (v) {
                            setState(() => _useAutoLocation = v!);
                          },
                        ),

                        RadioListTile<bool>(
                          title: const Text("Gunakan lokasi saya"),
                          value: true,
                          groupValue: _useAutoLocation,
                          onChanged: (v) {
                            setState(() => _useAutoLocation = v!);
                            if (v == true) _getCurrentLocation();
                          },
                        ),

                        if (_useAutoLocation)
                          _loadingLocation
                              ? const CircularProgressIndicator()
                              : ElevatedButton.icon(
                                  onPressed: _getCurrentLocation,
                                  icon: const Icon(Icons.my_location),
                                  label: const Text("Ambil Lokasi"),
                                ),

                        const SizedBox(height: 12),

                        TextFormField(
                          controller: descC,
                          maxLines: 3,
                          decoration: const InputDecoration(
                            labelText: "Deskripsi",
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty
                                  ? "Deskripsi wajib diisi"
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: 200,
                height: 38,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 53, 210, 58),
                  ),
                  onPressed: _isLoading ? null : _saveReport,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          "SIMPAN",
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
