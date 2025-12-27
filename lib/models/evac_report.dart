import 'package:cloud_firestore/cloud_firestore.dart';

class EvacReport {
  final String id;
  final String title;
  final String description;
  final String location;
  final String createdBy;
  final Timestamp createdAt;

  EvacReport({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.createdBy,
    required this.createdAt,
  });

  factory EvacReport.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return EvacReport(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      createdBy: data['createdBy'] ?? '',
      createdAt: data['createdAt'],
    );
  }
}
