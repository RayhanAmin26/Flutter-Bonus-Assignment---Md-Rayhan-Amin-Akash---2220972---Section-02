import 'package:cloud_firestore/cloud_firestore.dart';

class TaskModel {
  final String id;
  final String title;
  final String assignedTo;
  final String phoneNumber;
  final String password;
  final String description;
  final DateTime createdAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.assignedTo,
    required this.phoneNumber,
    required this.password,
    required this.description,
    required this.createdAt,
  });

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      assignedTo: data['assignedTo'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      password: data['password'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'assignedTo': assignedTo,
      'phoneNumber': phoneNumber,
      'password': password,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}