import 'package:flutter/material.dart';
import '../../services/evac_report_service.dart';
import '../../models/evac_report.dart';
import 'add_report_screen.dart';
import 'edit_report_screen.dart';
import 'detail_report_screen.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = EvacReportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Jalur Evakuasi"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),

      // ================= FAB TAMBAH =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddReportScreen(),
            ),
          );
        },
      ),

      // ================= LIST LAPORAN =================
      body: StreamBuilder<List<EvacReport>>(
        stream: service.getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Terjadi kesalahan"),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(
              child: Text("Belum ada laporan"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final r = reports[index];

              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(
                    Icons.report,
                    color: Colors.redAccent,
                  ),

                  // ================= JUDUL =================
                  title: Text(
                    r.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // ================= LOKASI =================
                  subtitle: Text(
                    r.location.isEmpty ? "Lokasi tidak tersedia" : r.location,
                  ),

                  // ================= KLIK DETAIL =================
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            DetailReportScreen(report: r),
                      ),
                    );
                  },

                  // ================= MENU =================
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                EditReportScreen(report: r),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Hapus Laporan"),
                            content: const Text(
                                "Yakin ingin menghapus laporan ini?"),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () =>
                                    Navigator.pop(context, true),
                                child: const Text("Hapus"),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await service.deleteReport(r.id);
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text("Edit"),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text("Hapus"),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
