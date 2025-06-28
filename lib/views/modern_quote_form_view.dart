import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/quote_model.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../utils/app_theme.dart';
import '../widgets/modern_ui_components.dart';
import '../widgets/draggable_price_display.dart';
import '../widgets/enhanced_price_breakdown.dart';
import '../services/pricing_service.dart';
import '../providers/theme_provider.dart';

class ModernQuoteFormView extends ConsumerStatefulWidget {
  const ModernQuoteFormView({super.key});

  @override
  ConsumerState<ModernQuoteFormView> createState() =>
      _ModernQuoteFormViewState();
}

class _ModernQuoteFormViewState extends ConsumerState<ModernQuoteFormView> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final quote = ref.watch(currentQuoteProvider);
    final quoteNotifier = ref.read(currentQuoteProvider.notifier);
    final quoteOperations = ref.read(quoteOperationsProvider);
    final isLoading = ref.watch(isLoadingProvider);

    return Scaffold(
      appBar: ModernAppBar(
        title: 'New Quote',
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeProvider);
              final isDark = themeMode == AppThemeMode.dark;

              return Container(
                margin: const EdgeInsets.only(right: 8),
                child: IconButton(
                  onPressed: () {
                    ref.read(themeProvider.notifier).toggleTheme();
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryRed.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        isDark ? Icons.light_mode : Icons.dark_mode,
                        key: ValueKey(isDark),
                        color: AppTheme.primaryRed,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: () {
                _showThemeDialog(context);
              },
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.more_vert,
                  color: AppTheme.primaryRed,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Scrollbar(
              controller: _scrollController,
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Order Info Section
                    ModernSectionCard(
                      title: 'Order Information',
                      icon: Icons.assignment_outlined,
                      children: [
                        _buildModernTextField(
                          'Completed By',
                          quote.completedBy,
                          quoteNotifier.updateCompletedBy,
                          required: true,
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: _buildDateTimePicker(
                                'Date',
                                quote.date,
                                quoteNotifier.updateDate,
                                isTimePicker: false,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDateTimePicker(
                                'Time',
                                quote.time,
                                quoteNotifier.updateTime,
                                isTimePicker: true,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Car Event Name',
                          quote.carEventName,
                          quoteNotifier.updateCarEventName,
                          icon: Icons.event_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Customer Info Section
                    ModernSectionCard(
                      title: 'Customer Information',
                      icon: Icons.person_outlined,
                      children: [
                        _buildModernTextField(
                          'Customer Name',
                          quote.customerName,
                          quoteNotifier.updateCustomerName,
                          required: true,
                          icon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildModernSwitchTile(
                          'Veteran',
                          'Military service discount eligible',
                          quote.isVeteran,
                          quoteNotifier.updateIsVeteran,
                          icon: Icons.military_tech_outlined,
                        ),
                        if (quote.isVeteran) ...[
                          const SizedBox(height: 20),
                          _buildVeteranDiscountField(
                            quote.effectiveVeteranDiscountPercentage,
                            quoteNotifier.updateVeteranDiscountPercentage,
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Address',
                          quote.address,
                          quoteNotifier.updateAddress,
                          icon: Icons.location_on_outlined,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildModernTextField(
                                'City',
                                quote.city,
                                quoteNotifier.updateCity,
                                icon: Icons.location_city_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildModernTextField(
                                'State',
                                quote.state,
                                quoteNotifier.updateState,
                                icon: Icons.map_outlined,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildModernTextField(
                                'ZIP',
                                quote.zipCode,
                                quoteNotifier.updateZipCode,
                                icon: Icons.local_post_office_outlined,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Phone Number',
                          quote.phoneNumber,
                          quoteNotifier.updatePhoneNumber,
                          required: true,
                          keyboardType: TextInputType.phone,
                          icon: Icons.phone_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Email Address',
                          quote.emailAddress,
                          quoteNotifier.updateEmailAddress,
                          required: true,
                          keyboardType: TextInputType.emailAddress,
                          icon: Icons.email_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Vehicle Info Section
                    ModernSectionCard(
                      title: 'Vehicle Information',
                      icon: Icons.directions_car_outlined,
                      children: [
                        _buildModernTextField(
                          'Car Make',
                          quote.carMake,
                          quoteNotifier.updateCarMake,
                          icon: Icons.car_rental_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Car Model',
                          quote.carModel,
                          quoteNotifier.updateCarModel,
                          icon: Icons.drive_eta_outlined,
                        ),
                        const SizedBox(height: 20),
                        _buildModernTextField(
                          'Car Color',
                          quote.carColor,
                          quoteNotifier.updateCarColor,
                          icon: Icons.palette_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Photoshoot Section
                    ModernSectionCard(
                      title: 'Photoshoot Details',
                      icon: Icons.camera_alt_outlined,
                      children: [
                        _buildModernRadioOptions(
                          'Photos taken by',
                          PhotoTakenBy.values,
                          quote.photoTakenBy,
                          quoteNotifier.updatePhotoTakenBy,
                          (value) => value.displayName,
                          _getPhotoTakenByIcon,
                        ),
                        if (quote.photoTakenBy == PhotoTakenBy.photomotive) ...[
                          const SizedBox(height: 20),
                          _buildModernTextField(
                            'Available Dates',
                            quote.availableDates,
                            quoteNotifier.updateAvailableDates,
                            maxLines: 3,
                            icon: Icons.date_range_outlined,
                            hint:
                                'List your available dates for the photoshoot',
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildModernSwitchTile(
                          'Priority Service',
                          'Rush processing for faster delivery',
                          quote.isPriorityService,
                          quoteNotifier.updateIsPriorityService,
                          icon: Icons.speed_outlined,
                          activeColor: AppTheme.warningOrange,
                        ),
                        if (quote.isPriorityService) ...[
                          const SizedBox(height: 20),
                          _buildDateTimePicker(
                            'Need by Date',
                            quote.needByDate,
                            quoteNotifier.updateNeedByDate,
                            allowNull: true,
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildModernSwitchTile(
                          'Customer wants photos',
                          'Receive digital copies from the photoshoot',
                          quote.wantsPhotosFromShoot,
                          quoteNotifier.updateWantsPhotosFromShoot,
                          icon: Icons.photo_library_outlined,
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Product Configuration Section
                    ModernSectionCard(
                      title: 'Product Configuration',
                      icon: Icons.view_module_outlined,
                      children: [
                        _buildModernOptionGrid(
                          'Size Options',
                          AppOptions.productSizes,
                          [quote.productSize],
                          (size) => quoteNotifier.updateProductSize(
                            _getProductSizeFromId(size.id),
                          ),
                          allowMultiple: false,
                        ),
                        if (quote.productSize == ProductSize.custom) ...[
                          const SizedBox(height: 20),
                          _buildModernTextField(
                            'Custom Size',
                            quote.customSize,
                            quoteNotifier.updateCustomSize,
                            icon: Icons.straighten_outlined,
                            hint: 'Enter custom dimensions (e.g., 30" x 45")',
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildModernRadioOptions(
                          'Showboard Type',
                          ShowboardType.values,
                          quote.showboardType,
                          quoteNotifier.updateShowboardType,
                          (value) => value.displayName,
                          _getShowboardTypeIcon,
                        ),
                        if (quote.showboardType == ShowboardType.themedAI) ...[
                          const SizedBox(height: 20),
                          _buildModernTextField(
                            'Theme Description',
                            quote.themeDescription,
                            quoteNotifier.updateThemeDescription,
                            maxLines: 3,
                            icon: Icons.auto_awesome_outlined,
                            hint:
                                'Describe your vision for the AI-themed design',
                          ),
                        ],
                        const SizedBox(height: 20),
                        _buildModernOptionGrid(
                          'Print Materials',
                          AppOptions.printMaterials,
                          quote.printMaterials,
                          (material) => quoteNotifier.setPrintMaterial(
                            _getPrintMaterialFromId(material.id),
                          ),
                          allowMultiple: false,
                        ),
                        const SizedBox(height: 20),
                        _buildModernOptionGrid(
                          'Substrate Options',
                          AppOptions.substrates,
                          quote.substrates,
                          (substrate) => quoteNotifier.setSubstrate(
                            _getSubstrateFromId(substrate.id),
                          ),
                          allowMultiple: false,
                        ),
                        const SizedBox(height: 20),
                        // Dynamic layout based on available options
                        if (quote.printMaterials.contains(
                              PrintMaterial.photoPaper,
                            ) &&
                            (quote.productSize == ProductSize.size16x24 ||
                                quote.productSize == ProductSize.size20x30 ||
                                quote.productSize == ProductSize.size24x36))
                          // Both framed and protective case available - show in row
                          Row(
                            children: [
                              Expanded(
                                child: _buildModernSwitchTile(
                                  'Framed',
                                  'Professional framing',
                                  quote.isFramed,
                                  quoteNotifier.updateIsFramed,
                                  icon: Icons.crop_din_outlined,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildModernSwitchTile(
                                  'Protective Case',
                                  quote.effectiveHasCombinationCase
                                      ? 'Disabled (using combination case)'
                                      : 'Weather protection',
                                  quote.hasProtectiveCase,
                                  quote.effectiveHasCombinationCase
                                      ? (_) {} // Disabled callback
                                      : quoteNotifier.updateHasProtectiveCase,
                                  icon: Icons.shield_outlined,
                                ),
                              ),
                            ],
                          )
                        else if (quote.printMaterials.contains(
                          PrintMaterial.photoPaper,
                        ))
                          // Only framed available - show full width
                          _buildModernSwitchTile(
                            'Framed',
                            'Professional framing',
                            quote.isFramed,
                            quoteNotifier.updateIsFramed,
                            icon: Icons.crop_din_outlined,
                          )
                        else if (quote.productSize == ProductSize.size16x24 ||
                            quote.productSize == ProductSize.size20x30 ||
                            quote.productSize == ProductSize.size24x36)
                          // Only protective case available - show full width
                          _buildModernSwitchTile(
                            'Protective Case',
                            quote.effectiveHasCombinationCase
                                ? 'Disabled (using combination case)'
                                : 'Weather protection',
                            quote.hasProtectiveCase,
                            quote.effectiveHasCombinationCase
                                ? (_) {} // Disabled callback
                                : quoteNotifier.updateHasProtectiveCase,
                            icon: Icons.shield_outlined,
                          ),
                        // Combination case option (only for supported sizes)
                        if (quote.productSize == ProductSize.size16x24 ||
                            quote.productSize == ProductSize.size20x30 ||
                            quote.productSize == ProductSize.size24x36) ...[
                          const SizedBox(height: 20),
                          _buildModernSwitchTile(
                            'Combination Case',
                            'Combined protective case & stand carrying case (\$39)',
                            quote.effectiveHasCombinationCase,
                            quoteNotifier.updateHasCombinationCase,
                            icon: Icons.inventory_2_outlined,
                            activeColor: AppTheme.successGreen,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Stand Info Section
                    ModernSectionCard(
                      title: 'Stand Information',
                      icon: Icons.support_outlined,
                      children: [
                        _buildModernOptionGrid(
                          'Stand Type',
                          AppOptions.standTypes,
                          [quote.standType],
                          (stand) => quoteNotifier.updateStandType(
                            _getStandTypeFromId(stand.id),
                          ),
                          allowMultiple: false,
                        ),
                        if (quote.standType == StandType.premium ||
                            quote.standType == StandType.premiumSilver ||
                            quote.standType == StandType.premiumBlack) ...[
                          const SizedBox(height: 20),
                          _buildModernSwitchTile(
                            'Stand Carrying Case',
                            quote.effectiveHasCombinationCase
                                ? 'Disabled (using combination case)'
                                : 'Premium protective carrying case',
                            quote.hasStandCarryingCase,
                            quote.effectiveHasCombinationCase
                                ? (_) {} // Disabled callback
                                : quoteNotifier.updateHasStandCarryingCase,
                            icon: Icons.luggage_outlined,
                            activeColor: AppTheme.primaryRed,
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Action Buttons
                    _buildModernActionButtons(quoteOperations, isLoading),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),

          // Floating price display - always show regardless of price
          Consumer(
            builder: (context, ref, child) {
              final totalPrice = ref.watch(totalPriceProvider);
              final breakdown = ref.watch(priceBreakdownProvider);
              final quote = ref.watch(currentQuoteProvider);

              return DraggableFloatingPriceDisplay(
                totalPrice: totalPrice,
                breakdown: breakdown,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => EnhancedPriceBreakdownSheet(
                      breakdown: breakdown,
                      totalPrice: totalPrice,
                      quote: quote,
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildVeteranDiscountField(double value, Function(double) onChanged) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.percent_outlined,
                color: AppTheme.primaryRed,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Veteran Discount Percentage',
              style: TextStyle(
                color: isDark
                    ? AppTheme.accentSilver
                    : AppTheme.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: value.toStringAsFixed(0),
            decoration: InputDecoration(
              hintText: 'Enter discount percentage (e.g., 10)',
              suffixText: '%',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppTheme.primaryRed.withValues(alpha: 0.3)
                      : AppTheme.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppTheme.primaryRed.withValues(alpha: 0.3)
                      : AppTheme.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryRed,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark
                  ? AppTheme.inputBackground
                  : AppTheme.lightInputBackground,
              contentPadding: const EdgeInsets.all(16),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
              fontSize: 16,
            ),
            onChanged: (text) {
              final percentage = double.tryParse(text) ?? 0.0;
              // Clamp between 0 and 100
              final clampedPercentage = percentage.clamp(0.0, 100.0);
              onChanged(clampedPercentage);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildModernTextField(
    String label,
    String value,
    Function(String) onChanged, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    IconData? icon,
    String? hint,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryRed.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AppTheme.primaryRed, size: 16),
              ),
              const SizedBox(width: 8),
            ],
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppTheme.accentSilver
                    : AppTheme.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            if (required) ...[
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(
                  color: AppTheme.errorRed,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              hintText: hint ?? 'Enter $label',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppTheme.primaryRed.withValues(alpha: 0.3)
                      : AppTheme.lightBorder,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDark
                      ? AppTheme.primaryRed.withValues(alpha: 0.3)
                      : AppTheme.lightBorder,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppTheme.primaryRed,
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: isDark
                  ? AppTheme.inputBackground
                  : AppTheme.lightInputBackground,
              contentPadding: const EdgeInsets.all(16),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: TextStyle(
              color: isDark ? Colors.white : AppTheme.lightTextPrimary,
              fontSize: 16,
            ),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker(
    String label,
    DateTime? value,
    Function(DateTime) onChanged, {
    bool allowNull = false,
    bool isTimePicker = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                isTimePicker
                    ? Icons.access_time_outlined
                    : Icons.calendar_today_outlined,
                color: AppTheme.primaryRed,
                size: 16,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isDark
                    ? AppTheme.accentSilver
                    : AppTheme.lightTextSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            if (isTimePicker) {
              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(value ?? DateTime.now()),
              );
              if (time != null) {
                final currentValue = value ?? DateTime.now();
                final newDateTime = DateTime(
                  currentValue.year,
                  currentValue.month,
                  currentValue.day,
                  time.hour,
                  time.minute,
                );
                onChanged(newDateTime);
              }
            } else {
              final date = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (date != null) {
                onChanged(date);
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark
                  ? AppTheme.inputBackground
                  : AppTheme.lightInputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppTheme.primaryRed.withValues(alpha: 0.3)
                    : AppTheme.lightBorder,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null
                        ? isTimePicker
                              ? DateFormat('hh:mm a').format(value)
                              : DateFormat('MMM dd, yyyy').format(value)
                        : allowNull
                        ? 'Select ${label.toLowerCase()}'
                        : '',
                    style: TextStyle(
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryRed.withValues(alpha: .7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModernSwitchTile(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    IconData? icon,
    Color? activeColor,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark
            ? AppTheme.inputBackground
            : AppTheme.lightInputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? (activeColor ?? AppTheme.primaryRed).withValues(alpha: 0.5)
              : (isDark
                    ? AppTheme.primaryRed.withValues(alpha: 0.2)
                    : AppTheme.lightBorder),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (activeColor ?? AppTheme.primaryRed).withValues(
                  alpha: .2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: activeColor ?? AppTheme.primaryRed,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: isDark
                        ? AppTheme.accentSilver.withValues(alpha: 0.8)
                        : AppTheme.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 1.2,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: activeColor ?? AppTheme.primaryRed,
              activeTrackColor: (activeColor ?? AppTheme.primaryRed).withValues(
                alpha: .3,
              ),
              inactiveThumbColor: AppTheme.accentSilver,
              inactiveTrackColor: Colors.grey.withValues(alpha: .3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernRadioOptions<T>(
    String title,
    List<T> options,
    T selectedValue,
    Function(T) onChanged,
    String Function(T) getDisplayName,
    IconData Function(T) getIcon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppTheme.accentSilver : AppTheme.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: options.map((option) {
            final isSelected = option == selectedValue;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(option),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? AppTheme.redGradient
                        : LinearGradient(
                            colors: isDark
                                ? [
                                    AppTheme.inputBackground,
                                    AppTheme.cardBackground,
                                  ]
                                : [Colors.grey.shade200, Colors.grey.shade100],
                          ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryRed
                          : AppTheme.primaryRed.withValues(alpha: .3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        getIcon(option),
                        color: isSelected
                            ? AppTheme.primaryBlack
                            : AppTheme.primaryRed,
                        size: 24,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        getDisplayName(option),
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryBlack
                              : isDark
                              ? Colors.white
                              : AppTheme.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildModernOptionGrid(
    String title,
    List<OptionItem> options,
    List<dynamic> selectedValues,
    Function(OptionItem) onToggle, {
    bool allowMultiple = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDark ? AppTheme.accentSilver : AppTheme.lightTextSecondary,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: options.length > 3 ? 3 : 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final isSelected = _isOptionSelected(option, selectedValues);

            return GestureDetector(
              onTap: () => onToggle(option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppTheme.redGradient
                      : LinearGradient(
                          colors: isDark
                              ? [
                                  AppTheme.inputBackground,
                                  AppTheme.cardBackground,
                                ]
                              : [Colors.grey.shade200, Colors.grey.shade100],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.primaryRed.withValues(alpha: .3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryRed.withValues(alpha: .3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: .1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (option.color ?? AppTheme.primaryRed)
                              .withValues(alpha: .2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option.icon,
                          color: option.color ?? AppTheme.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.title,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryBlack
                              : isDark
                              ? Colors.white
                              : AppTheme.lightTextPrimary,
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        option.description,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryBlack.withValues(alpha: .7)
                              : isDark
                              ? AppTheme.accentSilver.withValues(alpha: .8)
                              : AppTheme.lightTextSecondary,
                          fontSize: 9,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Price display
                      if (option.price != null) ...[
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.white.withValues(alpha: 0.2)
                                : AppTheme.primaryRed.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            PricingService.formatPrice(option.price!),
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.primaryRed,
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildModernActionButtons(
    QuoteOperations quoteOperations,
    bool isLoading,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ModernActionButton(
                label: 'Save Quote',
                icon: Icons.save_outlined,
                backgroundColor: AppTheme.successGreen,
                isLoading: isLoading,
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    try {
                      await quoteOperations.saveCurrentQuote();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Quote saved successfully!'),
                            backgroundColor: AppTheme.successGreen,
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error saving quote: $e'),
                            backgroundColor: AppTheme.errorRed,
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernActionButton(
                label: 'Clear Form',
                icon: Icons.clear_outlined,
                backgroundColor: AppTheme.mediumGrey,
                isLoading: false,
                onPressed: () {
                  quoteOperations.resetQuote();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Quote cleared'),
                      backgroundColor: AppTheme.warningOrange,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ModernActionButton(
                label: 'Generate PDF',
                icon: Icons.picture_as_pdf_outlined,
                backgroundColor: Colors.blue[700]!,
                isLoading: isLoading,
                onPressed: () async {
                  if (!quoteOperations.isCurrentQuoteValid) {
                    _showValidationErrors(
                      quoteOperations.currentQuoteValidationErrors,
                    );
                    return;
                  }

                  try {
                    await quoteOperations.generatePdf();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error generating PDF: $e'),
                          backgroundColor: AppTheme.errorRed,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ModernActionButton(
                label: 'Share',
                icon: Icons.share_outlined,
                backgroundColor: AppTheme.warningOrange,
                isLoading: isLoading,
                onPressed: () async {
                  if (!quoteOperations.isCurrentQuoteValid) {
                    _showValidationErrors(
                      quoteOperations.currentQuoteValidationErrors,
                    );
                    return;
                  }

                  try {
                    await quoteOperations.sharePdf();
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error sharing PDF: $e'),
                          backgroundColor: AppTheme.errorRed,
                        ),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showValidationErrors(List<String> errors) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: const Text(
          'Validation Errors',
          style: TextStyle(color: AppTheme.primaryRed),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors
              .map(
                (e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppTheme.errorRed,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(color: AppTheme.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  // Helper methods
  IconData _getPhotoTakenByIcon(PhotoTakenBy value) {
    switch (value) {
      case PhotoTakenBy.photomotive:
        return Icons.camera_alt_outlined;
      case PhotoTakenBy.customer:
        return Icons.person_outlined;
    }
  }

  IconData _getShowboardTypeIcon(ShowboardType value) {
    switch (value) {
      case ShowboardType.standard:
        return Icons.view_module_outlined;
      case ShowboardType.themedAI:
        return Icons.auto_awesome_outlined;
    }
  }

  bool _isOptionSelected(OptionItem option, List<dynamic> selectedValues) {
    if (option.id == '8x12') {
      return selectedValues.contains(ProductSize.size8x12);
    }
    if (option.id == '16x24') {
      return selectedValues.contains(ProductSize.size16x24);
    }
    if (option.id == '20x30') {
      return selectedValues.contains(ProductSize.size20x30);
    }
    if (option.id == '24x36') {
      return selectedValues.contains(ProductSize.size24x36);
    }
    if (option.id == 'custom') {
      return selectedValues.contains(ProductSize.custom);
    }

    if (option.id == 'photo_paper') {
      return selectedValues.contains(PrintMaterial.photoPaper);
    }
    if (option.id == 'aluminum') {
      return selectedValues.contains(PrintMaterial.aluminum);
    }
    if (option.id == 'acrylic') {
      return selectedValues.contains(PrintMaterial.acrylic);
    }
    if (option.id == 'canvas') {
      return selectedValues.contains(PrintMaterial.canvas);
    }

    if (option.id == 'none' && selectedValues.isNotEmpty) {
      return selectedValues.contains(Substrate.none) ||
          selectedValues.contains(StandType.none);
    }
    if (option.id == 'foam_board') {
      return selectedValues.contains(Substrate.foamBoard);
    }
    if (option.id == 'dibond') return selectedValues.contains(Substrate.dibond);
    if (option.id == 'pvc') return selectedValues.contains(Substrate.pvc);
    if (option.id == 'gatorboard') {
      return selectedValues.contains(Substrate.gatorboard);
    }

    if (option.id == 'economy') {
      return selectedValues.contains(StandType.economy);
    }
    if (option.id == 'premium') {
      return selectedValues.contains(StandType.premium);
    }
    if (option.id == 'premium_silver') {
      return selectedValues.contains(StandType.premiumSilver);
    }
    if (option.id == 'premium_black') {
      return selectedValues.contains(StandType.premiumBlack);
    }

    return false;
  }

  ProductSize _getProductSizeFromId(String id) {
    switch (id) {
      case '8x12':
        return ProductSize.size8x12;
      case '16x24':
        return ProductSize.size16x24;
      case '20x30':
        return ProductSize.size20x30;
      case '24x36':
        return ProductSize.size24x36;
      case 'custom':
        return ProductSize.custom;
      default:
        return ProductSize.size8x12;
    }
  }

  PrintMaterial _getPrintMaterialFromId(String id) {
    switch (id) {
      case 'photo_paper':
        return PrintMaterial.photoPaper;
      case 'aluminum':
        return PrintMaterial.aluminum;
      case 'acrylic':
        return PrintMaterial.acrylic;
      case 'canvas':
        return PrintMaterial.canvas;
      default:
        return PrintMaterial.photoPaper;
    }
  }

  Substrate _getSubstrateFromId(String id) {
    switch (id) {
      case 'none':
        return Substrate.none;
      case 'foam_board':
        return Substrate.foamBoard;
      case 'dibond':
        return Substrate.dibond;
      case 'pvc':
        return Substrate.pvc;
      case 'gatorboard':
        return Substrate.gatorboard;
      default:
        return Substrate.none;
    }
  }

  StandType _getStandTypeFromId(String id) {
    switch (id) {
      case 'none':
        return StandType.none;
      case 'economy':
        return StandType.economy;
      case 'premium':
        return StandType.premium;
      case 'premium_silver':
        return StandType.premiumSilver;
      case 'premium_black':
        return StandType.premiumBlack;
      default:
        return StandType.none;
    }
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentTheme = ref.watch(themeProvider);

          return AlertDialog(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.cardBackground
                : AppTheme.lightCardBackground,
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.palette,
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Theme Settings',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : AppTheme.lightTextPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildThemeOption(
                  context,
                  ref,
                  'Light Mode',
                  'Clean and bright interface',
                  Icons.light_mode,
                  AppThemeMode.light,
                  currentTheme,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  ref,
                  'Dark Mode',
                  'Professional dark interface',
                  Icons.dark_mode,
                  AppThemeMode.dark,
                  currentTheme,
                ),
                const SizedBox(height: 8),
                _buildThemeOption(
                  context,
                  ref,
                  'System Default',
                  'Follow device settings',
                  Icons.settings_system_daydream,
                  AppThemeMode.system,
                  currentTheme,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppTheme.primaryRed),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    WidgetRef ref,
    String title,
    String subtitle,
    IconData icon,
    AppThemeMode themeMode,
    AppThemeMode currentTheme,
  ) {
    final isSelected = currentTheme == themeMode;

    return GestureDetector(
      onTap: () {
        ref.read(themeProvider.notifier).setThemeMode(themeMode);
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryRed.withValues(alpha: .1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryRed
                : (Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.lightGrey
                      : AppTheme.lightBorder),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryRed.withValues(alpha: .2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primaryRed, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : AppTheme.lightTextPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppTheme.accentSilver
                          : AppTheme.lightTextSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppTheme.primaryRed,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}
