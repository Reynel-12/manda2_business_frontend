import 'package:flutter/material.dart';
import 'package:manda2_business_frontend/view/general/login_screen.dart';

void main() async {
  // await initializeDateFormatting('es', '');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Manda2 - Delivery Local',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF05386B), // Azul Profundo
        scaffoldBackgroundColor: const Color(
          0xFFF9FAFB,
        ), // Gris claro para fondo limpio
        colorScheme:
            ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: const Color(0xFFFF6B00), // Naranja Enérgico
              backgroundColor: const Color(0xFFF9FAFB),
              errorColor: const Color(0xFFE74C3C), // Rojo para errores
            ).copyWith(
              secondary: const Color(
                0xFF2C3E50,
              ), // Gris azulado para textos secundarios
              onPrimary: Colors.white, // Texto sobre primary
              onSecondary: Colors.white,
            ),
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF05386B),
          ), // Para títulos grandes
          displayMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF05386B),
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: Color(0xFF2C3E50),
          ), // Texto principal
          bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
          labelLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFFFF6B00),
          ), // Para botones
          labelMedium: TextStyle(fontSize: 14, color: Color(0xFF05386B)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              16.0,
            ), // Más redondeado para modernidad
            borderSide: const BorderSide(
              color: Color(0xFFDDE6ED),
              width: 1.0,
            ), // Border más sutil
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFFFF6B00), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
            borderSide: const BorderSide(color: Color(0xFFE74C3C), width: 1.5),
          ),
          labelStyle: const TextStyle(color: Color(0xFF05386B)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 18,
          ),
          hintStyle: TextStyle(color: Colors.grey[600]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            minimumSize: const Size(
              double.infinity,
              56,
            ), // Full width, pero considera responsivo
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            elevation: 0, // Sin sombra para flat design moderno; usa en cards
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF05386B),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2, // Sombra sutil
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF05386B),
          foregroundColor: Colors.white,
          elevation: 0,
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
