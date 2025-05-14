import 'package:flutter/material.dart';
import 'package:task_management_system/screens/home_screen.dart';
import 'package:task_management_system/screens/signup_screen.dart';
import 'package:task_management_system/utilities/auth_service.dart';
import 'package:task_management_system/utilities/common_utilities.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                        style: TextStyle(fontSize: 24, color: Colors.black),
                        "Login"),
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
                      decoration: CommonUtils.getInputDecoration(
                          context, "Enter Email"),
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
                      decoration: CommonUtils.getInputDecoration(
                          context, "Enter Password"),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () {
                            loginButtonClicked(context);
                          },
                          child: const Text("Login")),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.black, fontSize: 14),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()),
                            );
                          },
                          child: const Text(
                            "Signup",
                            style: TextStyle(color: Colors.red, fontSize: 14),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                          onPressed: () async {
                            signInWithGoogleButtonClicked(context);
                          },
                          child: const Text("SignIn With Google")),
                    ),
                  ],
                ),
                Visibility(
                    visible: isLoading,
                    child: const Center(child: CircularProgressIndicator()))
              ],
            )),
      ),
    );
  }

  void loginButtonClicked(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (performValidation(context, email, password)) {
      final user = await AuthService()
          .loginWithEmailAndPassword(context, email, password);
      setState(() {
        isLoading = false;
      });
      if (user != null) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      setState(() {
        isLoading = false;
      });
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

  void signInWithGoogleButtonClicked(BuildContext context) async {
    final userCred = await AuthService().signInWithGoogle();
    if (userCred != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }
}
