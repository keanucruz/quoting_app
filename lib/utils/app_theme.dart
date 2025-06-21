import 'package:flutter/material.dart';

class AppTheme {
  // Premium Color Palette for Car Photography
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color primaryRed = Color(0xFFE53E3E);
  static const Color accentSilver = Color(0xFFC0C0C0);
  static const Color darkGrey = Color(0xFF1A1A1A);
  static const Color mediumGrey = Color(0xFF2D2D2D);
  static const Color lightGrey = Color(0xFF3A3A3A);
  static const Color cardBackground = Color(0xFF252525);
  static const Color inputBackground = Color(0xFF1E1E1E);
  static const Color successGreen = Color(0xFF00C851);
  static const Color warningOrange = Color(0xFFFF8800);
  static const Color errorRed = Color(0xFFFF4444);

  // Light Mode Colors
  static const Color lightBackground = Color(0xFFF8F9FA);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightInputBackground = Color(0xFFF5F5F5);
  static const Color lightTextPrimary = Color(0xFF212529);
  static const Color lightTextSecondary = Color(0xFF6C757D);
  static const Color lightBorder = Color(0xFFE5E5E5);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.red,
      primaryColor: primaryRed,
      scaffoldBackgroundColor: lightBackground,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: primaryRed, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: lightCardBackground,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryRed.withValues(alpha: 0.1), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightInputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        labelStyle: TextStyle(color: lightTextSecondary),
        hintStyle: TextStyle(color: lightTextSecondary.withValues(alpha: 0.7)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Theme
      textTheme: TextTheme(
        headlineLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        headlineMedium: TextStyle(
          color: lightTextPrimary,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        titleLarge: TextStyle(
          color: primaryRed,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: lightTextPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: lightTextSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: lightCardBackground,
        selectedItemColor: primaryRed,
        unselectedItemColor: lightTextSecondary,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return lightTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed.withValues(alpha: 0.3);
          }
          return lightTextSecondary.withValues(alpha: 0.3);
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return lightTextSecondary;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        side: BorderSide(color: lightTextSecondary, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: primaryBlack,
      scaffoldBackgroundColor: primaryBlack,

      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
        iconTheme: IconThemeData(color: primaryRed, size: 24),
      ),

      // Card Theme
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 8,
        shadowColor: Colors.black.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: primaryRed.withValues(alpha: 0.1), width: 1),
        ),
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryRed.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: primaryRed.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryRed, width: 2),
        ),
        labelStyle: TextStyle(color: accentSilver.withValues(alpha: 0.8)),
        hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.6)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 6,
          shadowColor: Colors.black.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text Theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: Colors.white,
          fontSize: 32,
          fontWeight: FontWeight.w800,
          letterSpacing: 1.2,
        ),
        headlineMedium: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
        ),
        titleLarge: TextStyle(
          color: primaryRed,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
        titleMedium: TextStyle(
          color: accentSilver,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        bodyMedium: TextStyle(
          color: accentSilver,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: darkGrey,
        selectedItemColor: primaryRed,
        unselectedItemColor: accentSilver,
        elevation: 16,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return accentSilver;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed.withValues(alpha: 0.3);
          }
          return Colors.grey.withValues(alpha: 0.3);
        }),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return accentSilver;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryRed;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(primaryBlack),
        side: const BorderSide(color: accentSilver, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  // Dark Mode Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryBlack, darkGrey],
  );

  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryRed, Color(0xFFCC1F3C)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBackground, mediumGrey],
  );

  // Light Mode Gradients
  static const LinearGradient primaryGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightCardBackground, Color(0xFFF0F0F0)],
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lightCardBackground, Color(0xFFFAFAFA)],
  );

  // Box Shadows
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: primaryRed.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];
}

// Option item models for images/icons
class OptionItem {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final Color? color;
  final String? image;

  const OptionItem({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    this.color,
    this.image,
  });
}

class AppOptions {
  static const List<OptionItem> printMaterials = [
    OptionItem(
      id: 'photo_paper',
      title: 'Photo Paper',
      description: 'High-quality glossy finish',
      icon: Icons.photo,
      color: Colors.white,
    ),
    OptionItem(
      id: 'vinyl',
      title: 'Vinyl',
      description: 'Weather-resistant finish',
      icon: Icons.layers,
      color: Color(0xFF4CAF50),
    ),
    OptionItem(
      id: 'aluminum',
      title: 'Aluminum',
      description: 'Premium metal finish',
      icon: Icons.layers_sharp,
      color: Color(0xFF9E9E9E),
    ),
    OptionItem(
      id: 'acrylic',
      title: 'Acrylic',
      description: 'Crystal clear depth',
      icon: Icons.diamond,
      color: Color(0xFF2196F3),
    ),
    OptionItem(
      id: 'canvas',
      title: 'Canvas',
      description: 'Artistic texture finish',
      icon: Icons.brush,
      color: Color(0xFF8D6E63),
    ),
  ];

  static const List<OptionItem> substrates = [
    OptionItem(
      id: 'none',
      title: 'None',
      description: 'Direct print only',
      icon: Icons.do_not_disturb,
      color: Colors.grey,
    ),
    OptionItem(
      id: 'foam_board',
      title: 'Foam Board',
      description: 'Lightweight backing',
      icon: Icons.rectangle,
      color: Color(0xFFFFC107),
    ),
    OptionItem(
      id: 'dibond',
      title: 'Dibond',
      description: 'Aluminum composite',
      icon: Icons.layers_outlined,
      color: Color(0xFF607D8B),
    ),
    OptionItem(
      id: 'pvc',
      title: 'PVC',
      description: 'Rigid plastic backing',
      icon: Icons.view_module,
      color: Color(0xFF9C27B0),
    ),
    OptionItem(
      id: 'gatorboard',
      title: 'Gatorboard',
      description: 'Premium foam core',
      icon: Icons.dashboard,
      color: Color(0xFF00BCD4),
    ),
  ];

  static const List<OptionItem> standTypes = [
    OptionItem(
      id: 'none',
      title: 'None',
      description: 'No stand required',
      icon: Icons.do_not_disturb,
      color: Colors.grey,
    ),
    OptionItem(
      id: 'economy',
      title: 'Economy',
      description: 'Basic stand solution',
      icon: Icons.support,
      color: Color(0xFF4CAF50),
    ),
    OptionItem(
      id: 'premium',
      title: 'Premium',
      description: 'Professional stand',
      icon: Icons.star,
      color: AppTheme.primaryRed,
    ),
  ];

  static const List<OptionItem> productSizes = [
    OptionItem(
      id: '16x24',
      title: '16" × 24"',
      description: 'Standard portrait size',
      icon: Icons.crop_portrait,
      color: Color(0xFF2196F3),
    ),
    OptionItem(
      id: '20x30',
      title: '20" × 30"',
      description: 'Large display size',
      icon: Icons.crop_landscape,
      color: Color(0xFF4CAF50),
    ),
    OptionItem(
      id: '24x36',
      title: '24" × 36"',
      description: 'Extra large size',
      icon: Icons.fullscreen,
      color: Color(0xFFFF9800),
    ),
    OptionItem(
      id: 'custom',
      title: 'Custom Size',
      description: 'Your specific dimensions',
      icon: Icons.tune,
      color: AppTheme.primaryRed,
    ),
  ];
}
