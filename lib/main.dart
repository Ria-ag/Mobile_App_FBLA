import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';
import 'package:mobileapp/home.dart';
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
        ChangeNotifierProvider<MyAppState>(create: (context) => MyAppState()),
        ChangeNotifierProvider<MyProfileState>(
            create: (context) => MyProfileState()),
        ChangeNotifierProvider<MyExperiences>(
            create: (context) => MyExperiences()),
        ChangeNotifierProvider<MyGoals>(
            create: (context) => MyGoals())
      ],
      child: MaterialApp(
        title: 'FBLA Mobile App',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const Splash(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  final nameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    super.dispose();
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
        page = GoalsAnalyticsPage();
        break;
      case 3:
        page = const SettingsPage();
        break;
      default:
        throw UnimplementedError();
    }

    return FutureBuilder(
        future: myFuture,
        builder: (context, snapshot) {
          return (!snapshot.hasData)
              ? const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Scaffold(
                  appBar: AppBar(
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
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        )
                      ],
                    ),
                  ),
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
                        label: 'Goals',
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
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const MyHomePage(
                title: 'Rise',
              )));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const IntroScreen()));
    }
  }

  @override
  void initState() {
    super.initState();

    loadWidget();
  }

  loadWidget() async {
    var duration = Duration(seconds: delay);
    return Timer(duration, checkSeen);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Row(children: [
          Center(
            child: SizedBox(
              width: 500,
              height: 270,
              child: Image(
                image: AssetImage("assets/loading.gif"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ]),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rise'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text('Welcome to Rise'),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please enter your name:"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                  onChanged: (value) => setState(() => name = value),
                  decoration: const InputDecoration(
                    hintText: ("First, Last"),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please enter your school's name:"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                  onChanged: (value) => school = value,
                  decoration: const InputDecoration(
                    hintText: ("ex. Woodinville High School"),
                  )),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Please enter your year of graduation:"),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                  onChanged: (value) => year = value,
                  decoration: const InputDecoration(
                    hintText: ("ex. 2025"),
                  )),
            ),
            const Text("Terms & Conditions:", style: TextStyle(fontSize: 15)),
            const Text("This app is only to be used for the purpose of FBLA"),
            Checkbox(
              value: isChecked,
              onChanged: (value) {
                setState(() {
                  isChecked = value!;
                });
              },
            ),
            SizedBox(
              width: 50,
              child: FloatingActionButton(
                onPressed: () {
                  setState(() {
                    save(context, name, school, year, isChecked);
                  });
                  isChecked == false
                      ? setState(() {
                          warning =
                              "You must accept terms and conditions to continue";
                        })
                      : Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                    title: 'Rise',
                                  )),
                        );
                },
                child: const Text("continue"),
              ),
            ),
            Text(warning),
          ],
        ),
      ),
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
