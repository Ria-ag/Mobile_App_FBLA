import 'package:flutter/material.dart';
import 'experience.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'theme.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

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

  @override
  Widget build(BuildContext context) {
    Widget icon;
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const Placeholder();
        icon = const MainIconButton();
        break;
      case 1:
        page = const ProfilePage();
        icon = const ProfileIconButton();
        break;
      case 2:
        page = const Placeholder();
        icon = const MainIconButton();
        break;
      case 3:
        page = const SettingsPage();
        icon = const MainIconButton();
        break;
      default:
        throw UnimplementedError();
    }

    return Scaffold(
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
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share Profile',
            onPressed: () {
              //PLACEHOLDER
            },
          ),
          icon,
        ],
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
  }
}

class MainIconButton extends StatelessWidget {
  const MainIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.smart_button),
      tooltip: 'Show Snackbar',
      onPressed: () {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('This is a snackbar')));
      },
    );
  }
}

class ProfileIconButton extends StatelessWidget {
  const ProfileIconButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.add),
      tooltip: 'Add',
      onPressed: () {
        //PLACEHOLDER
      },
    );
  }
}
