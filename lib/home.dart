import 'dart:convert';

import 'package:ask_my_tutor/theme_provider.dart';
import 'package:ask_my_tutor/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class AskMeHomePage extends StatefulWidget {
  const AskMeHomePage({Key? key}) : super(key: key);

  @override
  State<AskMeHomePage> createState() => _AskMeHomePageState();
}

class _AskMeHomePageState extends State<AskMeHomePage> {
  String? aiResponse = "Hi! I'm your tutor. Ask me anything using voice or image.";
  final TextEditingController _textController = TextEditingController();
  bool _isListening = false;
  late stt.SpeechToText _speech;
  String _spokenText = "";

  // 🔥 Subjects for dropdown
  final List<String> _subjects = ['General', 'Math', 'Programming', 'Science', 'History'];
  String _selectedSubject = 'General';

  Future<void> sendPromptToGROQ(String prompt) async {
    final url = Uri.parse(doubt); // use your actual backend URL

    print('Sending prompt to backend: $prompt');  // Add this log to check the prompt

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'prompt': prompt,
          'subject': _selectedSubject, // 👈 Send subject to backend
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          aiResponse = data['answer']; // display the AI's response
        });
      } else {
        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        setState(() {
          aiResponse = 'Failed to get a response from the tutor.';
        });
      }
    } catch (e) {
      setState(() {
        aiResponse = 'Error connecting to server: $e';
      });
    }
  }
  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) => print('Status: $status'),
      onError: (error) => print('Error: $error'),
    );
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _textController.text = result.recognizedWords;
            // Display recognized text
          });
        },
      );
    }
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Color(0xff5F2C82),
        foregroundColor: Colors.white,
        title: const Text('AskMe'),
        centerTitle: true,
        elevation: 0,
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Welcome to AskMe!',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'Your AI-powered tutor. Speak or snap a math problem and get instant help.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            // 🔽 Subject Dropdown
            const SizedBox(height: 30),
            DropdownButtonFormField<String>(
              value: _selectedSubject,
              items: _subjects
                  .map((subject) => DropdownMenuItem(
                value: subject,
                child: Text(subject),
              ))
                  .toList(),
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedSubject = value!;
                });
              },
            ),
            Container(
              width: 360,
              height: 55,
              margin: EdgeInsets.only(top: 50),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(30))
              ),
              child: TextField(
                controller: _textController,
                readOnly: false, //This allows both voice and manual input.
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Color(0xff3D4652), size: 20),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          _isListening ? Icons.mic : Icons.mic_none,
                          color: _isListening ? Colors.red : Color(0xff3D4652),
                        ),
                        onPressed: () {
                          if (_isListening) {
                            _stopListening();
                          } else {
                            _startListening();
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Color(0xff3D4652)),
                        onPressed: () {
                          final input = _textController.text.trim();
                          if (input.isNotEmpty) {
                            setState(() {
                              aiResponse = "Thinking...";
                            });
                            sendPromptToGROQ(input);
                          }
                        },
                      ),
                    ],
                  ),

                  hintText: 'Ask Your Doubt Here',
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(30)),
                      borderSide: BorderSide(
                          color: Colors.white
                      )),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(30)),
                      borderSide: BorderSide(color: Color(0xff5F2C82))),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Color(0xffA83279)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                aiResponse ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                // Add voice input logic
              },
              icon: const Icon(Icons.mic,color: Colors.white,),
              label: const Text('Ask by Voice'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff5F2C82),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Add image upload logic
              },
              icon: const Icon(Icons.camera_alt,color: Colors.white,),
              label: const Text('Upload Image'),
              style: ElevatedButton.styleFrom(
                backgroundColor:  Color(0xffA83279),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

