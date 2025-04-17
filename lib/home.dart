import 'dart:convert';
import 'dart:io';

import 'package:ask_my_tutor/theme_provider.dart';
import 'package:ask_my_tutor/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
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
  final ImagePicker _picker = ImagePicker();
  File? _pickedImage;
  bool _isListening = false;
  late stt.SpeechToText _speech;
  String _spokenText = "";

  // 🔥 Subjects for dropdown
  final List<String> _subjects = ['General', 'Math', 'Programming', 'Science', 'History'];
  String _selectedSubject = 'General';

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Choose an option", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take a Photo"),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text("Choose from Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickImageFromGallery();
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        aiResponse = "Processing image...";
      });
      _sendImageToBackend();
    }
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
        aiResponse = "Processing image...";
      });
      _sendImageToBackend();
    }
  }

  Future<void> _sendImageToBackend() async {
    final uri = Uri.parse(doubt_img); // Your endpoint
    var request = http.MultipartRequest('POST', uri)
      ..fields['subject'] = _selectedSubject
      ..files.add(await http.MultipartFile.fromPath('image', _pickedImage!.path));

    try {
      final response = await request.send();
      final respStr = await response.stream.bytesToString();
      print("🧠 Backend response: $respStr");
      final data = jsonDecode(respStr);
      setState(() {
        aiResponse = data['answer'] ?? "No answer received.";
      });
    } catch (e) {
      setState(() {
        aiResponse = 'Error sending image: $e';
      });
    }
  }



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
      body:SafeArea(
    child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 30),
            const Text(
              'Welcome to AskMyTutor!',
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

            const SizedBox(height: 30),

            // Combined Question + Answer Container
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xffA83279)),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_textController.text.trim().isNotEmpty) ...[
                    const Text(
                      "Your Question:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xff5F2C82),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _textController.text,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Divider(height: 30, thickness: 1),
                  ],
                  const Text(
                    "Tutor's Answer:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xffA83279),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aiResponse ?? '',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  // Input Field inside the container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Ask Your Doubt Here',
                        prefixIcon: const Icon(Icons.search, color: Color(0xff3D4652)),
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                _isListening ? Icons.mic : Icons.mic_none,
                                color: _isListening ? Colors.red : const Color(0xff3D4652),
                              ),
                              onPressed: () {
                                _isListening ? _stopListening() : _startListening();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.camera_alt, color: Color(0xff3D4652)),
                              onPressed: () {
                                // TODO: Add image picker logic here
                                _showImagePickerOptions();
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.send, color: Color(0xff3D4652)),
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
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),



          ],
        ),
      ),
      )
    );
  }
}

