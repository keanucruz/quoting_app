import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quote_model.dart';
import '../services/storage_service.dart';
import '../services/pdf_service.dart';
import '../services/pricing_service.dart';

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

// Provider for total price calculation
final totalPriceProvider = Provider<double>((ref) {
  final quote = ref.watch(currentQuoteProvider);
  return PricingService.calculateTotalPrice(quote);
});

// Provider for price breakdown
final priceBreakdownProvider = Provider<Map<String, double>>((ref) {
  final quote = ref.watch(currentQuoteProvider);
  return PricingService.getItemizedPricing(quote);
});

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

  void updateVeteranDiscountPercentage(double value) {
    state = state.copyWith(veteranDiscountPercentage: value);
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
    // Reset protective case and combination case if size doesn't support it
    if (value != ProductSize.size16x24 &&
        value != ProductSize.size20x30 &&
        value != ProductSize.size24x36) {
      state = state.copyWith(
        hasProtectiveCase: false,
        hasCombinationCase: false,
      );
    }
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

  void setPrintMaterial(PrintMaterial material) {
    // For single-select, replace all materials with just this one
    state = state.copyWith(printMaterials: [material]);
    // Turn off framing if photo paper is not selected
    if (material != PrintMaterial.photoPaper && state.isFramed) {
      state = state.copyWith(isFramed: false);
    }
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

  void setSubstrate(Substrate substrate) {
    // For single-select, replace all substrates with just this one
    state = state.copyWith(substrates: [substrate]);
  }

  void updateIsFramed(bool value) {
    state = state.copyWith(isFramed: value);
  }

  void updateHasProtectiveCase(bool value) {
    state = state.copyWith(hasProtectiveCase: value);
    // If enabling protective case and combination case is on, turn off combination case
    if (value && state.effectiveHasCombinationCase) {
      state = state.copyWith(hasCombinationCase: false);
    }
  }

  void updateStandType(StandType value) {
    state = state.copyWith(standType: value);
    // Reset carrying case if not premium
    if (value != StandType.premium &&
        value != StandType.premiumSilver &&
        value != StandType.premiumBlack) {
      state = state.copyWith(hasStandCarryingCase: false);
    }
  }

  void updateHasStandCarryingCase(bool value) {
    state = state.copyWith(hasStandCarryingCase: value);
    // If enabling stand carrying case and combination case is on, turn off combination case
    if (value && state.effectiveHasCombinationCase) {
      state = state.copyWith(hasCombinationCase: false);
    }
  }

  void updateHasCombinationCase(bool value) {
    state = state.copyWith(hasCombinationCase: value);
    // If enabling combination case, turn off individual cases
    if (value) {
      state = state.copyWith(
        hasProtectiveCase: false,
        hasStandCarryingCase: false,
      );
    }
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
