import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'qr_result_screen.dart';

class QrScanScreen extends StatefulWidget {
  final String selectedEvacLocation;

  const QrScanScreen({
    super.key,
    required this.selectedEvacLocation,
  });

  @override
  State<QrScanScreen> createState() => _QrScanScreenState();
}

class _QrScanScreenState extends State<QrScanScreen> {
  bool _scanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scan QR Lokasi Evakuasi"),
        backgroundColor: Colors.redAccent,
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
        ),
        onDetect: (capture) {
          if (_scanned) return;

          final barcode = capture.barcodes.first;
          final String? qrValue = barcode.rawValue;

          if (qrValue == null) return;

          setState(() => _scanned = true);

          if (qrValue.trim() == widget.selectedEvacLocation.trim()) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => QrResultScreen(
                  evacLocationName: qrValue,
                ),
              ),
            );
          } else {
            _showInvalidQrDialog(context, qrValue);
            setState(() => _scanned = false);
          }
        },
      ),
    );
  }

  void _showInvalidQrDialog(BuildContext context, String qrValue) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("QR Tidak Sesuai"),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
            children: [
              const TextSpan(text: "QR ini untuk "),
              TextSpan(
                text: qrValue,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                    ".\n \nSilakan scan QR sesuai lokasi yang kamu pilih.",
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Scan Ulang"),
          ),
        ],
      ),
    );
  }
}
