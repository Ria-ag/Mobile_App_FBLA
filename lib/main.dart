import 'package:flutter/material.dart';

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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
      body: page,
    );
  }
}

class ProfilePage extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: 
        Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          child: Center(
            child: Column(
              children: [
                const Row(
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
                Container(
                  child: ListTile(
                      subtitle: Column(
                        children: [
                          SizedBox(
                            width:1000,
                            height: 50,
                            child: TextButton(
                              onPressed: (){
                                modalSheet(context);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("AP Calculus BC"),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                const Row(
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
                Container(
                  child: ListTile(
                      subtitle: Column(
                        children: [
                          SizedBox(
                            width:1000,
                            height: 50,
                            child: TextButton(
                              onPressed: (){
                                modalSheet(context);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("FBLA"),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                const Row(
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
                Container(
                  child: ListTile(
                      subtitle: Column(
                        children: [
                          SizedBox(
                            width:1000,
                            height: 50,
                            child: TextButton(
                              onPressed: (){
                                modalSheet(context);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("Mobile App"),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
                const Row(
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
                Container(
                  child: ListTile(
                      subtitle: Column(
                        children: [
                          SizedBox(
                            width:1000,
                            height: 50,
                           child: TextButton(
                              onPressed: (){
                                modalSheet(context);
                              },
                              style: TextButton.styleFrom(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
                                backgroundColor: Colors.white,
                              ),
                              child: const Text("SAT"),
                            ),
                          ),
                        ],
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }
}

void modalSheet(context){
  showModalBottomSheet(context: context, builder: (BuildContext bc) {  
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.6,
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text("More Information"),
                const Spacer(),
                TextButton(
                  child:const Icon(Icons.cancel, color: Colors.red, size: 20,), 
                  onPressed: (){
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
          ],
        ),
      )
    );
  });
}