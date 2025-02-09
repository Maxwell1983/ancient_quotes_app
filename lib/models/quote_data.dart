

class QuoteData {
  final String text;
  final String author;
  final DateTime date;

  QuoteData({
    required this.text,
    required this.author,
    required this.date,
  });

  // Convert QuoteData to JSON for Firebase storage
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'author': author,
      'date': date.toIso8601String(),
    };
  }

  // Factory constructor to create QuoteData from JSON
  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(
      text: json['text'],
      author: json['author'],
      date: DateTime.parse(json['date']),
    );
  }
}
