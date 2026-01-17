import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MessengerApp());
}

class MessengerApp extends StatelessWidget {
  const MessengerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Messenger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Dark theme
        brightness: Brightness.dark,
        primaryColor: const Color(0xFFdf9f1f),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF1c1404),
        
        // App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1c1404),
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(
            color: Color(0xFFeecd8a),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        
        // Color scheme
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFdf9f1f),
          secondary: Color(0xFFeecd8a),
          surface: Color(0xFF1c1404),
          background: Color(0xFF1c1404),
          error: Color(0xFFdf9f1f),
        ),
        
        // Text theme
        textTheme: const TextTheme(
          displayLarge: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.bold),
          displayMedium: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.bold),
          displaySmall: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.bold),
          headlineSmall: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.bold),
          titleLarge: TextStyle(color: Color(0xFFeecd8a), fontWeight: FontWeight.w600),
          titleMedium: TextStyle(color: Color(0xFFdf9f1f), fontWeight: FontWeight.w600),
          titleSmall: TextStyle(color: Color(0xFFadacab), fontSize: 12),
          bodyLarge: TextStyle(color: Color(0xFFadacab)),
          bodyMedium: TextStyle(color: Color(0xFFadacab)),
          bodySmall: TextStyle(color: Color(0xFF848483)),
          labelLarge: TextStyle(color: Color(0xFFdf9f1f), fontWeight: FontWeight.w600),
        ),
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF503c32),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF848483)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF848483), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFdf9f1f), width: 2),
          ),
          hintStyle: const TextStyle(color: Color(0xFF848483)),
          labelStyle: const TextStyle(color: Color(0xFFdf9f1f)),
        ),
        
        // Button themes
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFdf9f1f),
            foregroundColor: const Color(0xFF1c1404),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 4,
          ),
        ),
        
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFdf9f1f),
            textStyle: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
