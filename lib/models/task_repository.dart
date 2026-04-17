import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';   // তোমার TaskModel

class TaskRepository {
  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection('tasks');

  // ==================== Add Task ====================
  Future<void> addTask(TaskModel task) async {
    await _tasksCollection.add(task.toFirestore());
  }

  // ==================== Delete Task ====================
  Future<void> deleteTask(String docId) async {
    await _tasksCollection.doc(docId).delete();
  }

  // ==================== Real-time Tasks Stream ====================
  Stream<List<TaskModel>> getTasks() {
    return _tasksCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }
}