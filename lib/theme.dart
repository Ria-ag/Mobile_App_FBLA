import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main.dart';

// This is the theme data used throughout the app
final theme = ThemeData(
  // This app adopts a color scheme of bronze, light pastel blue, black, and white
  useMaterial3: true,
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: const Color.fromARGB(255, 218, 124, 96),
  colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blueGrey).copyWith(
    secondary: const Color.fromARGB(255, 20, 49, 92),
    primary: const Color.fromARGB(255, 218, 124, 96),
    background: Colors.white,
  ),
  // These are the text styles in the app
  // The font used is Poppins, retrieved from Google Fonts
  textTheme: TextTheme(
    displayLarge:
        GoogleFonts.poppins(fontWeight: FontWeight.w100, fontSize: 100),
    displayMedium:
        GoogleFonts.poppins(fontWeight: FontWeight.w100, fontSize: 70),
    displaySmall:
        GoogleFonts.poppins(fontWeight: FontWeight.w100, fontSize: 30),
    headlineLarge:
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 30),
    headlineMedium:
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 20),
    headlineSmall:
        GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 18),
    bodySmall: GoogleFonts.poppins(fontSize: 12),

    // This style is the default for Text widgets
    bodyMedium: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300),

    // This style is the default for buttons
    labelLarge: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w300),

    // This style is the default for TextFields and TextFormFields
    bodyLarge: GoogleFonts.poppins(fontSize: 16),

    // This i
    labelSmall: GoogleFonts.poppins(fontSize: 14),
    labelMedium: GoogleFonts.poppins(fontSize: 14),
  ),

  // Below are themes for various specific widgets in the app, including icons, buttons, app bars, and menus
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color.fromARGB(255, 20, 49, 92),
    shape: CircleBorder(),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      minimumSize: const Size.fromHeight(50),
      backgroundColor: const Color.fromARGB(255, 218, 124, 96),
      foregroundColor: Colors.black,
    ),
  ),
  textButtonTheme: const TextButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll(Colors.black),
    ),
  ),
  iconButtonTheme: const IconButtonThemeData(),
  iconTheme: const IconThemeData(
    color: Color.fromARGB(255, 20, 49, 92),
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle:
        TextStyle(fontFamily: GoogleFonts.poppins().fontFamily, fontSize: 14),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: Color.fromARGB(255, 20, 49, 92),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(
    textStyle: GoogleFonts.poppins(fontSize: 14),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.selected)) {
          return const Color.fromARGB(255, 20, 49, 92);
        }
        return Colors.white;
      },
    ),
  ),
);

final shadow = BoxShadow(
  color: Colors.black.withOpacity(0.3),
  offset: const Offset(4, 4),
  blurRadius: 5,
  spreadRadius: 0,
);

// This is the app header bar used throughout the app
// It contains the app logo and title
final appBar = AppBar(
  scrolledUnderElevation: 0,
  automaticallyImplyLeading: false,
  backgroundColor: const Color.fromARGB(255, 20, 49, 92),
  actions: const [
    Padding(
      padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
      child: Image(
        image: AssetImage('assets/logo.png'),
        height: 50,
      ),
    ),
  ],
);

// These are the terms and conditions of the app, formatted with RichText
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
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "Rise is created specifically for the purpose of enabling high school students to create and manage their portfolio of high school experiences as outlined in the FBLA Mobile Application Development Competition prompt. The app was designed, developed, and published by Ria A. and Jishnu M.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "User Eligibility:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "All users may use the application, but it is specifically catered to a high school audience. Users under the age of 13 must have parental consent to use this application.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Data Collection and Privacy:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "Rise collects personal information such as name, school, graduation year, academic achievements, athletic participation, performing arts experience, club memberships, community service hours, honors classes, and related items as provided by the user. User data is stored securely and used solely to create and manage the user's portfolio within the app. Rise does not share user data with third parties without explicit user consent.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Content Ownership:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "Users retain ownership of the content they upload or input into the app, including text, images, videos, and other media. Users grant Rise a non-exclusive, royalty-free license to use, modify, and display their content within the app for portfolio creation and management purposes.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "App Usage Guidelines:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "Users are responsible for the accuracy and legality of the content they upload or input into the app. Users must not upload or share content that is inappropriate, offensive, discriminatory, or violates the rights of others. Rise reserves the right to remove or suspend user accounts and content that violate these guidelines.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Intellectual Property:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "Rise and its associated logos, designs, and features are protected by intellectual property laws and belong to its makers, unless otherwise attributed. Users may not reproduce, modify, distribute, or create derivative works based on Rise without prior authorization.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Liability and Disclaimer:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "The makers of the app, developers, and affiliates of Rise are not liable for any damages, losses, or injuries resulting from the use of this application. Users use the app at their own risk and are responsible for maintaining the security of their credentials.\n\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
      TextSpan(
        text: "Changes to Terms:\n",
        style: theme.textTheme.bodyMedium, // Heading style
      ),
      TextSpan(
        text:
            "The makers of the app reserve the right to update or modify these terms and conditions at any time. Users will be notified of significant changes to the terms via app notifications or email.\n",
        style: theme.textTheme.bodySmall, // Content style
      ),
    ],
  ),
);

// This is the input decoration used by most fields in the app
InputDecoration underlineInputDecoration(
    BuildContext context, String hint, String? label,
    {bool alwaysFloat = true}) {
  return InputDecoration(
    hintText: hint,
    labelText: label,
    floatingLabelBehavior: (alwaysFloat) ? FloatingLabelBehavior.always : null,
    labelStyle: MaterialStateTextStyle.resolveWith((states) {
      final Color color;
      color =
          (states.contains(MaterialState.error)) ? Colors.red : Colors.black;
      return TextStyle(color: color);
    }),
    floatingLabelStyle: MaterialStateTextStyle.resolveWith((states) {
      final Color color;
      if (states.contains(MaterialState.focused)) {
        color = (states.contains(MaterialState.error)
            ? Colors.red
            : Theme.of(context).colorScheme.secondary);
      } else {
        color =
            (states.contains(MaterialState.error)) ? Colors.red : Colors.black;
      }
      return TextStyle(color: color, height: 0.5);
    }),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
        width: 1.5,
      ),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide:
          BorderSide(color: (alwaysFloat) ? Colors.transparent : Colors.black),
    ),
    errorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5)),
    focusedErrorBorder: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.5)),
  );
}

// This is a method for showing a snack bar without a local BuildContext
showTextSnackBar(String message) {
  scaffoldMessengerKey.currentState?.showSnackBar(SnackBar(
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 2),
    content: Text(message,
        style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 14,
            color: Colors.white)),
  ));
}

// This is a commonly used validation method in the app
String? noEmptyField(String? value) {
  if (value == null || value.isEmpty) {
    return "Field cannot be empty";
  }
  return null;
}

// This is a custom elevated button used throughout the app, with a shadow
class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.stadiumBorder = false,
    this.buttonColor = const Color.fromARGB(255, 218, 124, 96),
  });
  final Widget child;
  final Function()? onPressed;
  final bool stadiumBorder;
  final Color buttonColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [shadow],
        borderRadius: BorderRadius.circular((stadiumBorder) ? 1000 : 15),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: (stadiumBorder)
            ? ElevatedButton.styleFrom(
                backgroundColor: buttonColor, shape: const StadiumBorder())
            : null,
        child: child,
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Image(
            image: AssetImage("assets/loading.gif"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
