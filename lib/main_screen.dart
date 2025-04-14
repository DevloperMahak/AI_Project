import 'package:ask_my_tutor/userprofile.dart';
import 'package:flutter/material.dart';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

import 'chat.dart';
import 'history.dart';
import 'home.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [AskMeHomePage(), HistoryPage(),ChatPage(), ProfilePage()];

  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.history_edu_rounded,
    Icons.chat,
    Icons.person_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final activeColor = Colors.deepPurple;
    final inactiveColor = isDark ? Colors.white60 : Colors.grey;
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xff5F2C82),
        child: const Icon(Icons.mic,color: Colors.grey,),
        onPressed: () {
          // Future voice feature
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _selectedIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Colors.white,
        activeColor: Color(0xff5F2C82),
        inactiveColor: Colors.grey,
        splashColor:Color(0xff5F2C82),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
