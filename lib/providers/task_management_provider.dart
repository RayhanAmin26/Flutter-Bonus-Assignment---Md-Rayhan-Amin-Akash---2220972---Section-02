import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../models/card_data_model.dart';

class TaskManagementProvider with ChangeNotifier {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  List<CardDataModel> tasks = [];

  // ==================== Real-time Stream (Optimized) ====================
  Stream<List<CardDataModel>> get tasksStream {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .limit(50)                    // ← এটা যোগ করা হয়েছে (memory বাঁচাতে)
        .snapshots()
        .map((snapshot) {
      tasks = snapshot.docs.map((doc) {
        final task = TaskModel.fromFirestore(doc);

        // Subtitle আরও ছোট ও safe করা হয়েছে (memory অনেক কম খাবে)
        String subtitle = 
            "Assigned: ${task.assignedTo}\n"
            "Phone: ${task.phoneNumber}\n"
            "Desc: ${task.description.length > 80 
                ? '${task.description.substring(0, 77)}...' 
                : task.description}";

        return CardDataModel(
          title: task.title,
          subtitle: subtitle,
          icon: Icons.task_alt_rounded,
        );
      }).toList();

      return tasks;
    });
  }

  // ==================== Add Task ====================
  Future<void> addTaskToFirebase({
    required String title,
    required String assignedTo,
    required String phoneNumber,
    required String password,
    required String description,
  }) async {
    final newTask = TaskModel(
      id: '',
      title: title,
      assignedTo: assignedTo,
      phoneNumber: phoneNumber,
      password: password,
      description: description,
      createdAt: DateTime.now(),
    );

    await _tasksCollection.add(newTask.toFirestore());
  }

  // ==================== Delete Task ====================
  Future<void> deleteTask(String docId) async {
    await _tasksCollection.doc(docId).delete();
  }

  // ==================== Delete by Index ====================
  Future<void> deleteTaskByIndex(int index) async {
    if (index < 0 || index >= tasks.length) return;

    try {
      final snapshot = await _tasksCollection
          .orderBy('createdAt', descending: true)
          .get();

      if (index < snapshot.docs.length) {
        final docId = snapshot.docs[index].id;
        await _tasksCollection.doc(docId).delete();
      }
    } catch (e) {
      debugPrint("❌ Delete Error: $e");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}