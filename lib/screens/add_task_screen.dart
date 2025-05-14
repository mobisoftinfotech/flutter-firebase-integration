import 'package:flutter/material.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/utilities/common_utilities.dart';
import 'package:task_management_system/utilities/database_service.dart';

class AddTaskScreen extends StatefulWidget {
  final Task task;
  AddTaskScreen({super.key, required this.task});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.task.id != null) {
      nameController.text = widget.task.taskName ?? "";
      emailController.text = widget.task.description ?? "";
      phoneController.text = widget.task.owner ?? "";
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(widget.task.id == null ? "Add Task" : "Update Task"),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            TextField(
              obscureText: false,
              controller: nameController,
              keyboardType: TextInputType.name,
              autofocus: false,
              onChanged: (value) {
                widget.task.taskName = value;
              },
              style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.0,
                  height: 1.0,
                  fontSize: 16),
              decoration:
                  CommonUtils.getInputDecoration(context, "Enter task name"),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: false,
              controller: emailController,
              keyboardType: TextInputType.text,
              autofocus: false,
              onChanged: (value) {
                widget.task.description = value;
              },
              style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.0,
                  height: 1.0,
                  fontSize: 16),
              decoration: CommonUtils.getInputDecoration(
                  context, "Enter task description"),
            ),
            const SizedBox(height: 20),
            TextField(
              obscureText: false,
              controller: phoneController,
              keyboardType: TextInputType.text,
              autofocus: false,
              onChanged: (value) {
                widget.task.owner = value;
              },
              style: const TextStyle(
                  color: Colors.black,
                  letterSpacing: 0.0,
                  height: 1.0,
                  fontSize: 16),
              decoration:
                  CommonUtils.getInputDecoration(context, "Enter task owner"),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  onPressed: () {
                    insertRecord(context);
                  },
                  child: Text(widget.task.id == null ? "Add" : "Update")),
            ),
          ],
        ),
      )),
    );
  }

  insertRecord(BuildContext context) async {
    String message = '';
    if (_checkValidations(context)) {
      if (widget.task.id == null) {
        message = await DatabaseService().insertTask(_getTask());
      } else {
        message =
            await DatabaseService().updateTask(widget.task.id!, _getTask());
      }
      CommonUtils.showToast(context, message);
      if (widget.task.id == null) {
        _clearInputFields();
      }
      Navigator.pop(context);
    }
  }

  _checkValidations(BuildContext context) {
    if (nameController.text.toString().isEmpty) {
      CommonUtils.showToast(context, "Please enter task name");
      return false;
    } else if (emailController.text.toString().isEmpty) {
      CommonUtils.showToast(context, "Please enter task description");
      return false;
    } else if (phoneController.text.toString().isEmpty) {
      CommonUtils.showToast(context, "Please enter task owner");
      return false;
    }
    return true;
  }

  _getTask() {
    return Task(
        taskName: nameController.text.toString().trim(),
        description: emailController.text.toString().trim(),
        owner: phoneController.text.toString().trim());
  }

  _clearInputFields() {
    nameController.text = "";
    emailController.text = "";
    phoneController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }
}
