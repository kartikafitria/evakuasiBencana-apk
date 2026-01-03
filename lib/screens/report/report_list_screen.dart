import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
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

  bool showOnlyMine = false;
  bool showFilterButton = true;

  static const Color greenButton =
      Color.fromARGB(255, 53, 210, 58);

  static const Color activeBlue =
      Color(0xFF4988C4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: greenButton,
        child: const Text(
          "+",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
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

          final reports = showOnlyMine && currentUser != null
              ? allReports
                  .where((r) => r.userId == currentUser!.uid)
                  .toList()
              : allReports;

          return Column(
            children: [
              const SizedBox(height: 20),

              if (showFilterButton)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilterChip(
                      label: const Text("Laporan Saya"),
                      selected: showOnlyMine,
                      selectedColor: activeBlue,
                      backgroundColor: greenButton,
                      checkmarkColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.white),
                      onSelected: (value) {
                        setState(() {
                          showOnlyMine = value;
                        });
                      },
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              Expanded(
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    if (notification.direction ==
                        ScrollDirection.reverse) {
                      if (showFilterButton) {
                        setState(() {
                          showFilterButton = false;
                        });
                      }
                    } else if (notification.direction ==
                        ScrollDirection.forward) {
                      if (!showFilterButton) {
                        setState(() {
                          showFilterButton = true;
                        });
                      }
                    }
                    return false;
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                    itemCount: reports.length,
                    itemBuilder: (context, index) {
                      final r = reports[index];

                      final canManage = showOnlyMine &&
                          currentUser != null &&
                          r.userId == currentUser!.uid;

                      return Card(
                        color: Colors.white,
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
                          title: Text(
                            r.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              r.location.isEmpty
                                  ? "Lokasi tidak tersedia"
                                  : r.location,
                            ),
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
                          trailing: canManage
                              ? PopupMenuButton<String>(
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
                                      final confirm =
                                          await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title:
                                              const Text("Hapus Laporan"),
                                          content: const Text(
                                              "Yakin ingin menghapus laporan ini?"),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, false),
                                              child: const Text("Batal"),
                                            ),
                                            ElevatedButton(
                                              style:
                                                  ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.redAccent,
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(
                                                      context, true),
                                              child: const Text(
                                                "Hapus",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirm == true) {
                                        await service.deleteReport(r);
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
              ),
            ],
          );
        },
      ),
    );
  }
}
