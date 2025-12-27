import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ================= REGISTER =================
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception("Registrasi gagal");
      }

      // 🔥 SIMPAN DATA USER KE FIRESTORE (DENGAN TIMEOUT)
      await _db
          .collection('users')
          .doc(user.uid)
          .set({
            'name': name,
            'email': email,
            'createdAt': Timestamp.now(),
          })
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () {
              throw Exception("Koneksi Firestore timeout");
            },
          );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email sudah terdaftar');
      } else if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah');
      } else {
        throw Exception(e.message);
      }
    }
  }

  // ================= LOGIN EMAIL =================
  Future<void> loginEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Email belum terdaftar');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah');
      } else {
        throw Exception(e.message);
      }
    }
  }

  // ================= LOGIN GOOGLE =================
  Future<void> signInWithGoogle() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception("Login Google dibatalkan");
    }

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final result =
        await _auth.signInWithCredential(credential);

    final user = result.user;
    if (user == null) {
      throw Exception("Login Google gagal");
    }

    await _db.collection('users').doc(user.uid).set({
      'name': user.displayName,
      'email': user.email,
      'createdAt': Timestamp.now(),
    }, SetOptions(merge: true));
  }
}
