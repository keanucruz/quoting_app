import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Theme Mode State
enum AppThemeMode { light, dark, system }

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  ThemeNotifier() : super(AppThemeMode.dark) {
    _loadThemeMode();
  }

  static const String _themeKey = 'theme_mode';

  Future<void> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? AppThemeMode.dark.index;
      state = AppThemeMode.values[themeIndex];
    } catch (e) {
      // Default to dark mode if loading fails
      state = AppThemeMode.dark;
    }
  }

  Future<void> setThemeMode(AppThemeMode themeMode) async {
    state = themeMode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, themeMode.index);
    } catch (e) {
      // Handle error silently, theme will still work for current session
    }
  }

  void toggleTheme() {
    switch (state) {
      case AppThemeMode.light:
        setThemeMode(AppThemeMode.dark);
        break;
      case AppThemeMode.dark:
        setThemeMode(AppThemeMode.light);
        break;
      case AppThemeMode.system:
        setThemeMode(AppThemeMode.light);
        break;
    }
  }
}

// Theme Provider
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});
