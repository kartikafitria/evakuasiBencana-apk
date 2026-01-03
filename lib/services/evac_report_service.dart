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
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception("Silakan login terlebih dahulu");
    }

    await _db.collection('evac_reports').add({
      'title': title.trim(),
      'description': description.trim(),
      'location': location.trim(),
      'userId': user.uid,
      'createdAt': Timestamp.now(),
    });
  }

  // ================= READ =================
  Stream<List<EvacReport>> getReports() {
    return _db
        .collection('evac_reports')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EvacReport.fromFirestore(doc))
              .toList(),
        );
  }

  // ================= UPDATE =================
  Future<void> updateReport({
    required EvacReport report,
    required String title,
    required String description,
    required String location,
  }) async {
    final user = _auth.currentUser;

    if (user == null || user.uid != report.userId) {
      throw Exception("Anda tidak berhak mengedit laporan ini");
    }

    await _db.collection('evac_reports').doc(report.id).update({
      'title': title.trim(),
      'description': description.trim(),
      'location': location.trim(),
    });
  }

  // ================= DELETE =================
  Future<void> deleteReport(EvacReport report) async {
    final user = _auth.currentUser;

    if (user == null || user.uid != report.userId) {
      throw Exception("Anda tidak berhak menghapus laporan ini");
    }

    await _db.collection('evac_reports').doc(report.id).delete();
  }
}
