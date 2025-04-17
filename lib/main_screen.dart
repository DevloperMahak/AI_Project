import 'package:ask_my_tutor/userprofile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
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
  FlutterTts flutterTts = FlutterTts(); // Initialize flutter_tts instance
  bool _isSpeaking = false; // Track if TTS is speaking

  final List<Widget> _pages = const [AskMeHomePage(), HistoryPage(),ChatPage(), ProfilePage()];

  final iconList = <IconData>[
    Icons.home_rounded,
    Icons.history_edu_rounded,
    Icons.chat,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();

    // Set handlers to track speech state
    flutterTts.setStartHandler(() {
      setState(() {
        _isSpeaking = true;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  // Function to speak the answer
  void _speakAnswer(String answer) async {
    await flutterTts.setLanguage("en-US"); // Set the language of speech
    await flutterTts.setPitch(1.0); // Set the pitch of speech (optional)
    await flutterTts.speak(answer); // Speak the answer text
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final activeColor = Colors.deepPurple;
    final inactiveColor = isDark ? Colors.white60 : Colors.grey;
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex],
      resizeToAvoidBottomInset: false,  // Prevents the FAB from moving up with the keyboard
      floatingActionButton: TweenAnimationBuilder<double>(
        tween: Tween<double>(begin: 0.0, end: _isSpeaking ? 20.0 : 0.0),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        builder: (context, glow, child) {
    return Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: [Color(0xff5F2C82), Color(0xffA83279)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
    if (_isSpeaking)
    BoxShadow(
    color: Colors.deepPurpleAccent.withOpacity(0.6),
    blurRadius: glow,
    spreadRadius: glow / 3,
    ),
    ],
    ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent, // Make the FAB background transparent
          child: const Icon(
            Icons.mic,
            color: Colors.white, // Icon color
          ),
          onPressed: () {
            // Future voice feature
            String answer = "Hello, this is your answer!";
            _speakAnswer(answer);  // Speak the answer aloud
          },
        ),
      );
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
