import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    final service = EvacReportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Laporan"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              // JUDUL
              TextFormField(
                controller: titleC,
                decoration: const InputDecoration(
                  labelText: "Judul Laporan",
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Judul tidak boleh kosong" : null,
              ),

              const SizedBox(height: 12),

              // LOKASI
              TextFormField(
                controller: locC,
                decoration: const InputDecoration(
                  labelText: "Lokasi",
                  prefixIcon: Icon(Icons.location_on),
                ),
              ),

              const SizedBox(height: 12),

              // DESKRIPSI
              TextFormField(
                controller: descC,
                decoration: const InputDecoration(
                  labelText: "Deskripsi Jalur",
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // BUTTON SIMPAN
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => isLoading = true);

                            try {
                              await service.updateReport(
                                id: widget.report.id,
                                title: titleC.text,
                                description: descC.text,
                                location: locC.text,
                              );

                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Laporan berhasil diperbarui"),
                                ),
                              );

                              Navigator.pop(context);
                            } catch (e) {
                              setState(() => isLoading = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Gagal update: $e"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "SIMPAN PERUBAHAN",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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
