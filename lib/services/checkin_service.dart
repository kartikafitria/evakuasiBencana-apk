import 'package:cloud_firestore/cloud_firestore.dart';

class CheckInService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> saveCheckIn({
    required String location,
  }) async {
    await _db.collection('evac_checkins').add({
      'location': location,
      'timestamp': Timestamp.now(),
      'device': 'android',
    });
  }
}
