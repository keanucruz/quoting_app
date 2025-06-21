import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote_model.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';

// Provider for the current quote being edited
final currentQuoteProvider = StateNotifierProvider<QuoteNotifier, Quote>((ref) {
  return QuoteNotifier();
});

// Provider for all saved quotes
final quotesProvider = StateNotifierProvider<QuotesNotifier, List<Quote>>((
  ref,
) {
  return QuotesNotifier();
});

// Provider for loading state
final isLoadingProvider = StateProvider<bool>((ref) => false);

class QuoteNotifier extends StateNotifier<Quote> {
  QuoteNotifier() : super(Quote());

  void updateCompletedBy(String value) {
    state = state.copyWith(completedBy: value);
  }

  void updateDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void updateTime(DateTime value) {
    state = state.copyWith(time: value);
  }

  void updateCarEventName(String value) {
    state = state.copyWith(carEventName: value);
  }

  void updateCustomerName(String value) {
    state = state.copyWith(customerName: value);
  }

  void updateIsVeteran(bool value) {
    state = state.copyWith(isVeteran: value);
  }

  void updateAddress(String value) {
    state = state.copyWith(address: value);
  }

  void updateCity(String value) {
    state = state.copyWith(city: value);
  }

  void updateState(String value) {
    state = state.copyWith(state: value);
  }

  void updateZipCode(String value) {
    state = state.copyWith(zipCode: value);
  }

  void updatePhoneNumber(String value) {
    state = state.copyWith(phoneNumber: value);
  }

  void updateEmailAddress(String value) {
    state = state.copyWith(emailAddress: value);
  }

  void updateCarMake(String value) {
    state = state.copyWith(carMake: value);
  }

  void updateCarModel(String value) {
    state = state.copyWith(carModel: value);
  }

  void updateCarColor(String value) {
    state = state.copyWith(carColor: value);
  }

  void updatePhotoTakenBy(PhotoTakenBy value) {
    state = state.copyWith(photoTakenBy: value);
  }

  void updateAvailableDates(String value) {
    state = state.copyWith(availableDates: value);
  }

  void updateIsPriorityService(bool value) {
    state = state.copyWith(isPriorityService: value);
  }

  void updateNeedByDate(DateTime? value) {
    state = state.copyWith(needByDate: value);
  }

  void updateWantsPhotosFromShoot(bool value) {
    state = state.copyWith(wantsPhotosFromShoot: value);
  }

  void updateProductSize(ProductSize value) {
    state = state.copyWith(productSize: value);
  }

  void updateCustomSize(String value) {
    state = state.copyWith(customSize: value);
  }

  void updateShowboardType(ShowboardType value) {
    state = state.copyWith(showboardType: value);
  }

  void updateThemeDescription(String value) {
    state = state.copyWith(themeDescription: value);
  }

  void updatePrintMaterials(List<PrintMaterial> value) {
    state = state.copyWith(printMaterials: value);
  }

  void togglePrintMaterial(PrintMaterial material) {
    final currentMaterials = List<PrintMaterial>.from(state.printMaterials);
    if (currentMaterials.contains(material)) {
      currentMaterials.remove(material);
    } else {
      currentMaterials.add(material);
    }
    state = state.copyWith(printMaterials: currentMaterials);
  }

  void updateSubstrates(List<Substrate> value) {
    state = state.copyWith(substrates: value);
  }

  void toggleSubstrate(Substrate substrate) {
    final currentSubstrates = List<Substrate>.from(state.substrates);
    if (currentSubstrates.contains(substrate)) {
      currentSubstrates.remove(substrate);
    } else {
      currentSubstrates.add(substrate);
    }
    state = state.copyWith(substrates: currentSubstrates);
  }

  void updateIsFramed(bool value) {
    state = state.copyWith(isFramed: value);
  }

  void updateHasProtectiveCase(bool value) {
    state = state.copyWith(hasProtectiveCase: value);
  }

  void updateStandType(StandType value) {
    state = state.copyWith(standType: value);
    // Reset carrying case if not premium
    if (value != StandType.premium) {
      state = state.copyWith(hasStandCarryingCase: false);
    }
  }

  void updateHasStandCarryingCase(bool value) {
    state = state.copyWith(hasStandCarryingCase: value);
  }

  void loadQuote(Quote quote) {
    state = quote;
  }

  void resetQuote() {
    state = Quote();
  }

  // Validation
  bool get isValid {
    return state.customerName.isNotEmpty &&
        state.emailAddress.isNotEmpty &&
        state.phoneNumber.isNotEmpty;
  }

  List<String> get validationErrors {
    final errors = <String>[];
    if (state.customerName.isEmpty) errors.add('Customer name is required');
    if (state.emailAddress.isEmpty) errors.add('Email address is required');
    if (state.phoneNumber.isEmpty) errors.add('Phone number is required');
    return errors;
  }
}

class QuotesNotifier extends StateNotifier<List<Quote>> {
  QuotesNotifier() : super([]) {
    _loadQuotes();
  }

  Future<void> _loadQuotes() async {
    try {
      final quotes = StorageService.getAllQuotes();
      state = quotes;
    } catch (e) {
      // Handle error
      state = [];
    }
  }

  Future<void> saveQuote(Quote quote) async {
    try {
      await StorageService.saveQuote(quote);
      await _loadQuotes();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> updateQuote(Quote quote) async {
    try {
      await StorageService.updateQuote(quote);
      await _loadQuotes();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> deleteQuote(String id) async {
    try {
      await StorageService.deleteQuote(id);
      await _loadQuotes();
    } catch (e) {
      // Handle error
      rethrow;
    }
  }

  Future<void> refreshQuotes() async {
    await _loadQuotes();
  }
}

// Provider for quote operations
final quoteOperationsProvider = Provider<QuoteOperations>((ref) {
  return QuoteOperations(ref);
});

class QuoteOperations {
  final Ref _ref;

  QuoteOperations(this._ref);

  Future<void> saveCurrentQuote() async {
    final quote = _ref.read(currentQuoteProvider);
    final quotesNotifier = _ref.read(quotesProvider.notifier);

    _ref.read(isLoadingProvider.notifier).state = true;
    try {
      await quotesNotifier.saveQuote(quote);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> updateCurrentQuote() async {
    final quote = _ref.read(currentQuoteProvider);
    final quotesNotifier = _ref.read(quotesProvider.notifier);

    _ref.read(isLoadingProvider.notifier).state = true;
    try {
      await quotesNotifier.updateQuote(quote);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> generatePdf() async {
    final quote = _ref.read(currentQuoteProvider);

    _ref.read(isLoadingProvider.notifier).state = true;
    try {
      await PdfService.printQuote(quote);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<void> sharePdf() async {
    final quote = _ref.read(currentQuoteProvider);

    _ref.read(isLoadingProvider.notifier).state = true;
    try {
      await PdfService.shareQuote(quote);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  Future<String> savePdf() async {
    final quote = _ref.read(currentQuoteProvider);

    _ref.read(isLoadingProvider.notifier).state = true;
    try {
      return await PdfService.saveQuotePdf(quote);
    } finally {
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  void loadQuote(Quote quote) {
    _ref.read(currentQuoteProvider.notifier).loadQuote(quote);
  }

  void resetQuote() {
    _ref.read(currentQuoteProvider.notifier).resetQuote();
  }

  bool get isCurrentQuoteValid {
    return _ref.read(currentQuoteProvider.notifier).isValid;
  }

  List<String> get currentQuoteValidationErrors {
    return _ref.read(currentQuoteProvider.notifier).validationErrors;
  }
}
