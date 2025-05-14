import 'package:flutter/material.dart';
import 'package:task_management_system/utilities/auth_service.dart';
import 'package:task_management_system/utilities/common_utilities.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                  style: TextStyle(fontSize: 24, color: Colors.black),
                  "Signup"),
              const SizedBox(height: 30),
              TextField(
                obscureText: false,
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                onChanged: (value) {},
                style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.0,
                    height: 1.0,
                    fontSize: 16),
                decoration:
                    CommonUtils.getInputDecoration(context, "Enter Name"),
              ),
              const SizedBox(height: 30),
              TextField(
                obscureText: false,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                onChanged: (value) {},
                style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.0,
                    height: 1.0,
                    fontSize: 16),
                decoration:
                    CommonUtils.getInputDecoration(context, "Enter Email"),
              ),
              const SizedBox(height: 30),
              TextField(
                obscureText: true,
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                autofocus: false,
                onChanged: (value) {},
                style: const TextStyle(
                    color: Colors.black,
                    letterSpacing: 0.0,
                    height: 1.0,
                    fontSize: 16),
                decoration:
                    CommonUtils.getInputDecoration(context, "Enter Password"),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                    onPressed: () {
                      signupButtonClicked(context);
                    },
                    child: const Text("Signup")),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void signupButtonClicked(BuildContext context) async {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (performValidation(context, email, password)) {
      final user = await AuthService()
          .createUserWithEmailAndPassword(context, email, password);
      if (user != null) {
        Navigator.pop(context);
        CommonUtils.showToast(context, "User created successfully.");
      }
    }
  }

  bool performValidation(BuildContext context, String email, String password) {
    if (email.isEmpty) {
      CommonUtils.showToast(context, "Please enter email address.");
      return false;
    } else if (password.isEmpty) {
      CommonUtils.showToast(context, "Please enter password.");
      return false;
    }
    return true;
  }
}
