import 'package:flutter/material.dart';
import 'package:flutter_ui_class/utils/validators.dart';
import 'package:flutter_ui_class/widgets/core_input_field.dart';
import 'package:flutter_ui_class/widgets/password_input_filed.dart';

import '../models/task_model.dart'; 
import '../repositories/task_repository.dart';

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
        title: const Text("Add Task to Firebase"),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView( // Added scroll view to prevent overflow
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CoreInputField(
                  controller: _titleController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  labelText: "Task Title",
                  validator: CustomValidators.validateTaskTitle,
                ),
                const SizedBox(height: 20),
                CoreInputField(
                  controller: _assignedToController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  labelText: "Assigned To",
                  validator: CustomValidators.validateAssignedTo,
                ),
                const SizedBox(height: 20),
                CoreInputField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  maxLines: 1,
                  labelText: "Phone Number",
                  validator: CustomValidators.validatePhoneNumber,
                ),
                const SizedBox(height: 20),
                PasswordInputFiled(controller: _passwordController),
                const SizedBox(height: 40),
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
              // 1. Prepare the detailed description string
              final String fullDetails =
                  "Assigned: ${_assignedToController.text}\n"
                  "Phone: ${_phoneNumberController.text}\n"
                  "Notes: ${_descriptionController.text}";

              // 2. Create the Task object using your Firebase model
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                description: fullDetails,
                createdAt: DateTime.now(),
              );

              // 3. Call the Repository to save to Firestore
              try {
                await TaskRepository().addTask(newTask);

                if (mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Task synced with Firebase!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Error: $e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
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