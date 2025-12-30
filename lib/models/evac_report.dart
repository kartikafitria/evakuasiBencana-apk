import 'package:cloud_firestore/cloud_firestore.dart';

class EvacReport {
  final String id;
  final String title;
  final String description;
  final String location;
  final String userId; // 🔥 konsisten
  final Timestamp createdAt;

  EvacReport({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.userId,
    required this.createdAt,
  });

  factory EvacReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EvacReport(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      userId: data['userId'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
