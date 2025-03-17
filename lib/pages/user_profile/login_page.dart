import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:docpechayapp/pages/user_profile/signup.dart';
import 'package:docpechayapp/pages/Navigation.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Navigation()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password reset email sent! Check your inbox.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  void continueAsGuest() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Navigation()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, obscureText: true, decoration: InputDecoration(labelText: "Password")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: login, child: const Text("Login")),
            TextButton(onPressed: continueAsGuest, child: const Text("Continue as Guest")),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => SignUpPage()));
                },
                child: const Text("Sign Up")),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController emailController = TextEditingController();
                        return AlertDialog(
                          title: const Text("Reset Password"),
                          content: TextField(
                            controller: emailController,
                            decoration: const InputDecoration(labelText: "Enter your email"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                resetPassword(emailController.text.trim());
                                Navigator.pop(context);
                              },
                              child: const Text("Send"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text("Forgot Password?"),
                ),
          ],
        ),
      ),
    );
  }
}
