import 'package:flutter/material.dart';
import '../../services/evac_report_service.dart';
import '../../models/evac_report.dart';
import 'add_report_screen.dart';
import 'edit_report_screen.dart';

class ReportListScreen extends StatelessWidget {
  const ReportListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final service = EvacReportService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Jalur Evakuasi"),
        backgroundColor: Colors.redAccent,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddReportScreen()),
          );
        },
      ),

      body: StreamBuilder<List<EvacReport>>(
        stream: service.getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final reports = snapshot.data!;

          if (reports.isEmpty) {
            return const Center(child: Text("Belum ada laporan"));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, i) {
              final r = reports[i];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: const Icon(Icons.report, color: Colors.redAccent),
                  title: Text(r.title),
                  subtitle: Text(r.location),

                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditReportScreen(report: r),
                          ),
                        );
                      } else if (value == 'delete') {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Hapus Laporan"),
                            content: const Text(
                                "Apakah kamu yakin ingin menghapus laporan ini?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
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
                    itemBuilder: (_) => const [
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
