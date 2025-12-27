import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/evac_report.dart';

class DetailReportScreen extends StatelessWidget {
  final EvacReport report;

  const DetailReportScreen({
    super.key,
    required this.report,
  });

  @override
  Widget build(BuildContext context) {
    final dateTime = report.createdAt.toDate();

    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    final createdTime = timeFormat.format(dateTime); // 21:15
    final createdDate = dateFormat.format(dateTime); // 12 September 2025

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Laporan"),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              report.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                const Icon(Icons.access_time, size: 16),
                const SizedBox(width: 6),
                Text(
                  "$createdTime · $createdDate",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            const Text(
              "Lokasi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(report.location),

            const SizedBox(height: 16),

            const Text(
              "Deskripsi",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(report.description),
          ],
        ),
      ),
    );
  }
}
