import 'package:flutter/material.dart';
import 'package:flutter_ui_class/screens/add_task_page.dart';
import 'package:flutter_ui_class/widgets/task_card_widget.dart';

// --- ADD THESE IMPORTS ---
import '../models/task_model.dart';
import '../repositories/task_repository.dart';

class UiPage extends StatefulWidget {
  const UiPage({super.key});

  @override
  State<UiPage> createState() => _UiPageState();
}

class _UiPageState extends State<UiPage> {
  // Access our repository
  final TaskRepository _repository = TaskRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase Task List"),
        backgroundColor: Colors.purpleAccent,
      ),

      // Task 6: Use StreamBuilder for real-time updates
      body: StreamBuilder<List<Task>>(
        stream: _repository.getTasks(),
        builder: (context, snapshot) {
          // Handle Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Handle Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          // Handle Empty State
          final tasks = snapshot.data ?? [];
          if (tasks.isEmpty) {
            return const Center(child: Text("No tasks found in Firebase."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              // Using your existing TaskCardWidget
              return Stack(
                children: [
                  TaskCardWidget(
                    title: task.title,
                    subtitle: task.description,
                    icon: Icons.cloud, // Default icon
                  ),
                  // Task 4: Delete Button
                  Positioned(
                    right: 10,
                    top: 10,
                    child: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () async {
                        await _repository.deleteTask(task.id);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Task Deleted")),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AddTaskPage()),
          );
        },
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}