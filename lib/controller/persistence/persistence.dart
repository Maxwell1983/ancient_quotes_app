import 'package:ancient_quotes_app/models/quote_data.dart';

/// Abstract class defining methods for persistence
abstract class Persistence {
  Future<void> init();
  Future<void> saveUserQuote(QuoteData quote);
  Future<List<QuoteData>> getUserQuotes();
}
