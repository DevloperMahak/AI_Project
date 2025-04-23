import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  late IO.Socket socket;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _connectToServer();
  }

  void _connectToServer() {
    socket = IO.io('http://192.168.58.59:5001', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket.connect();

    socket.onConnect((_) {
      print('Connected to socket server');
    });

    socket.on('receive_message', (data) {
      setState(() {
        _messages.add({'sender': data['sender'], 'text': data['text']});
      });
    });
  }

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _isSending = true; // Start loading
    });

    // Send message to other users through the server
    socket.emit('send_message', {
      'sender': 'user',// you can replace with username or userId later
      'text': message,
    });

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _controller.clear();// Clear the input after sending the message
    });
      // Simulate receiving response after 1 second
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          // Update the status to 'sent'
          _messages.last['status'] = 'sent';
          _isSending = false; // Stop loading
        });
    });
  }

  Widget _buildMessage(String text, bool isUser, String status) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isUser ? Colors.deepPurple : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            if (status == 'sending')
              const SizedBox(width: 10),
            if (status == 'sending')
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true, // ✅ Ensures layout adjusts with keyboard
        appBar: AppBar(
          title: const Text('Student Chat'),
          centerTitle: true,
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
        body:SafeArea( // ✅ Keeps UI safe from notches and keyboard
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: false,
                  padding: const EdgeInsets.all(10),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    final isUser = msg['sender'] == 'user';
                    final status = msg['status'] ?? 'sent'; // Default to 'sent' if status is not defined
                    return _buildMessage(msg['text']!, isUser,status);
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2)],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Type your message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.deepPurple),
                      onPressed: _sendMessage,
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
    );
  }
}

