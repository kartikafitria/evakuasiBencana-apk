import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/biometric_service.dart';
import 'dashboard_screen.dart';

class BiometricScreen extends StatefulWidget {
  const BiometricScreen({super.key});

  @override
  State<BiometricScreen> createState() => _BiometricScreenState();
}

class _BiometricScreenState extends State<BiometricScreen> {
  bool _loading = false;

  Future<void> _startBiometric() async {
    setState(() => _loading = true);

    final biometric = BiometricService();
    final available = await biometric.isAvailable();

    if (!available) {
      _showError("Biometric tidak tersedia di perangkat ini");
      return;
    }

    final success = await biometric.authenticate();

    if (!success) {
      _showError("Verifikasi biometrik gagal");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('biometricVerified', true);

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _showError(String msg) {
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.redAccent),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Biometrik"),
        backgroundColor: Colors.redAccent,
      ),
      body: Center(
        child: _loading
            ? const CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.fingerprint, size: 90),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _startBiometric,
                    child: const Text("Verifikasi Fingerprint"),
                  ),
                ],
              ),
      ),
    );
  }
}
