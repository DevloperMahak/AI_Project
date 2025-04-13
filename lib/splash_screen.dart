import 'dart:async';

import 'package:ask_my_tutor/login.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'main_screen.dart';

String? finalEmail;

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => SplashScreenPage();
}

class SplashScreenPage extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    finalEmail = prefs.getString('email');
    print('Saved email: $finalEmail');

    // Wait for splash duration
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffEBEAE7),
      ),
      body: Container(
        color: const Color(0xffE7E7E6),
        child: Center(
            child: Image.asset(
                'assets/images/Askmytutor.png')),
      ),
    );
  }
}