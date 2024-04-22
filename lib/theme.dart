import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final theme = ThemeData(
    primaryColor: const Color.fromARGB(255, 218, 124, 96),
    colorScheme:
        ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
      secondary: const Color.fromARGB(255, 77, 145, 214),
      primary: const Color.fromARGB(255, 218, 124, 96),
      background: Colors.white,
    ),
    textTheme: TextTheme(
      displayLarge:
          GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 32),
      displaySmall:
          GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 16),
      headlineLarge:
          GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 24),
      headlineMedium:
          GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 20),
      headlineSmall:
          GoogleFonts.urbanist(fontWeight: FontWeight.bold, fontSize: 18),
      bodyLarge: GoogleFonts.merriweather(fontSize: 16),
      bodyMedium: GoogleFonts.merriweather(fontSize: 14),
      bodySmall: GoogleFonts.merriweather(fontSize: 12),
      labelMedium: GoogleFonts.merriweather(fontSize: 10.5),
      labelLarge: GoogleFonts.merriweather(),
    ),
    iconTheme: const IconThemeData(
      color: Color.fromARGB(255, 77, 145, 214),
    ),
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
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
          fontFamily: GoogleFonts.merriweather().fontFamily, fontSize: 13),
    ),
    textButtonTheme: const TextButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll(Colors.black),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
        backgroundColor: Color.fromARGB(255, 77, 145, 214)));

final appBar = AppBar(
  automaticallyImplyLeading: false,
  backgroundColor: Colors.white,
  title: Row(
    children: [
      const Image(
        image: AssetImage('assets/logo.png'),
        // PLACEHOLDER ICON
        height: 30,
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Text(
          'Rise',
          style: theme.textTheme.headlineLarge,
        ),
      )
    ],
  ),
);
