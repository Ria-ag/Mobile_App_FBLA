import 'dart:async';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'goals_analytics/goal_modal_sheet.dart';
import 'goals_analytics/chart_tile.dart';
import 'goals_analytics/goals_analytics_page.dart';
import 'profile/experience.dart';
import 'profile/profile_page.dart';
import 'home_page.dart';
import 'settings_page.dart';
import 'theme.dart';

void main() {
  runApp(const RestartWidget(child: MyApp()));
}

// This class is used to restart and clear the app
class RestartWidget extends StatefulWidget {
  const RestartWidget({required this.child, super.key});
  final Widget child;

  // Calls the restart method in the state class of the widget
  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  State<RestartWidget> createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  // To restart the app, a new key is created, resetting old information
  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    // A new tree is returned and built
    return KeyedSubtree(key: key, child: widget.child);
  }
}

// This SharePreferences instance is where app data is locally stored
late SharedPreferences prefs;

// This is the root of the app; everything runs from here
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // These are the providers used in the app for state management across widgets
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MyProfileState>(
            create: (context) => MyProfileState()),
        ChangeNotifierProvider<MyExperiences>(
            create: (context) => MyExperiences()),
        ChangeNotifierProvider<ChartDataState>(
            create: (context) => ChartDataState()),
        ChangeNotifierProvider<MyGoals>(create: (context) => MyGoals())
      ],
      child: MaterialApp(
        title: 'FBLA Mobile App',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const Splash(),
        initialRoute: "/",
        routes: {
          "/splash": (context) => const Splash(),
          "/profile": (context) => const ProfilePage(),
        },
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

// This enum is used to store
//enum _SelectedTab {home, profile, goalsAndData, settings};

// This is the home page of the app
// The user is taken here after the loading page and initial setup
class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<SharedPreferences>? myFuture;
// Here, the state of the app is initialized for the first time
// Any data that exists in SharedPreferences is retrieved (including images)
  @override
  void initState() {
    super.initState();

    Future<SharedPreferences> getSP() {
      return SharedPreferences.getInstance().then(
        (value) {
          prefs = value;
          for (int i = 0; i < 8; i++) {
            List<String>? xps = prefs.getStringList('$i');
            if (xps != null) {
              for (String xpString in xps) {
                context
                    .read<MyExperiences>()
                    .xpList[i]
                    .add(Experience.fromJsonString(xpString));
              }
            }
          }

          context.read<MyExperiences>().addHrs();

          return Future.value(value);
        },
      );
    }

    myFuture = getSP();
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
      case 4:
        page = const Splash();
      default:
        throw UnimplementedError();
    }

    // A FutureBuilder is used for the app so that it rebuilds when loading is complete
    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          return (!snapshot.hasData)
              ? const Center(
                  child: SizedBox(
                    width: 300,
                    height: 200,
                    child: Image(
                      image: AssetImage("assets/loading.gif"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Scaffold(
                  appBar: appBar,
                  // The bottomNavigationBar is the primary form of app navigation
                  bottomNavigationBar: Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: DotNavigationBar(
                      enableFloatingNavBar: true,
                      enablePaddingAnimation: false,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      marginR: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 0),
                      paddingR: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      currentIndex: _selectedIndex,
                      dotIndicatorColor:
                          Theme.of(context).colorScheme.secondary,
                      selectedItemColor:
                          Theme.of(context).colorScheme.secondary,
                      unselectedItemColor: Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.75),
                      backgroundColor: Colors.grey[200],
                      borderRadius: 15,
                      splashBorderRadius: 15,
                      onTap: _onItemTapped,
                      items: [
                        DotNavigationBarItem(icon: const Icon(Icons.home)),
                        DotNavigationBarItem(
                            icon: const Icon(Icons.account_circle)),
                        DotNavigationBarItem(icon: const Icon(Icons.checklist)),
                        DotNavigationBarItem(icon: const Icon(Icons.settings)),
                      ],
                    ),
                  ),
                  body: page,
                  extendBody: true,
                );
        });
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

// Here, the loading screen is deliberately displayed for 3 seconds
// The class also manages logic for whether the introduction screen is shown
class SplashState extends State<Splash> {
  final delay = 3;

  Future checkSeen() async {
    prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const MyHomePage(
            title: 'Rise',
          ),
        ),
      );
    } else {
      await prefs.setBool('seen', true);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
  }

  @override
  // When the app is initially built, the loading screen will display before the home page
  // Here, the method to determine whether the introduction screen will be displayed is also called
  void initState() {
    super.initState();

    var duration = Duration(seconds: delay);
    Timer(duration, checkSeen);
  }

  @override
  // This where the loading screen is displayed
  Widget build(BuildContext context) {
    return const Scaffold(
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

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

// The introduction screen is the screen shown to the users the first time they enter the app
// It also shows every time a use resets the app data
class _IntroScreenState extends State<IntroScreen> {
  String name = "";
  String school = "";
  String year = "";
  bool isChecked = false;
  String warning = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome to Rise!',
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
                Text(
                  'A portfolio app for high school success',
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 2),

                // Below are the various TextFormFields where users enter initial data
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please enter your full name:",
                  ),
                ),
                TextFormField(
                  validator: (value) => noEmptyField(value),
                  onChanged: (value) => setState(() {
                    name = value;
                  }),
                  decoration: underlineInputDecoration(
                      context, "ex. Alexander T. Graham", null),
                  initialValue: name,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please enter your school's name:",
                  ),
                ),
                TextFormField(
                  validator: (value) => noEmptyField(value),
                  onChanged: (value) => setState(() => school = value),
                  initialValue: school,
                  decoration: underlineInputDecoration(
                      context, "ex. Woodinville High School", null),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please enter your year of graduation:",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value != null) {
                      final int? numVal = int.tryParse(value);
                      if (numVal == null ||
                          numVal <= 1900 ||
                          numVal >= DateTime.now().year + 50) {
                        return "Enter a valid year";
                      }
                    } else if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => year = value),
                  initialValue: year,
                  decoration:
                      underlineInputDecoration(context, "ex. 2025", null),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text("Terms & Conditions:",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),

                // The user is also required to accept the terms and conditions
                // This can be seen in a dialog box
                TextButton(
                  onPressed: () {
                    showTermsAndConditionsDialog(context);
                  },
                  child: const Text('View Terms and Conditions'),
                ),
                CheckboxListTile(
                  value: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  title: Text(
                    "I accept the terms and conditions",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),

                // This is the continue button
                // The app will not continue until the user meets all requirements
                SizedBox(
                  width: 20,
                  child: CustomElevatedButton(
                    onPressed: () {
                      setState(() {
                        save(context, name, school, year, isChecked);
                      });
                      isChecked == false
                          ? ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Please accept the terms and conditions to continue'),
                              ),
                            )
                          : (_formKey.currentState!.validate())
                              ? Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyHomePage(
                                            title: 'Rise',
                                          )),
                                )
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please fix the errors before continuing'),
                                  ),
                                );
                    },
                    child: const Text("Continue"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

// In this dialog box, the terms and conditions are shown
  void showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: termsConditions,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

// Upon continuing, the user data is stored locally
  void save(BuildContext context, String name, String school, String year,
      bool isChecked) async {
    await prefs.setString("name", name);
    await prefs.setString("school", school);
    await prefs.setString("year", year);
    await prefs.setBool("checked", isChecked);
  }
}
