import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  // This would be fetched from storage/database in future
  final List<Map<String, String>> mockHistory = const [
    {
      'question': 'What is the derivative of x²?',
      'answer': 'The derivative of x² is 2x.',
    },
    {
      'question': 'Simplify 5x - 3x + 2',
      'answer': 'The simplified result is 2x + 2.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5F2C82),
        foregroundColor: Colors.white,
        title: const Text('History'),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: mockHistory.length,
        itemBuilder: (context, index) {
          final item = mockHistory[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: ListTile(
              title: Text(
                'Q: ${item['question']}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('A: ${item['answer']}'),
              leading: const Icon(
                Icons.question_answer,
                color: Color(0xff5F2C82),
              ),
            ),
          );
        },
      ),
    );
  }
}
