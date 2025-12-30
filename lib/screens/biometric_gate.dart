import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';

class BiometricGate extends StatefulWidget {
  final Widget child;

  const BiometricGate({super.key, required this.child});

  @override
  State<BiometricGate> createState() => _BiometricGateState();
}

class _BiometricGateState extends State<BiometricGate> {
  final LocalAuthentication _auth = LocalAuthentication();

  bool _authorized = false;
  bool _checkingSupport = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _authorized = false;
    _error = null;
    _checkBiometricSupport();
  }

  Future<void> _checkBiometricSupport() async {
    try {
      final supported = await _auth.isDeviceSupported();
      final canCheck = await _auth.canCheckBiometrics;

      if (!supported || !canCheck) {
        setState(() {
          _error =
              'Perangkat ini tidak mendukung autentikasi biometrik.';
        });
      }
    } catch (_) {
      _error = 'Gagal mengecek dukungan biometrik';
    } finally {
      setState(() {
        _checkingSupport = false;
      });
    }
  }

  Future<void> _authenticate() async {
    setState(() {
      _error = null;
    });

    try {
      final authenticated = await _auth.authenticate(
        localizedReason: 'Verifikasi biometrik untuk melanjutkan',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: false,
        ),
      );

      if (!mounted) return;

      if (authenticated) {
        setState(() {
          _authorized = true;
        });
      } else {
        setState(() {
          _error = 'Autentikasi biometrik dibatalkan';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Autentikasi biometrik gagal';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingSupport) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_authorized) {
      return widget.child;
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.fingerprint, size: 72),
              const SizedBox(height: 16),
              const Text(
                'Autentikasi Biometrik Diperlukan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              if (_error != null)
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _authenticate,
                child: const Text('Verifikasi Biometrik'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
