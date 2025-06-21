import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/quote_model.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../utils/form_validators.dart';

class QuoteFormView extends ConsumerStatefulWidget {
  const QuoteFormView({super.key});

  @override
  ConsumerState<QuoteFormView> createState() => _QuoteFormViewState();
}

class _QuoteFormViewState extends ConsumerState<QuoteFormView> {
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
      appBar: AppBar(
        title: const Text('Showboard Quote'),
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: Form(
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
                _buildSection('Order Information', Icons.assignment, [
                  _buildTextField(
                    'Completed By',
                    quote.completedBy,
                    quoteNotifier.updateCompletedBy,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDateField(
                          'Date',
                          quote.date,
                          quoteNotifier.updateDate,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeField(
                          'Time',
                          quote.time,
                          quoteNotifier.updateTime,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Car Event Name',
                    quote.carEventName,
                    quoteNotifier.updateCarEventName,
                  ),
                ]),

                const SizedBox(height: 24),

                // Customer Info Section
                _buildSection('Customer Information', Icons.person, [
                  _buildTextField(
                    'Name',
                    quote.customerName,
                    quoteNotifier.updateCustomerName,
                    required: true,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    'Veteran?',
                    quote.isVeteran,
                    quoteNotifier.updateIsVeteran,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Address',
                    quote.address,
                    quoteNotifier.updateAddress,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          'City',
                          quote.city,
                          quoteNotifier.updateCity,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          'State',
                          quote.state,
                          quoteNotifier.updateState,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          'Zip',
                          quote.zipCode,
                          quoteNotifier.updateZipCode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Phone Number',
                    quote.phoneNumber,
                    quoteNotifier.updatePhoneNumber,
                    required: true,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Email Address',
                    quote.emailAddress,
                    quoteNotifier.updateEmailAddress,
                    required: true,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ]),

                const SizedBox(height: 24),

                // Vehicle Info Section
                _buildSection('Vehicle Information', Icons.directions_car, [
                  _buildTextField(
                    'Car Make',
                    quote.carMake,
                    quoteNotifier.updateCarMake,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Car Model',
                    quote.carModel,
                    quoteNotifier.updateCarModel,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Car Color',
                    quote.carColor,
                    quoteNotifier.updateCarColor,
                  ),
                ]),

                const SizedBox(height: 24),

                // Photoshoot Section
                _buildSection('Photoshoot', Icons.camera_alt, [
                  _buildRadioGroup<PhotoTakenBy>(
                    'Photos taken by',
                    PhotoTakenBy.values,
                    quote.photoTakenBy,
                    quoteNotifier.updatePhotoTakenBy,
                    (value) => value.displayName,
                  ),
                  const SizedBox(height: 16),
                  _buildTextField(
                    'Date(s) available for photoshoot',
                    quote.availableDates,
                    quoteNotifier.updateAvailableDates,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    'Priority Service?',
                    quote.isPriorityService,
                    quoteNotifier.updateIsPriorityService,
                  ),
                  const SizedBox(height: 16),
                  _buildDateField(
                    'Need by date',
                    quote.needByDate,
                    quoteNotifier.updateNeedByDate,
                    allowNull: true,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    'Customer wants photos from photoshoot?',
                    quote.wantsPhotosFromShoot,
                    quoteNotifier.updateWantsPhotosFromShoot,
                  ),
                ]),

                const SizedBox(height: 24),

                // Product Configuration Section
                _buildSection('Product Configuration', Icons.view_module, [
                  _buildRadioGroup<ProductSize>(
                    'Size',
                    ProductSize.values,
                    quote.productSize,
                    quoteNotifier.updateProductSize,
                    (value) => value.displayName,
                  ),
                  if (quote.productSize == ProductSize.custom) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Custom Size',
                      quote.customSize,
                      quoteNotifier.updateCustomSize,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildRadioGroup<ShowboardType>(
                    'Showboard Type',
                    ShowboardType.values,
                    quote.showboardType,
                    quoteNotifier.updateShowboardType,
                    (value) => value.displayName,
                  ),
                  if (quote.showboardType == ShowboardType.themedAI) ...[
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Theme Description',
                      quote.themeDescription,
                      quoteNotifier.updateThemeDescription,
                      maxLines: 3,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _buildCheckboxGroup<PrintMaterial>(
                    'Printed Directly on',
                    PrintMaterial.values,
                    quote.printMaterials,
                    quoteNotifier.togglePrintMaterial,
                    (value) => value.displayName,
                  ),
                  const SizedBox(height: 16),
                  _buildCheckboxGroup<Substrate>(
                    'Substrate',
                    Substrate.values,
                    quote.substrates,
                    quoteNotifier.toggleSubstrate,
                    (value) => value.displayName,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    'Framed?',
                    quote.isFramed,
                    quoteNotifier.updateIsFramed,
                  ),
                  const SizedBox(height: 16),
                  _buildSwitchTile(
                    'Showboard Protective Case?',
                    quote.hasProtectiveCase,
                    quoteNotifier.updateHasProtectiveCase,
                  ),
                ]),

                const SizedBox(height: 24),

                // Stand Info Section
                _buildSection('Stand Information', Icons.camera_outdoor, [
                  _buildRadioGroup<StandType>(
                    'Showboard Stand Type',
                    StandType.values,
                    quote.standType,
                    quoteNotifier.updateStandType,
                    (value) => value.displayName,
                  ),
                  if (quote.standType == StandType.premium) ...[
                    const SizedBox(height: 16),
                    _buildSwitchTile(
                      'Stand Carrying Case (Premium only)',
                      quote.hasStandCarryingCase,
                      quoteNotifier.updateHasStandCarryingCase,
                    ),
                  ],
                ]),

                const SizedBox(height: 32),

                // Action Buttons
                _buildActionButtons(quoteOperations, isLoading),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<Widget> children) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.grey[700]),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    String label,
    String value,
    Function(String) onChanged, {
    bool required = false,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: required
          ? (value) => FormValidators.required(value, label)
          : null,
      onChanged: onChanged,
    );
  }

  Widget _buildDateField(
    String label,
    DateTime? value,
    Function(DateTime) onChanged, {
    bool allowNull = false,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null
              ? DateFormat('MMM dd, yyyy').format(value)
              : allowNull
              ? 'Select date'
              : '',
        ),
      ),
    );
  }

  Widget _buildTimeField(
    String label,
    DateTime value,
    Function(DateTime) onChanged,
  ) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(value),
        );
        if (time != null) {
          final newDateTime = DateTime(
            value.year,
            value.month,
            value.day,
            time.hour,
            time.minute,
          );
          onChanged(newDateTime);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[50],
          suffixIcon: const Icon(Icons.access_time),
        ),
        child: Text(DateFormat('hh:mm a').format(value)),
      ),
    );
  }

  Widget _buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue,
      contentPadding: EdgeInsets.zero,
    );
  }

  Widget _buildRadioGroup<T>(
    String title,
    List<T> options,
    T selectedValue,
    Function(T) onChanged,
    String Function(T) getDisplayName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...options.map(
          (option) => RadioListTile<T>(
            title: Text(getDisplayName(option)),
            value: option,
            groupValue: selectedValue,
            onChanged: (value) => value != null ? onChanged(value) : null,
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckboxGroup<T>(
    String title,
    List<T> options,
    List<T> selectedValues,
    Function(T) onToggle,
    String Function(T) getDisplayName,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        ...options.map(
          (option) => CheckboxListTile(
            title: Text(getDisplayName(option)),
            value: selectedValues.contains(option),
            onChanged: (_) => onToggle(option),
            contentPadding: EdgeInsets.zero,
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(QuoteOperations quoteOperations, bool isLoading) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          try {
                            await quoteOperations.saveCurrentQuote();
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Quote saved successfully!'),
                                ),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error saving quote: $e'),
                                ),
                              );
                            }
                          }
                        }
                      },
                icon: const Icon(Icons.save),
                label: const Text('Save Quote'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : () {
                        quoteOperations.resetQuote();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Quote cleared')),
                        );
                      },
                icon: const Icon(Icons.clear),
                label: const Text('Clear Form'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!quoteOperations.isCurrentQuoteValid) {
                          final errors =
                              quoteOperations.currentQuoteValidationErrors;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Validation Errors'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: errors
                                    .map((e) => Text('• $e'))
                                    .toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
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
                              ),
                            );
                          }
                        }
                      },
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text('Generate PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: isLoading
                    ? null
                    : () async {
                        if (!quoteOperations.isCurrentQuoteValid) {
                          final errors =
                              quoteOperations.currentQuoteValidationErrors;
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Validation Errors'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: errors
                                    .map((e) => Text('• $e'))
                                    .toList(),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        try {
                          await quoteOperations.sharePdf();
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error sharing PDF: $e')),
                            );
                          }
                        }
                      },
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
