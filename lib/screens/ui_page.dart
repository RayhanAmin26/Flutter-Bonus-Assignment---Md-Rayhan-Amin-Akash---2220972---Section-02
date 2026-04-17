import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_management_provider.dart';
import '../screens/add_task_page.dart';        // তোমার ফাইলের নাম
import '../widgets/task_card_widget.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("IUB Task Manager"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Consumer<TaskManagementProvider>(
        builder: (context, taskProvider, child) {
          return RefreshIndicator(
            onRefresh: () async {
              // Stream নিজে আপডেট করে, তাই খালি রাখলাম
              await Future.delayed(const Duration(milliseconds: 300));
            },
            child: taskProvider.tasks.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.task_alt_rounded, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text("No tasks yet", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: taskProvider.tasks.length,
                    itemBuilder: (context, index) {
                      final task = taskProvider.tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TaskCardWidget(
                          title: task.title,
                          subtitle: task.subtitle,
                          icon: task.icon,
                        ),
                      );
                    },
                  ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTaskPage()),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.purpleAccent,
      ),
    );
  }
}