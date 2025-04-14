import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(
                'assets/profile.jpg',
              ), // Add your image
            ),
            const SizedBox(height: 15),
            const Text(
              'John Doe',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Text(
              'Student | AskMe User',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xff5F2C82)),
              title: const Text('john.doe@example.com'),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xff5F2C82)),
              title: const Text('App Settings'),
              onTap: () {}, // Future settings page
            ),
            ListTile(
              leading: const Icon(Icons.logout, color:Color(0xff5F2C82)),
              title: const Text('Logout'),
              onTap: () {
                // Add logout logic
              },
            ),
          ],
        ),
      ),
    );
  }
}
