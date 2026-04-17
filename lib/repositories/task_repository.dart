import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskRepository {
  // Collection name in Firestore
  final CollectionReference _tasks = 
      FirebaseFirestore.instance.collection('tasks');

  // Task 4: Add Task
  Future<void> addTask(Task task) async {
    // We use the task.id as the document name for easy lookup
    await _tasks.doc(task.id).set(task.toJson());
  }

  // Task 4: Delete Task
  Future<void> deleteTask(String id) async {
    await _tasks.doc(id).delete();
  }

  // Task 6: Stream for real-time list
  Stream<List<Task>> getTasks() {
    return _tasks.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Task.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}