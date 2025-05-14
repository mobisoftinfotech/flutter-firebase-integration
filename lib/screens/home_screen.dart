import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:task_management_system/models/task.dart';
import 'package:task_management_system/screens/add_task_screen.dart';
import 'package:task_management_system/screens/login_screen.dart';
import 'package:task_management_system/screens/profile_screen.dart';
import 'package:task_management_system/utilities/auth_service.dart';
import 'package:task_management_system/utilities/common_utilities.dart';
import 'package:task_management_system/utilities/database_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task>? _taskList;

  @override
  void initState() {
    super.initState();
    _fetchTaskList();
  }

  Future<void> _fetchTaskList() async {
    final tasks = await DatabaseService().fetchTasks();
    setState(() {
      _taskList = tasks;
    });
  }

  _signOurButtonClicked() async {
    try {
      await AuthService().signOut();
      DatabaseService().clearUID();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        height: 50,
        margin: const EdgeInsets.all(10),
        child: ElevatedButton(
          onPressed: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AddTaskScreen(task: Task())));
            _fetchTaskList();
          },
          child: const Center(
            child: Text('Add Task'),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5), //Colors.black12,
        title: const Text("Task Management"),
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              _fetchTaskList();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                "Refresh",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _signOurButtonClicked();
            },
            child: const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.blueAccent, fontSize: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProfileScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Image.asset(
                'assets/images/profile_icon.png',
                fit: BoxFit.cover,
                height: 25,
                width: 25,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white38,
          child: _taskList == null
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _taskList!.length,
                  itemBuilder: (context, index) {
                    return _listItemBuilder(index, context);
                  },
                ),
        ),
      ),
    );
  }

  Widget _listItemBuilder(int index, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white70,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: _listTileWidget(index, context),
      ),
    );
  }

  Widget _listTileWidget(int index, BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(right: 8, left: 8),
      title: Row(
        children: [
          const Text("Title : ", style: TextStyle(fontWeight: FontWeight.w700)),
          Text(_taskList![index].taskName ?? "")
        ],
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                "Owner : ",
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(_taskList![index].owner ?? "",
                  style: const TextStyle(fontSize: 14)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Description : ",
                  style: TextStyle(fontWeight: FontWeight.w700)),
              Expanded(
                  child: Text(_taskList![index].description ?? "",
                      style: const TextStyle(fontSize: 14)))
            ],
          )
        ],
      ),
      trailing: _listTrailingWidget(context, index),
    );
  }

  Widget _listTrailingWidget(BuildContext context, int index) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () async {
            await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AddTaskScreen(task: _taskList![index])));
            _fetchTaskList();
          },
          child: const Text(
            "Edit",
            style: TextStyle(color: Colors.blueAccent, fontSize: 14),
          ),
        ),
        GestureDetector(
          onTap: () {
            _onDeleteButtonClicked(index);
          },
          child: const Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.blueAccent, fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  _onDeleteButtonClicked(int index) {
    DatabaseService().deleteTask(_taskList![index].id ?? "");
    CommonUtils.showToast(context, "Record deleted successfully");
    _fetchTaskList();
  }
}
