import 'package:flutter/material.dart';
import 'package:mobileapp/home.dart';
import 'experience.dart';
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
            create: (context) => MyExperiences())
      ],
      child: MaterialApp(
        title: 'FBLA Mobile App',
        debugShowCheckedModeBanner: false,
        theme: theme,
        home: const MyHomePage(title: 'FBLA Mobile App Home Page'),
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
        page = HomePage();
        break;
      case 1:
        page = const ProfilePage();
        break;
      case 2:
        page = const Placeholder();
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
                          image: AssetImage('assets/progress.png'),
                          // PLACEHOLDER ICON
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                          child: Text(
                            'App Name',
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
