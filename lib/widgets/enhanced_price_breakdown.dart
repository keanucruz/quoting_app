import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/pricing_service.dart';
import '../models/quote_model.dart';

class EnhancedPriceBreakdownSheet extends StatelessWidget {
  final Map<String, double> breakdown;
  final double totalPrice;
  final Quote quote;

  const EnhancedPriceBreakdownSheet({
    super.key,
    required this.breakdown,
    required this.totalPrice,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardBackground : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.5)
                : Colors.grey.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: isDark
                    ? AppTheme.lightGrey
                    : Colors.grey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppTheme.redGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Quote Summary',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Selected Items Section
          _buildSelectedItemsSection(isDark),

          const SizedBox(height: 24),

          // Price Breakdown Section
          _buildPriceBreakdownSection(isDark),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSelectedItemsSection(bool isDark) {
    final selectedItems = _getSelectedItems();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.checklist, color: AppTheme.primaryRed, size: 18),
            const SizedBox(width: 8),
            Text(
              'Selected Options',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (selectedItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(
              'No options selected yet',
              style: TextStyle(
                color: isDark
                    ? AppTheme.accentSilver.withValues(alpha: 0.7)
                    : AppTheme.lightTextSecondary,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          ...selectedItems.map((item) => _buildSelectedItem(item, isDark)),

        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppTheme.primaryRed.withValues(alpha: 0.3),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedItem(SelectedItem item, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, color: item.color, size: 14),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.category,
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.accentSilver.withValues(alpha: 0.8)
                        : AppTheme.lightTextSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item.value,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (item.price != null)
            Text(
              PricingService.formatPrice(item.price!),
              style: TextStyle(
                color: AppTheme.primaryRed,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdownSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.calculate, color: AppTheme.primaryRed, size: 18),
            const SizedBox(width: 8),
            Text(
              'Price Breakdown',
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (breakdown.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                'Select options to see pricing',
                style: TextStyle(
                  color: isDark
                      ? AppTheme.accentSilver.withValues(alpha: 0.7)
                      : AppTheme.lightTextSecondary,
                  fontSize: 16,
                ),
              ),
            ),
          )
        else
          ...breakdown.entries.map(
            (entry) => _buildBreakdownItem(entry.key, entry.value, isDark),
          ),

        if (breakdown.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  AppTheme.primaryRed.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Total
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: isDark
                  ? AppTheme.cardGradient
                  : AppTheme.cardGradientLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryRed.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppTheme.lightTextPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (quote.isVeteran)
                      Text(
                        'Veteran discount applied (${quote.effectiveVeteranDiscountPercentage.toStringAsFixed(0)}%)',
                        style: TextStyle(
                          color: AppTheme.successGreen,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                Text(
                  PricingService.formatPrice(totalPrice),
                  style: const TextStyle(
                    color: AppTheme.primaryRed,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildBreakdownItem(String label, double price, bool isDark) {
    final isDiscount = price < 0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppTheme.accentSilver.withValues(alpha: 0.9)
                    : AppTheme.lightTextSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            PricingService.formatPrice(price.abs()),
            style: TextStyle(
              color: isDiscount
                  ? AppTheme.successGreen
                  : isDark
                  ? Colors.white
                  : AppTheme.lightTextPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<SelectedItem> _getSelectedItems() {
    List<SelectedItem> items = [];

    // Showboard type
    items.add(
      SelectedItem(
        category: 'Design',
        value: quote.showboardType.displayName,
        icon: Icons.auto_awesome,
        color: AppTheme.primaryRed,
        price: PricingService.getDesignCharge(quote.showboardType),
      ),
    );

    // Size
    String sizeText = quote.productSize == ProductSize.custom
        ? quote.customSize.isNotEmpty
              ? quote.customSize
              : 'Custom Size'
        : quote.productSize.displayName;
    items.add(
      SelectedItem(
        category: 'Size',
        value: sizeText,
        icon: Icons.photo_size_select_large,
        color: Colors.blue,
      ),
    );

    // Print materials
    if (quote.printMaterials.isNotEmpty) {
      for (var material in quote.printMaterials) {
        items.add(
          SelectedItem(
            category: 'Material',
            value: material.displayName,
            icon: Icons.print,
            color: Colors.green,
            price: PricingService.getMaterialPrice(quote.productSize, material),
          ),
        );
      }
    }

    // Framing/Mounting
    if (quote.printMaterials.contains(PrintMaterial.photoPaper)) {
      if (quote.isFramed) {
        items.add(
          SelectedItem(
            category: 'Framing',
            value: 'Professional Framing',
            icon: Icons.crop_din,
            color: Colors.purple,
            price: PricingService.getFramingPrice(quote.productSize),
          ),
        );
      } else if (quote.productSize != ProductSize.size8x12) {
        items.add(
          SelectedItem(
            category: 'Mounting',
            value: 'Photo Paper Mounting',
            icon: Icons.attach_file,
            color: Colors.orange,
            price: PricingService.getMountingPrice(quote.productSize),
          ),
        );
      }
    }

    // Stand
    if (quote.standType != StandType.none) {
      items.add(
        SelectedItem(
          category: 'Stand',
          value: '${quote.standType.displayName} Stand',
          icon: Icons.support,
          color: Colors.brown,
          price: PricingService.getStandPrice(quote.standType),
        ),
      );
    }

    // Cases
    if (quote.effectiveHasCombinationCase) {
      items.add(
        SelectedItem(
          category: 'Protection',
          value: 'Combination Case',
          icon: Icons.inventory_2,
          color: AppTheme.successGreen,
          price: PricingService.getProtectiveCasePrice(quote.productSize, true),
        ),
      );
    } else {
      // Individual cases
      if (quote.hasProtectiveCase) {
        items.add(
          SelectedItem(
            category: 'Protection',
            value: 'Protective Case',
            icon: Icons.shield,
            color: Colors.teal,
            price: PricingService.getProtectiveCasePrice(
              quote.productSize,
              false,
            ),
          ),
        );
      }

      if (quote.hasStandCarryingCase) {
        items.add(
          SelectedItem(
            category: 'Stand Accessory',
            value: 'Stand Carrying Case',
            icon: Icons.luggage,
            color: Colors.indigo,
            price: 0.0, // Included in stand price
          ),
        );
      }
    }

    // Veteran status
    if (quote.isVeteran) {
      items.add(
        SelectedItem(
          category: 'Status',
          value: 'Military Veteran',
          icon: Icons.military_tech,
          color: AppTheme.successGreen,
        ),
      );
    }

    return items;
  }
}

class SelectedItem {
  final String category;
  final String value;
  final IconData icon;
  final Color color;
  final double? price;

  SelectedItem({
    required this.category,
    required this.value,
    required this.icon,
    required this.color,
    this.price,
  });
}
