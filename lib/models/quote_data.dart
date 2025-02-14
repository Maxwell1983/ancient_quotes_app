import 'package:cloud_firestore/cloud_firestore.dart';

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
      'date': date.toIso8601String(), // Always store date as ISO string
    };
  }

  // ✅ FIX: Handle Firestore Timestamps correctly
  factory QuoteData.fromJson(Map<String, dynamic> json) {
    return QuoteData(
      text: json['text'] ?? "Unknown Quote",  // Prevent null errors
      author: json['author'] ?? "Unknown Author",
      date: json['date'] is Timestamp
          ? (json['date'] as Timestamp).toDate() // Convert Firestore Timestamp
          : DateTime.tryParse(json['date'] ?? "") ?? DateTime.now(),
    );
  }
}
