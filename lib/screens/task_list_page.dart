import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/card_data_model.dart';
import '../providers/task_management_provider.dart';
import 'add_task_page.dart';

class TaskListPage extends StatelessWidget {
  const TaskListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUB Task Manager"),
        backgroundColor: Colors.purpleAccent,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<CardDataModel>>(
        stream: context.watch<TaskManagementProvider>().tasksStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data ?? [];

          if (tasks.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.task_alt_rounded, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No tasks yet.\nTap + to add new task",
                      textAlign: TextAlign.center, style: TextStyle(fontSize: 18)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            addAutomaticKeepAlives: false,      // ← memory বাঁচায়
            addRepaintBoundaries: true,
            cacheExtent: 300,
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  leading: const Icon(Icons.task_alt_rounded, color: Colors.purple, size: 35),
                  title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      task.subtitle,
                      maxLines: 4,                    // ← খুব গুরুত্বপূর্ণ
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13.5, height: 1.4),
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent, size: 28),
                    onPressed: () {
                      context.read<TaskManagementProvider>().deleteTaskByIndex(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AddTaskPage())),
        backgroundColor: Colors.purpleAccent,
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}