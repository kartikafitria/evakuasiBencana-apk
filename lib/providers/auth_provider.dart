import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  User? _user;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    // 🔥 SETIAP APP DIBUKA → LOGOUT
    await _firebaseAuth.signOut();

    _firebaseAuth.authStateChanges().listen((user) {
      _user = user;
      _isLoading = false;
      notifyListeners();
    });
  }

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;

  // 🔵 GOOGLE LOGIN
  Future<void> signInWithGoogle() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.signInWithGoogle();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 🔐 EMAIL LOGIN
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _authService.loginEmail(
        email: email,
        password: password,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    notifyListeners();
  }

  register({required String name, required String email, required String password}) {}
}
