import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

class ModernAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;

  const ModernAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? AppTheme.primaryGradient
            : AppTheme.primaryGradientLight,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black26 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              if (showBackButton || leading != null) ...[
                leading ??
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryRed.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new,
                          color: AppTheme.primaryRed,
                          size: 20,
                        ),
                      ),
                    ),
                const SizedBox(width: 16),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppTheme.lightTextPrimary,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.2,
                          ),
                    ),
                    Text(
                      'Car Photography Services',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.primaryRed.withValues(alpha: 0.8),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              if (actions != null) ...actions!,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class ModernSectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? iconColor;

  const ModernSectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration: BoxDecoration(
        gradient: isDark ? AppTheme.cardGradient : AppTheme.cardGradientLight,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
        border: Border.all(
          color: AppTheme.primaryRed.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppTheme.redGradient,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primaryRed.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: AppTheme.primaryBlack, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: isDark ? Colors.white : AppTheme.lightTextPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
            const SizedBox(height: 20),
            ...children,
          ],
        ),
      ),
    );
  }
}

class ModernTextField extends StatelessWidget {
  final String label;
  final String value;
  final Function(String) onChanged;
  final bool required;
  final int maxLines;
  final TextInputType? keyboardType;
  final String? hint;

  const ModernTextField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.required = false,
    this.maxLines = 1,
    this.keyboardType,
    this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppTheme.accentSilver,
                fontWeight: FontWeight.w600,
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
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            initialValue: value,
            decoration: InputDecoration(
              hintText: hint ?? 'Enter $label',
              prefixIcon: Icon(
                _getIconForField(label),
                color: AppTheme.primaryRed.withValues(alpha: 0.7),
              ),
            ),
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(color: Colors.white, fontSize: 16),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  IconData _getIconForField(String label) {
    final lowerLabel = label.toLowerCase();
    if (lowerLabel.contains('name')) return Icons.person;
    if (lowerLabel.contains('email')) return Icons.email;
    if (lowerLabel.contains('phone')) return Icons.phone;
    if (lowerLabel.contains('address')) return Icons.location_on;
    if (lowerLabel.contains('city')) return Icons.location_city;
    if (lowerLabel.contains('car') && lowerLabel.contains('make')) {
      return Icons.directions_car;
    }
    if (lowerLabel.contains('car') && lowerLabel.contains('model')) {
      return Icons.car_rental;
    }
    if (lowerLabel.contains('color')) return Icons.palette;
    if (lowerLabel.contains('event')) return Icons.event;
    if (lowerLabel.contains('date')) return Icons.calendar_today;
    if (lowerLabel.contains('description')) return Icons.description;
    return Icons.edit;
  }
}

class ModernOptionGrid<T> extends StatelessWidget {
  final String title;
  final List<OptionItem> options;
  final List<T> selectedValues;
  final Function(T) onToggle;
  final T Function(String) getValue;
  final bool allowMultiple;

  const ModernOptionGrid({
    super.key,
    required this.title,
    required this.options,
    required this.selectedValues,
    required this.onToggle,
    required this.getValue,
    this.allowMultiple = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.accentSilver,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            final value = getValue(option.id);
            final isSelected = selectedValues.contains(value);

            return GestureDetector(
              onTap: () => onToggle(value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? AppTheme.redGradient
                      : LinearGradient(
                          colors: [
                            AppTheme.inputBackground,
                            AppTheme.cardBackground,
                          ],
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryRed
                        : AppTheme.primaryRed.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryRed.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: (option.color ?? AppTheme.primaryRed)
                              .withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          option.icon,
                          color: option.color ?? AppTheme.primaryRed,
                          size: 24,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        option.title,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryBlack
                              : Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        option.description,
                        style: TextStyle(
                          color: isSelected
                              ? AppTheme.primaryBlack.withValues(alpha: 0.7)
                              : AppTheme.accentSilver.withValues(alpha: 0.8),
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
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
}

class ModernSwitchTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool value;
  final Function(bool) onChanged;
  final IconData? icon;
  final Color? activeColor;

  const ModernSwitchTile({
    super.key,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.icon,
    this.activeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.inputBackground,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value
              ? (activeColor ?? AppTheme.primaryRed).withValues(alpha: 0.5)
              : AppTheme.primaryRed.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (activeColor ?? AppTheme.primaryRed).withValues(
                  alpha: 0.2,
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
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: AppTheme.accentSilver.withValues(alpha: 0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
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
                alpha: 0.3,
              ),
              inactiveThumbColor: AppTheme.accentSilver,
              inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }
}

class ModernActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isLoading;
  final double? width;

  const ModernActionButton({
    super.key,
    required this.label,
    required this.icon,
    this.onPressed,
    required this.backgroundColor,
    this.foregroundColor = Colors.white,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withValues(alpha: 0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.buttonShadow,
      ),
      child: ElevatedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Icon(icon, color: foregroundColor),
        label: Text(
          label,
          style: TextStyle(
            color: foregroundColor,
            fontWeight: FontWeight.w700,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class ModernDateTimePicker extends StatelessWidget {
  final String label;
  final DateTime? value;
  final Function(DateTime) onChanged;
  final bool allowNull;
  final bool isTimePicker;
  final IconData? icon;

  const ModernDateTimePicker({
    super.key,
    required this.label,
    this.value,
    required this.onChanged,
    this.allowNull = false,
    this.isTimePicker = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppTheme.accentSilver,
            fontWeight: FontWeight.w600,
          ),
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
              color: AppTheme.inputBackground,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.primaryRed.withValues(alpha: 0.3),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryRed.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon ??
                        (isTimePicker
                            ? Icons.access_time
                            : Icons.calendar_today),
                    color: AppTheme.primaryRed,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    value != null
                        ? isTimePicker
                              ? '${value!.hour.toString().padLeft(2, '0')}:${value!.minute.toString().padLeft(2, '0')}'
                              : '${value!.day}/${value!.month}/${value!.year}'
                        : allowNull
                        ? 'Select ${label.toLowerCase()}'
                        : '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: AppTheme.primaryRed.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
