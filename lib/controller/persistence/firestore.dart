import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ancient_quotes_app/models/quote_data.dart';
import 'package:ancient_quotes_app/controller/persistence/persistence.dart'; // Import Persistence

class FirestoreController implements Persistence {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String userHistoryCollection = 'user_quotes'; // 🔹 Firestore collection for user-selected quotes

  @override
  Future<void> init() async {
    print("✅ Firestore initialized for persistence.");
  }

  @override
  Future<void> saveUserQuote(QuoteData quote) async {
    try {
      // Ensure the quote has a date before saving
      final QuoteData quoteWithDate = QuoteData(
        text: quote.text,
        author: quote.author,
        date: DateTime.now(),
      );

      await _db.collection(userHistoryCollection).add(quoteWithDate.toJson());
      print("✅ Successfully saved user-selected quote: ${quote.text}");
    } catch (e) {
      print("❌ Error saving user-selected quote: $e");
    }
  }

  @override
  Future<List<QuoteData>> getUserQuotes() async {
    try {
      QuerySnapshot querySnapshot = await _db
          .collection(userHistoryCollection)
          .orderBy('date', descending: true)
          .get();
      List<QuoteData> userQuotes = querySnapshot.docs
          .map((doc) => QuoteData.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
      print("✅ Retrieved ${userQuotes.length} user-selected quotes.");
      return userQuotes;
    } catch (e) {
      print("❌ Error retrieving user-selected quotes: $e");
      return [];
    }
  }
}
