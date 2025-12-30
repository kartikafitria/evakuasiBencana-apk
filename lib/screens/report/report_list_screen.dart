import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/evac_report_service.dart';
import '../../models/evac_report.dart';
import 'add_report_screen.dart';
import 'edit_report_screen.dart';
import 'detail_report_screen.dart';

class ReportListScreen extends StatefulWidget {
  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  final service = EvacReportService();
  final currentUser = FirebaseAuth.instance.currentUser;

  bool showOnlyMine = false; // 🔥 STATE FILTER

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laporan Jalur Evakuasi"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),

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

      body: StreamBuilder<List<EvacReport>>(
        stream: service.getReports(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allReports = snapshot.data!;

          if (allReports.isEmpty) {
            return const Center(child: Text("Belum ada laporan"));
          }

          // 🔥 FILTER DATA
          final reports = showOnlyMine && currentUser != null
              ? allReports
                  .where((r) => r.userId == currentUser!.uid)
                  .toList()
              : allReports;

          return Column(
            children: [
              // ================= FILTER CHIP =================
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FilterChip(
                    label: const Text("Hanya laporan saya"),
                    selected: showOnlyMine,
                    selectedColor: Colors.green.shade100,
                    checkmarkColor: Colors.green,
                    onSelected: (value) {
                      setState(() {
                        showOnlyMine = value;
                      });
                    },
                  ),
                ),
              ),

              // ================= LIST LAPORAN =================
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reports.length,
                  itemBuilder: (context, index) {
                    final r = reports[index];
                    final isOwner = currentUser != null &&
                        r.userId == currentUser!.uid;

                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        // 🔴 IKON MERAH HANYA UNTUK LAPORAN ORANG LAIN
                        leading: isOwner
                            ? null
                            : const Icon(
                                Icons.report,
                                color: Colors.redAccent,
                              ),

                        title: Text(
                          r.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // ===== LOKASI + CHIP =====
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text(
                              r.location.isEmpty
                                  ? "Lokasi tidak tersedia"
                                  : r.location,
                            ),

                            // 🟢 CHIP "LAPORAN ANDA"
                            if (isOwner)
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 6),
                                child: Chip(
                                  label: const Text(
                                    "Laporan Anda",
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor:
                                      Colors.green.shade100,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize
                                          .shrinkWrap,
                                  visualDensity:
                                      VisualDensity.compact,
                                ),
                              ),
                          ],
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetailReportScreen(report: r),
                            ),
                          );
                        },

                        // 🔐 EDIT & HAPUS HANYA PEMILIK
                        trailing: isOwner
                            ? PopupMenuButton<String>(
                                onSelected: (value) async {
                                  if (value == 'edit') {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditReportScreen(
                                                report: r),
                                      ),
                                    );
                                  } else if (value == 'delete') {
                                    final confirm =
                                        await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title: const Text(
                                            "Hapus Laporan"),
                                        content: const Text(
                                            "Yakin ingin menghapus laporan ini?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(
                                                    context, false),
                                            child:
                                                const Text("Batal"),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                                  Colors.redAccent,
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(
                                                    context, true),
                                            child:
                                                const Text("Hapus"),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await service
                                          .deleteReport(r.id as EvacReport);
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
                              )
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
