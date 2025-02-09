import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/quote_data.dart';

class QuoteProvider extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String collection = 'quotes_history';

  List<QuoteData> _quotes = [];
  QuoteData? _todayQuote;

  List<QuoteData> get quotes => _quotes;
  QuoteData? get todayQuote => _todayQuote;

  Future<void> fetchQuotes() async {
    try {
      QuerySnapshot querySnapshot = await _db.collection(collection).orderBy('date', descending: true).get();
      _quotes = querySnapshot.docs.map((doc) => QuoteData.fromJson(doc.data() as Map<String, dynamic>)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching quotes: $e');
    }
  }

  Future<void> fetchTodayQuote() async {
    try {
      DateTime today = DateTime.now();
      String todayString = "${today.year}-${today.month}-${today.day}";
      QuerySnapshot querySnapshot = await _db.collection(collection).where('date', isEqualTo: todayString).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        _todayQuote = QuoteData.fromJson(querySnapshot.docs.first.data() as Map<String, dynamic>);
      } else {
        _todayQuote = null;
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching today\'s quote: $e');
    }
  }

  Future<void> saveQuote(QuoteData quote) async {
    try {
      await _db.collection(collection).add(quote.toJson());
      _todayQuote = quote;
      _quotes.insert(0, quote);
      notifyListeners();
    } catch (e) {
      print('Error saving quote: $e');
    }
  }
}
