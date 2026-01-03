import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/evac_report.dart';

class DetailReportScreen extends StatelessWidget {
  final EvacReport report;

  const DetailReportScreen({
    super.key,
    required this.report,
  });

  void _openMaps(String location) async {
    final url =
        "https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(location)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateTime = report.createdAt.toDate();

    final timeFormat = DateFormat('HH:mm');
    final dateFormat = DateFormat('dd MMMM yyyy', 'id_ID');

    final createdTime = timeFormat.format(dateTime);
    final createdDate = dateFormat.format(dateTime);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: AppBar(
          toolbarHeight: 72,
          centerTitle: true,
          title: const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Detail Laporan",
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
        child: Card(
          color: Colors.white,
          child: Padding(
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

                const SizedBox(height: 16),

                const Text(
                  "Lokasi",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                GestureDetector(
                  onTap: () => _openMaps(report.location),
                  child: Text(
                    report.location,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  "Deskripsi",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  report.description,
                  style: const TextStyle(fontSize: 16),
                ),

                const SizedBox(height: 24),

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
