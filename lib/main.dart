import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set status bar to blend with the cream background
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFFF7F3EE),
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const CapyDoroApp());
}

class CapyDoroApp extends StatelessWidget {
  const CapyDoroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CapyDoro',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
