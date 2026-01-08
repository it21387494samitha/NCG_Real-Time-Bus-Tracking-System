// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/screens/login.dart';
import 'features/auth/presentation/screens/permission_screen.dart';
import 'features/tracking/presentation/screens/home.dart';
import 'features/tracking/presentation/screens/full_map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: BusTrackerApp()));
}

class BusTrackerApp extends ConsumerWidget {
  const BusTrackerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    
    return MaterialApp(
      title: 'Bus Tracker Pro',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.themeMode == ThemeModeType.system
          ? ThemeMode.system
          : themeState.themeMode == ThemeModeType.light
              ? ThemeMode.light
              : ThemeMode.dark,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/permissions': (context) => const PermissionScreen(),
        '/home': (context) => const HomeScreen(),
        '/full-map': (context) => const FullMapScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}