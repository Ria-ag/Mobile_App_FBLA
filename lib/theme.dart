import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
  primaryColor: const Color.fromARGB(255, 218, 124, 96),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
    secondary: Colors.blue[900],
    background: Colors.white,
  ),
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.urbanist(
      fontWeight: FontWeight.bold,
      fontSize: 24,
    ),
    headlineMedium: GoogleFonts.urbanist(
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ),
    headlineSmall: GoogleFonts.urbanist(
      fontWeight: FontWeight.bold,
      fontSize: 18,
    ),
    bodyLarge: GoogleFonts.merriweather(
      fontSize: 16,
    ),
    bodyMedium: GoogleFonts.merriweather(
      fontSize: 14,
    ),
    bodySmall: GoogleFonts.merriweather(
      fontSize: 12,
    ),
    labelMedium: GoogleFonts.merriweather(fontSize: 10.5),
  ),
  iconTheme: IconThemeData(color: Colors.blue[900]),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color.fromARGB(255, 218, 124, 96)),
  useMaterial3: true,
  checkboxTheme: CheckboxThemeData(
    fillColor:
        MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
      if (states.contains(MaterialState.selected)) {
        return const Color(0xFF636363); // Bismark when selected
      }
      return Colors.white;
    }),
  ),
  navigationBarTheme: const NavigationBarThemeData(
    surfaceTintColor: Color.fromARGB(255, 218, 124, 96),
    indicatorColor: Color.fromARGB(190, 218, 124, 96),
  ),
);
