import 'package:flutter/material.dart';
import 'package:task_management_system/utilities/database_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String email = "";

  @override
  void initState() {
    super.initState();
    email = DatabaseService().loginUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black12,
          title: const Text("Profile"),
        ),
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  const Text("Email : ",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text(
                    email,
                    style: const TextStyle(fontSize: 16),
                  )
                ]))));
  }
}
