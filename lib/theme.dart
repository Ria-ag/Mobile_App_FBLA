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
      displayMedium: GoogleFonts.merriweather(fontSize: 20),
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
        backgroundColor: Color.fromARGB(255, 77, 145, 214)),
    dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: GoogleFonts.merriweather(fontSize: 14)));

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

final termsConditions = RichText(
  text: TextSpan(
    children: [
      TextSpan(
        text:
            "Welcome to Rise, a mobile application designed for students participating in the FBLA Mobile Application Development Competition. By using this application, you agree to abide by the following terms and conditions:\n\n",
        style: theme.textTheme.bodySmall, // Heading style
      ),
      TextSpan(
        text: "App Purpose:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "Rise is created specifically for the purpose of enabling high school students to create and manage their portfolio of high school experiences as outlined in the FBLA Mobile Application Development Competition prompt. The app was designed, developed, and published by Ria A. and Jishnu M.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "User Eligibility:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "All users may use the application, but it is specifically catered towards a high school audience. Users under the age of 18 must have parental consent to use this application.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Data Collection and Privacy:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "Rise collects personal information such as name, school, graduation year, academic achievements, athletic participation, performing arts experience, club memberships, community service hours, honors classes, and related items as provided by the user. User data is stored securely and used solely for the purpose of creating and managing the user's portfolio within the app. Rise does not share user data with third parties without explicit user consent.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Content Ownership:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "Users retain ownership of the content they upload or input into the app, including text, images, videos, and other media. Users grant Rise a non-exclusive, royalty-free license to use, modify, and display their content within the app for portfolio creation and management purposes.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "App Usage Guidelines:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "Users are responsible for the accuracy and legality of the content they upload or input into the app. Users must not upload or share content that is inappropriate, offensive, discriminatory, or violates the rights of others. Rise reserves the right to remove or suspend user accounts and content that violate these guidelines.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Intellectual Property:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "Rise and its associated logos, designs, and features are protected by intellectual property laws and belong to its makers, unless otherwise attributed. Users may not reproduce, modify, distribute, or create derivative works based on Rise without prior authorization.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Liability and Disclaimer:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "The makers of the app, developers, and affiliates of Rise are not liable for any damages, losses, or injuries resulting from the use of this application. Users use the app at their own risk and are responsible for maintaining the security of their credentials.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Changes to Terms:\n",
        style: theme.textTheme.displaySmall, // Heading style
      ),
      TextSpan(
        text:
            "The makers of the app reserve the right to update or modify these terms and conditions at any time. Users will be notified of significant changes to the terms via app notifications or email.\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
    ],
  ),
);
