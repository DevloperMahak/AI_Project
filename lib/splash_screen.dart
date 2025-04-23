import 'dart:async';

import 'package:ask_my_tutor/home.dart';
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
    getValidationData().whenComplete(()async{
      Timer(Duration(seconds: 5),(){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context)=>(finalEmail == null ? LoginPage(): MainScreen())
            ));
      });
    });
    super.initState();
  }

  Future getValidationData()async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getString('email');
    setState(() {
      finalEmail = obtainedEmail;
    });
    print(finalEmail);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffE7E7E6),
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