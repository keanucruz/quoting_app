import 'package:hive_flutter/hive_flutter.dart';
import '../models/quote_model.dart';

class StorageService {
  static const String _quotesBoxName = 'quotes';
  static Box<Quote>? _quotesBox;

  static Future<void> init() async {
    // Initialize Hive
    await Hive.initFlutter();

    // Register adapters
    Hive.registerAdapter(QuoteAdapter());
    Hive.registerAdapter(PhotoTakenByAdapter());
    Hive.registerAdapter(ProductSizeAdapter());
    Hive.registerAdapter(ShowboardTypeAdapter());
    Hive.registerAdapter(PrintMaterialAdapter());
    Hive.registerAdapter(SubstrateAdapter());
    Hive.registerAdapter(StandTypeAdapter());

    // Open boxes
    _quotesBox = await Hive.openBox<Quote>(_quotesBoxName);
  }

  static Box<Quote> get quotesBox {
    if (_quotesBox == null) {
      throw Exception('StorageService not initialized. Call init() first.');
    }
    return _quotesBox!;
  }

  // Quote operations
  static Future<void> saveQuote(Quote quote) async {
    await quotesBox.put(quote.id, quote);
  }

  static Quote? getQuote(String id) {
    return quotesBox.get(id);
  }

  static List<Quote> getAllQuotes() {
    return quotesBox.values.toList();
  }

  static Future<void> deleteQuote(String id) async {
    await quotesBox.delete(id);
  }

  static Future<void> updateQuote(Quote quote) async {
    final updatedQuote = quote.copyWith(updatedAt: DateTime.now());
    await quotesBox.put(quote.id, updatedQuote);
  }

  static List<Quote> getRecentQuotes({int limit = 10}) {
    final quotes = getAllQuotes();
    quotes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return quotes.take(limit).toList();
  }

  static Future<void> clearAllQuotes() async {
    await quotesBox.clear();
  }

  static Future<void> close() async {
    await _quotesBox?.close();
  }
}
