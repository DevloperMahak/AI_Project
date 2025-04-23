import 'dart:convert';
import 'package:ask_my_tutor/uihelper.dart';
import 'package:ask_my_tutor/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();

  void sendResetLink(String email) async {
    if (email.isEmpty) {
      UiHelper.CustomAlertBox(context, "Please enter your email");
      return;
    }

    try {
      var response = await http.post(
        Uri.parse(forgotpassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      var data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['status'] == true) {
        UiHelper.CustomAlertBox(context, "Reset link sent to your email.");
      } else {
        UiHelper.CustomAlertBox(context, data['message'] ?? "Error occurred");
      }
    } catch (e) {
      UiHelper.CustomAlertBox(context, "Something went wrong.\n$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
        backgroundColor: Color(0xff5F2C82),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff5F2C82),
                Color(0xffA83279),],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text("Enter your email to receive a reset link."),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendResetLink(emailController.text.trim());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff5F2C82),
              ),
              child: const Text("Send Reset Link"),
            ),
          ],
        ),
      ),
    );
  }
}
