import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ask_my_tutor/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }

  Future<void> fetchUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('email');

    print('Stored Email: $storedEmail'); // Debugging

    if (storedEmail != null) {
      final response = await http.get(
        Uri.parse('$details?email=$storedEmail'),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}'); // 👈 DEBUG print

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Decoded Data: $data'); // 👈 Check what’s inside
        setState(() {
          name = data['name'] ?? '';
          email = data['email'] ?? '';
        });
      } else {
        print('Failed to load user details');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:Color(0xff5F2C82),
        foregroundColor: Colors.white,
        title: const Text('My Profile'),
        centerTitle: true,
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/images/Profile.png',
              ), // Add your image
            ),
            const SizedBox(height: 15),
             Text(
              name.isNotEmpty ? name : 'User Name',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Student | AskMyTutor User',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xff5F2C82)),
              title: Text(email.isNotEmpty ? email : 'Youremail@gmail.com'),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xff5F2C82)),
              title: const Text('App Settings'),
              onTap: () {}, // Future settings page
            ),
            ListTile(
              leading: const Icon(Icons.logout, color:Color(0xff5F2C82)),
              title: const Text('Logout'),
              onTap: () async  {
                // Add logout logic
                  final SharedPreferences sharedPreferences =
                      await SharedPreferences.getInstance();
                  sharedPreferences.remove('email');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginPage(),
                      ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
