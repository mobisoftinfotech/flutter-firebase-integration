import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_management_system/models/task.dart';

class DatabaseService {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

  final usersCollection = 'users';
  final taskCollection = 'task';

  Future<String> insertTask(Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .add(task.toMap());
      return "Record added successfully";
    } catch (e) {
      log(e.toString());
      if (e is FirebaseException) {
        return e.message ?? "";
      } else {
        return e.toString();
      }
    }
  }

  Future<List<Task>> fetchTasks() async {
    try {
      final QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .get();
      return snapshot.docs.map((doc) {
        final id = doc.id;
        final data = doc.data();
        if (data != null) {
          Task task = Task.fromMap(data as Map<String, dynamic>);
          task.id = id;
          return task;
        } else {
          return Task(id: '', taskName: '', description: '', owner: '');
        }
      }).toList();
    } catch (e) {
      log(e.toString());
    }
    return [];
  }

  Future<String> updateTask(String documentId, Task task) async {
    try {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .doc(documentId)
          .update(task.toMap());
      return "Record updated successfully";
    } catch (e) {
      log(e.toString());
      if (e is FirebaseException) {
        return e.message ?? "";
      } else {
        return e.toString();
      }
    }
  }

  Future<void> deleteTask(String documentId) async {
    try {
      FirebaseFirestore.instance
          .collection("user")
          .doc(uid)
          .collection("task")
          .doc(documentId)
          .delete();
    } catch (e) {
      log(e.toString());
    }
  }

  void clearUID() {
    uid = '';
  }

  String loginUserName() {
    return FirebaseAuth.instance.currentUser?.email ?? "";
  }
}
