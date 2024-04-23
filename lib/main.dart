import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';
import 'chart_tile.dart';
import 'home_page.dart';
import 'experience.dart';
import 'goals_analytics_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

late SharedPreferences prefs;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<SharedPreferences>? myFuture;

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
                  bottomNavigationBar: NavigationBar(
                    onDestinationSelected: _onItemTapped,
                    selectedIndex: _selectedIndex,
                    destinations: const <Widget>[
                      NavigationDestination(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.account_circle),
                        label: 'Profile',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.checklist),
                        label: 'Goals & Data',
                      ),
                      NavigationDestination(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                  ),
                  body: page,
                );
        });
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  SplashState createState() => SplashState();
}

class SplashState extends State<Splash> {
  final delay = 3;

  Future checkSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool seen = (prefs.getBool('seen') ?? false);

    if (seen) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: 'Rise',
              )));
    } else {
      await prefs.setBool('seen', true);
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
  }

  @override
  void initState() {
    super.initState();

    var duration = Duration(seconds: delay);
    Timer(duration, checkSeen);
  }

  @override
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
      appBar: appBar,
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
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please enter your full name:",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() {
                    name = value;
                  }),
                  decoration: underlineInputDecoration(
                      context, "ex. Alexander T. Graham"),
                  initialValue: name,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    "Please enter your school's name:",
                  ),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    }
                    return null;
                  },
                  onChanged: (value) => setState(() => school = value),
                  initialValue: school,
                  decoration: underlineInputDecoration(
                      context, "ex. Woodinville High School"),
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
                  decoration: underlineInputDecoration(context, "ex. 2025"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Text("Terms & Conditions:",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
                const Text(
                    "This app is only to be used for the purpose of FBLA"),
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
                SizedBox(
                  width: 20,
                  child: FloatingActionButton(
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

  InputDecoration underlineInputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }

  void save(BuildContext context, String name, String school, String year,
      bool isChecked) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("school", school);
    await prefs.setString("year", year);
    await prefs.setBool("checked", isChecked);
  }
}
