// lib/utils/theme_constants.dart

import 'package:flutter/material.dart';

class AppTheme {
  // Colores principales
  static final primaryColor = Colors.blue.shade700;
  static final secondaryColor = Colors.blue.shade400;
  static final backgroundColor = Colors.blue.shade50;

  // Estilos de texto
  static const TextStyle titleStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    shadows: [
      Shadow(
        blurRadius: 10,
        color: Colors.black87,
        offset: Offset(2, 2),
      ),
    ],
  );

  static const TextStyle subtitleStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: Colors.white70,
  );

  static final TextStyle buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  // Estilos de botones
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: Colors.white,
    minimumSize: const Size(double.infinity, 56),
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 4,
  );

  // Decoraciones
  static final cardDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(15),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 5),
      ),
    ],
  );

  // Gradientes
  static final mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      secondaryColor,
      backgroundColor,
    ],
  );
}