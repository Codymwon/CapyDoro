import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'theme/app_colors.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';

final themeProvider = ThemeProvider();

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initial status bar style (light mode)
  _updateSystemUI(false);

  runApp(const CapyDoroApp());
}

void _updateSystemUI(bool isDark) {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: isDark
          ? AppColors.darkBackground
          : AppColors.background,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    ),
  );
}

class CapyDoroApp extends StatelessWidget {
  const CapyDoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: themeProvider,
      builder: (context, _) {
        _updateSystemUI(themeProvider.isDarkMode);
        return MaterialApp(
          title: 'CapyDoro',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          home: const HomeScreen(),
        );
      },
    );
  }
}
