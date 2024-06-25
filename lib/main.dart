import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/auth_pages.dart';
import 'package:mobileapp/my_app_state.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'goals_analytics/goals_analytics_page.dart';
import 'profile/experience.dart';
import 'profile/profile_page.dart';
import 'profile_sharing.dart';
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

// This is the home page of the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Experience? recent;

  // This method compares the times of experiences to get the most recent one
  void getRecent() {
    DateTime mostRecentUpdateTime = DateTime.utc(0);
    Experience? mostRecent;
    for (List<Experience> categoryList
        in context.read<MyAppState>().appUser.xpList) {
      for (Experience xp in categoryList) {
        if (mostRecentUpdateTime.isBefore(xp.updateTime) && !xp.editable) {
          mostRecentUpdateTime = xp.updateTime;
          mostRecent = xp;
        }
      }
    }
    if (mostRecent != null) {
      setState(() {
        recent = mostRecent!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    getRecent();

    String name = context.watch<MyAppState>().appUser.name;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The home page's welcome message
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 20),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: name.substring(
                                0,
                                (name.contains(" "))
                                    ? name.indexOf(" ")
                                    : name.length),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: ".",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Here, to most recently updated experience is shown
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Highlights",
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: (recent != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items.keys.toList()[recent!.tileIndex],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recent!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "${recent!.startDate} - ${recent!.endDate}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const Text(
                            "Add an experience in the profile page to get started.",
                            textAlign: TextAlign.left,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),

            // This section of the code uses the sharePlus and pdfx packages to save the profile as a pdf or share it to social media
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Share",
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                const Spacer(),
                FloatingActionButton.large(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => makePdf(context, true),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "PDF",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
                FloatingActionButton.large(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => socialPdf(context),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
