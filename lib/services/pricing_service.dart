import '../models/quote_model.dart';

class PricingService {
  // Design charges
  static final Map<ShowboardType, double> designCharges = {
    ShowboardType.standard: 139.0,
    ShowboardType.themedAI: 199.0,
  };

  // Size and material pricing
  static final Map<ProductSize, Map<PrintMaterial, double>>
  sizeMaterialPricing = {
    ProductSize.size8x12: {
      PrintMaterial.photoPaper: 19.0,
      PrintMaterial.aluminum: 129.0,
      PrintMaterial.acrylic: 85.0,
      PrintMaterial.canvas: 69.0,
    },
    ProductSize.size16x24: {
      PrintMaterial.photoPaper: 27.0,
      PrintMaterial.aluminum: 274.0,
      PrintMaterial.acrylic: 156.0,
      PrintMaterial.canvas: 149.0,
    },
    ProductSize.size20x30: {
      PrintMaterial.photoPaper: 36.0,
      PrintMaterial.aluminum: 349.0,
      PrintMaterial.acrylic: 225.0,
      PrintMaterial.canvas: 199.0,
    },
    ProductSize.size24x36: {
      PrintMaterial.photoPaper: 44.0,
      PrintMaterial.aluminum: 399.0,
      PrintMaterial.acrylic: 299.0,
      PrintMaterial.canvas: 265.0,
    },
  };

  // Photo mounting options
  static final Map<ProductSize, double> mountingPricing = {
    ProductSize.size16x24: 5.0,
    ProductSize.size20x30: 7.0,
    ProductSize.size24x36: 9.0,
  };

  // Framing options
  static final Map<ProductSize, double> framingPricing = {
    ProductSize.size8x12: 16.0,
    ProductSize.size16x24: 35.0,
    ProductSize.size20x30: 48.0,
    ProductSize.size24x36: 59.0,
  };

  // Stand pricing
  static final Map<StandType, double> standPricing = {
    StandType.none: 0.0,
    StandType.economy: 224.0,
    StandType.premium: 349.0,
    StandType.premiumSilver: 349.0,
    StandType.premiumBlack: 349.0,
  };

  // Protective case pricing
  static final Map<ProductSize, double> protectiveCasePricing = {
    ProductSize.size16x24: 29.0,
    ProductSize.size20x30: 35.0,
    ProductSize.size24x36: 35.0,
  };

  // Combination case pricing
  static const double combinationCasePrice = 39.0;

  /// Calculate total price for a quote
  static double calculateTotalPrice(Quote quote) {
    double total = 0.0;

    // Design charge - always include base design charge
    total +=
        designCharges[quote.showboardType] ??
        designCharges[ShowboardType.standard] ??
        139.0;

    // Size and material pricing
    if (quote.printMaterials.isNotEmpty) {
      for (PrintMaterial material in quote.printMaterials) {
        double materialPrice =
            sizeMaterialPricing[quote.productSize]?[material] ?? 0.0;
        total += materialPrice;
      }
    }

    // Mounting (only for photo paper on backing board)
    if (quote.printMaterials.contains(PrintMaterial.photoPaper) &&
        !quote.isFramed &&
        quote.productSize != ProductSize.size8x12) {
      total += mountingPricing[quote.productSize] ?? 0.0;
    }

    // Framing (only for photo paper framed)
    if (quote.isFramed &&
        quote.printMaterials.contains(PrintMaterial.photoPaper)) {
      total += framingPricing[quote.productSize] ?? 0.0;
    }

    // Stand pricing
    total += standPricing[quote.standType] ?? 0.0;

    // Cases
    if (quote.hasCombinationCase) {
      // Combination case (includes both protective case and stand carrying case)
      total += combinationCasePrice;
    } else {
      // Individual cases
      if (quote.hasProtectiveCase) {
        total += protectiveCasePricing[quote.productSize] ?? 0.0;
      }
      // Stand carrying case is included in stand price, no additional cost
    }

    // Veteran discount (custom percentage if applicable)
    if (quote.isVeteran && quote.effectiveVeteranDiscountPercentage > 0) {
      total *= (100 - quote.effectiveVeteranDiscountPercentage) / 100;
    }

    return total;
  }

