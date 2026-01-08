// core/providers/theme_provider.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';

enum ThemeModeType { system, light, dark }

class ThemeState {
  final ThemeModeType themeMode;
  final ThemeData themeData;

  ThemeState({
    required this.themeMode,
    required this.themeData,
  });

  ThemeState copyWith({
    ThemeModeType? themeMode,
    ThemeData? themeData,
  }) {
    return ThemeState(
      themeMode: themeMode ?? this.themeMode,
      themeData: themeData ?? this.themeData,
    );
  }
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() {
    return ThemeState(
      themeMode: ThemeModeType.system,
      themeData: _getSystemTheme(),
    );
  }

  static ThemeData _getSystemTheme() {
    final brightness = SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark 
        ? AppTheme.darkTheme 
        : AppTheme.lightTheme;
  }

  void setTheme(ThemeModeType mode) {
    ThemeData theme;
    switch (mode) {
      case ThemeModeType.light:
        theme = AppTheme.lightTheme;
        break;
      case ThemeModeType.dark:
        theme = AppTheme.darkTheme;
        break;
      case ThemeModeType.system:
        theme = _getSystemTheme();
        break;
    }
    
    state = state.copyWith(
      themeMode: mode,
      themeData: theme,
    );
  }

  void toggleTheme() {
    final newMode = state.themeMode == ThemeModeType.dark 
        ? ThemeModeType.light 
        : ThemeModeType.dark;
    setTheme(newMode);
  }
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);