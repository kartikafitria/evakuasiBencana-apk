import 'package:flutter/material.dart';

class QrResultScreen extends StatelessWidget {
  final String evacLocationName;

  const QrResultScreen({
    super.key,
    required this.evacLocationName,
  });

  @override
  Widget build(BuildContext context) {
    final String lokasi = evacLocationName.isNotEmpty
        ? evacLocationName
        : "Lokasi evakuasi tidak diketahui";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Check-in Berhasil"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 90,
            ),
            const SizedBox(height: 24),
            const Text(
              "Lokasi Evakuasi",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              lokasi,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Berhasil check-in di $lokasi",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
