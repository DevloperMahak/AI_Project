import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/history_item.dart';
import 'dart:convert';

class HistoryPage extends StatefulWidget {
  final List<HistoryItem> historyList;
  const HistoryPage({Key? key, required this.historyList}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

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
  late List<HistoryItem> _historyList;
  // Track visibility of each answer
  late List<bool> _showAnswer;

  @override
  void initState() {
    super.initState();
    _historyList = List.from(widget.historyList); // Make editable copy
    _showAnswer = List<bool>.filled(widget.historyList.length, false);
  }

  Future<void> _deleteHistoryItem(int index) async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _historyList.removeAt(index);
      _showAnswer.removeAt(index);
    });

    // Save updated list
    final updatedHistoryJson =
    _historyList.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList('history', updatedHistoryJson);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff5F2C82),
        foregroundColor: Colors.white,
        title: const Text('History'),
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
        actions: [
          InkWell(
              onTap: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('history');
                setState(() {
                  _historyList.clear();
                });
              },
              child: Padding(
                  padding: EdgeInsets.only(
                      right:10 ),
                  child: Icon(
                    Icons.delete, size: 28,
                    color: Colors.white,))
          )],
      ),
      body: _historyList.isEmpty
          ? Center(child: Text('No history found'))
          :ListView.builder(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 90), // add bottom padding
        itemCount: _historyList.length,
        itemBuilder: (context, index) {
          final item = _historyList[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child:  Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      Icon(
                        Icons.question_answer,
                        color: Color(0xff5F2C82),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Q:',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                        item.question,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _showAnswer[index]
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down,
                          color: const Color(0xffA83279),
                        ),
                        onPressed: () {
                          setState(() {
                            _showAnswer[index] = !_showAnswer[index];
                          });
                        },
                      ),
    IconButton(
    icon: const Icon(Icons.delete,
    color: Colors.redAccent),
    onPressed: () {
      showDialog(
        context: context,
        builder: (ctx) =>
            AlertDialog(
              title: const Text("Confirm Delete"),
              content: const Text(
                  "Are you sure you want to delete this item?"),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () => Navigator.pop(ctx),
                ),
                TextButton(
                  child: const Text("Delete"),
                  onPressed: () {
                    Navigator.pop(ctx);
                    _deleteHistoryItem(index);
                  },
                ),
              ],
            ),
      );
    }),
                    ],
                  ),
                  const SizedBox(height: 5),
                if (_showAnswer[index]) ...[
                    const SizedBox(height: 6),
                    Text(
                      'A: ${item.answer}',
                      style: const TextStyle(fontSize: 15),
                    ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
