import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  User? _user;

  AuthProvider() {
    _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  User? get user => _user;

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
    } finally {
      _setLoading(false);
    }
  }

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

  // ================= REGISTER =================
  Future<void> register({
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
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  registerEmail({required String email, required String password}) {}
}
