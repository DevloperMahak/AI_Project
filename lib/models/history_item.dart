// history_item.dart
class HistoryItem {
  final String question;
  final String answer;
  bool isExpanded;

  HistoryItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });

// Convert HistoryItem to JSON map
  Map<String, dynamic> toJson() => {
    'question': question,
    'answer': answer,
    'isExpanded': isExpanded,
  };

// Create HistoryItem from JSON map
  factory HistoryItem.fromJson(Map<String, dynamic> json) {
    return HistoryItem(
      question: json['question'],
      answer: json['answer'],
      isExpanded: json['isExpanded'] ?? false,
    );
  }
}