  /// Get design charge for showboard type
  static double getDesignCharge(ShowboardType type) {
    return designCharges[type] ?? 0.0;
  }

  /// Get material price for size and material
  static double getMaterialPrice(ProductSize size, PrintMaterial material) {
    return sizeMaterialPricing[size]?[material] ?? 0.0;
  }

  /// Get mounting price for size
  static double getMountingPrice(ProductSize size) {
    return mountingPricing[size] ?? 0.0;
  }

  /// Get framing price for size
  static double getFramingPrice(ProductSize size) {
    return framingPricing[size] ?? 0.0;
  }

  /// Get stand price
  static double getStandPrice(StandType type) {
    return standPricing[type] ?? 0.0;
  }

  /// Get protective case price
  static double getProtectiveCasePrice(ProductSize size, bool isCombo) {
    if (isCombo) {
      return combinationCasePrice;
    }
    return protectiveCasePricing[size] ?? 0.0;
  }

  /// Format price as currency string
  static String formatPrice(double price) {
    return '\$${price.toStringAsFixed(2)}';
  }

  /// Get itemized pricing breakdown
  static Map<String, double> getItemizedPricing(Quote quote) {
    Map<String, double> breakdown = {};

    // Design charge
    double designCharge = designCharges[quote.showboardType] ?? 0.0;
    if (designCharge > 0) {
      breakdown['${quote.showboardType.displayName} Design'] = designCharge;
    }

    // Materials
    for (PrintMaterial material in quote.printMaterials) {
      double materialPrice =
          sizeMaterialPricing[quote.productSize]?[material] ?? 0.0;
      if (materialPrice > 0) {
        breakdown['${quote.productSize.displayName} ${material.displayName}'] =
            materialPrice;
      }
    }

    // Mounting
    if (quote.printMaterials.contains(PrintMaterial.photoPaper) &&
        !quote.isFramed &&
        quote.productSize != ProductSize.size8x12) {
      double mountingPrice = mountingPricing[quote.productSize] ?? 0.0;
      if (mountingPrice > 0) {
        breakdown['Photo Paper Mounting'] = mountingPrice;
      }
    }

    // Framing
    if (quote.isFramed &&
        quote.printMaterials.contains(PrintMaterial.photoPaper)) {
      double framingPrice = framingPricing[quote.productSize] ?? 0.0;
      if (framingPrice > 0) {
        breakdown['Photo Paper Framing'] = framingPrice;
      }
    }

    // Stand
    if (quote.standType != StandType.none) {
      double standPrice = standPricing[quote.standType] ?? 0.0;
      if (standPrice > 0) {
        breakdown['${quote.standType.displayName} Stand'] = standPrice;
      }
    }

    // Cases
    if (quote.hasCombinationCase) {
      breakdown['Combination Display Stand & Case'] = combinationCasePrice;
    } else {
      // Individual cases
      if (quote.hasProtectiveCase) {
        double casePrice = protectiveCasePricing[quote.productSize] ?? 0.0;
        if (casePrice > 0) {
          breakdown['${quote.productSize.displayName} Protective Case'] =
              casePrice;
        }
      }
      // Stand carrying case is included in stand price, no additional cost
    }

    // Veteran discount
    if (quote.isVeteran && quote.effectiveVeteranDiscountPercentage > 0) {
      double subtotal = breakdown.values.fold(0.0, (a, b) => a + b);
      double discount =
          subtotal * (quote.effectiveVeteranDiscountPercentage / 100);
      breakdown['Veteran Discount (${quote.effectiveVeteranDiscountPercentage.toStringAsFixed(0)}%)'] =
          -discount;
    }

    return breakdown;
  }
}
