import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // ================= REGISTER =================
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.register(
        name: name,
        email: email,
        password: password,
      );
      return true;
    } finally {
      _setLoading(false);
    }
  }

  // ================= LOGIN EMAIL =================
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      await _authService.loginEmail(
        email: email,
        password: password,
      );
    } finally {
      _setLoading(false);
    }
  }

  // ================= LOGIN GOOGLE =================
  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
    } finally {
      _setLoading(false);
    }
  }
}
