import 'package:flutter/material.dart';
import '../utils/app_theme.dart';
import '../services/pricing_service.dart';

class FloatingPriceDisplay extends StatelessWidget {
  final double totalPrice;
  final Map<String, double> breakdown;
  final VoidCallback? onTap;

  const FloatingPriceDisplay({
    super.key,
    required this.totalPrice,
    required this.breakdown,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Positioned(
      bottom: 120, // Above the navigation bar
      right: 20,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppTheme.primaryRed,
                AppTheme.primaryRed.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryRed.withValues(alpha: 0.4),
                blurRadius: 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.3)
                    : Colors.grey.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.attach_money,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    PricingService.formatPrice(totalPrice),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              if (onTap != null) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.expand_less,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class PriceBreakdownSheet extends StatelessWidget {
  final Map<String, double> breakdown;
  final double totalPrice;

  const PriceBreakdownSheet({
    super.key,
    required this.breakdown,
    required this.totalPrice,
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
                'Price Breakdown',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Breakdown items
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
              (entry) =>
                  _buildBreakdownItem(context, entry.key, entry.value, isDark),
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
                  Text(
                    'Total',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    PricingService.formatPrice(totalPrice),
                    style: const TextStyle(
                      color: AppTheme.primaryRed,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBreakdownItem(
    BuildContext context,
    String label,
    double price,
    bool isDark,
  ) {
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
}
