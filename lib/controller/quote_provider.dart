import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_data.dart';

class QuoteProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String quotesCollection = 'quotes';
  final String userQuotesCollection = 'user_quotes'; // New collection for user-selected quotes

  List<QuoteData> _quotes = [];
  List<QuoteData> _userQuotes = [];
  QuoteData? _todayQuote;
  bool _hasFetched = false;

  List<QuoteData> get quotes => _quotes;
  List<QuoteData> get userQuotes => _userQuotes;
  QuoteData? get todayQuote => _todayQuote;

  /// **Fetch all quotes once**
  Future<void> fetchQuotes() async {
    if (_hasFetched) return;
    print("🔄 Checking Firestore for quotes...");

    try {
      QuerySnapshot querySnapshot = await _db.collection(quotesCollection).get();
      if (querySnapshot.docs.isEmpty) {
        print("⚠️ Firestore is EMPTY! (upload function removed)");
      } else {
        _quotes = querySnapshot.docs
            .map((doc) => QuoteData.fromJson(doc.data() as Map<String, dynamic>))
            .toList();
        print("✅ Firestore contains ${_quotes.length} quotes.");
      }
      _hasFetched = true;
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching quotes: $e");
    }
  }

  /// **Fetch & store today's random quote**
  Future<void> fetchTodayQuote() async {
    try {
      if (_quotes.isEmpty) await fetchQuotes();
      if (_quotes.isNotEmpty) {
        _todayQuote = _quotes[Random().nextInt(_quotes.length)];

        // ✅ Create a new timestamp when the quote is saved
        final now = DateTime.now();

        print("✅ Selected quote: ${_todayQuote!.text} - ${_todayQuote!.author}");

        // ✅ Add the timestamp to Firestore
        try {
          DocumentReference docRef = await _db.collection(userQuotesCollection).add({
            'text': _todayQuote!.text,
            'author': _todayQuote!.author,
            'date': now.toIso8601String(), // 🔹 Unique timestamp!
          });

          print("✅ Quote saved with timestamp: ${now.toIso8601String()} (ID: ${docRef.id})");
        } catch (e) {
          print("❌ Error saving quote to user_quotes: $e");
        }
      } else {
        _todayQuote = null;
        print("⚠️ No quotes available.");
      }
      notifyListeners();
    } catch (e) {
      print("❌ Error fetching today's quote: $e");
    }
  }


  /// **Fetch user-selected quotes for history**
  Future<void> fetchUserQuotes() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(userQuotesCollection)
          .orderBy('date', descending: true) // 🔹 Ensure sorting at Firestore level
          .get();

      _userQuotes = querySnapshot.docs
          .map((doc) => QuoteData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      notifyListeners();
      print("✅ Successfully fetched ${_userQuotes.length} user quotes.");
    } catch (e) {
      print("❌ Error fetching user quotes: $e");
    }
  }

}
