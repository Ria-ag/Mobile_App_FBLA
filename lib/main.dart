import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/auth_pages.dart';
import 'package:mobileapp/my_app_state.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'goals_analytics/goals_analytics_page.dart';
import 'profile/profile_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// These are global keys that can be accessed from anywhere
// They are primarily for navigation and displaying dialogs/snack bars
final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

// This is the root of the app; everything runs from here
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // These are the providers used in the app for state management across widgets
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyAppState>(create: (context) => MyAppState()),
      ],
      child: MaterialApp(
        title: 'FBLA Mobile App',
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const AuthNav(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

// This is the home page of the app
// The user is taken here after the loading page and initial setup
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The page variable updates based on navigation in the menu
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const HomePage();
        break;
      case 1:
        page = const ProfilePage();
        break;
      case 2:
        page = const GoalsAnalyticsPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError();
    }

    // A FutureBuilder is used for the app so that it rebuilds when loading is complete
    return Scaffold(
      appBar: (_selectedIndex == 1) ? null : appBar,
      // The bottomNavigationBar is the primary form of app navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: DotNavigationBar(
          enableFloatingNavBar: true,
          enablePaddingAnimation: false,
          marginR: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
          paddingR: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          currentIndex: _selectedIndex,
          dotIndicatorColor: Theme.of(context).colorScheme.secondary,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor:
              Theme.of(context).colorScheme.secondary.withOpacity(0.75),
          backgroundColor: Colors.grey[200],
          borderRadius: 15,
          splashBorderRadius: 15,
          onTap: _onItemTapped,
          items: [
            DotNavigationBarItem(icon: const Icon(Icons.home)),
            DotNavigationBarItem(icon: const Icon(Icons.account_circle)),
            DotNavigationBarItem(icon: const Icon(Icons.checklist)),
            DotNavigationBarItem(icon: const Icon(Icons.settings)),
          ],
        ),
      ),
      body: page,
      extendBody: true,
    );
  }
}
