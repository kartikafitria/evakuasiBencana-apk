import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/evac_report.dart';

class EvacReportService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================= CREATE =================
  Future<void> addReport({
    required String title,
    required String description,
    required String location,
  }) async {
    try {
      final user = _auth.currentUser;

      if (user == null) {
        throw Exception("Silakan login terlebih dahulu");
      }

      await _db.collection('evac_reports').add({
        'title': title.trim(),
        'description': description.trim(),
        'location': location.trim(),
        'createdBy': user.uid,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      // 🔴 lempar ulang supaya UI tahu
      throw Exception(e.toString());
    }
  }

  // ================= READ =================
  Stream<List<EvacReport>> getReports() {
    return _db
        .collection('evac_reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => EvacReport.fromFirestore(doc)).toList());
  }

  // ================= UPDATE =================
  Future<void> updateReport({
    required String id,
    required String title,
    required String description,
    required String location,
  }) async {
    await _db.collection('evac_reports').doc(id).update({
      'title': title.trim(),
      'description': description.trim(),
      'location': location.trim(),
    });
  }

  // ================= DELETE =================
  Future<void> deleteReport(String id) async {
    await _db.collection('evac_reports').doc(id).delete();
  }
}
