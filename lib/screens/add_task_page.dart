import 'package:flutter/material.dart';
import 'package:flutter_ui_class/providers/task_management_provider.dart';
import 'package:flutter_ui_class/utils/validators.dart';
import 'package:flutter_ui_class/widgets/core_input_field.dart';
import 'package:flutter_ui_class/widgets/password_input_filed.dart';
import 'package:provider/provider.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _titleController = TextEditingController();
  final _assignedToController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  late TaskManagementProvider taskProvider;

  @override
  void initState() {
    taskProvider = Provider.of<TaskManagementProvider>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _assignedToController.dispose();
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Task"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                CoreInputField(
                  controller: _titleController,
                  labelText: "Task Title",
                  validator: CustomValidators.validateTaskTitle,
                ),
                const SizedBox(height: 20),
                CoreInputField(
                  controller: _assignedToController,
                  labelText: "Assigned To",
                  validator: CustomValidators.validateAssignedTo,
                ),
                const SizedBox(height: 20),
                CoreInputField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  labelText: "Phone Number",
                  validator: CustomValidators.validatePhoneNumber,
                ),
                const SizedBox(height: 20),
                PasswordInputFiled(controller: _passwordController),
                const SizedBox(height: 20),
                CoreInputField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 6,
                  labelText: "Task Description",
                  validator: CustomValidators.validateDescription,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await taskProvider.addTaskToFirebase(
                title: _titleController.text,
                assignedTo: _assignedToController.text,
                phoneNumber: _phoneNumberController.text,
                password: _passwordController.text,
                description: _descriptionController.text,
              );

              Navigator.of(context).pop();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Task added successfully!"),
                  backgroundColor: Colors.green,
                ),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purpleAccent,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          child: const Text("Add Task"),
        ),
      ),
    );
  }
}