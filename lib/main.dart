import 'package:flutter/material.dart';
import 'package:mobileapp/text_tile.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FBLA Mobile App',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 61, 117, 186)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FBLA Mobile App Home Page'),
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

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = Placeholder();
        break;
      case 1:
        page = ProfilePage();
        break;
      case 2:
        page = Placeholder();
        break;
      case 3:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
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

class ProfilePage extends StatefulWidget {
  const  ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          child: const Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Honors Classes", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8, width:8,),
                TextTile(),
                SizedBox(height: 8, width:8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Clubs/Organizations", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8, width:8,),
                TextTile(),
                SizedBox(height: 8, width:8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Projects",
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8, width:8,),
                TextTile(),
                SizedBox(height: 8, width:8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tests", 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8, width:8,),
                TextTile(),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            addItem("input");
          },
          backgroundColor: Colors.blue,
          child: const Text("+", style: TextStyle(fontSize: 20),),
        ),
      );
  }
}

void addItem(String name){

}