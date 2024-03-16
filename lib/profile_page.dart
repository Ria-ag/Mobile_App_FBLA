import 'package:flutter/material.dart';
import 'package:mobileapp/icon_tile.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/text_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

List<Widget> _listOfWidgets = [];

class _ProfilePageState extends State<ProfilePage> {
  final Widget spacer = const SizedBox(
    height: 8,
    width: 8,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          color: Colors.grey[200],
          child: Center(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 150,
                      height: 150,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/user.png'),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Theme.of(context).primaryColorLight,
                        ),
                        child: Column(
                          children: [
                            Text(context.watch<MyAppState>().nameController.text,
                                style: const TextStyle(fontSize: 40.0)),
                            const Text('Woodinville High School',
                                style: TextStyle(fontSize: 20.0)),
                            const Text('Class of 2025',
                                style: TextStyle(fontSize: 20.0)),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Athletics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const IconTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Performing Arts", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const IconTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Community Service", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const IconTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Awards", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const IconTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Honors Classes", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const TextTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Clubs/Organizations", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const TextTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Projects", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const TextTile(),
                spacer,
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tests", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,),),
                  ],
                ),
                spacer,
                const TextTile(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem();
        },
        backgroundColor: Colors.blue,
        child: const Text(
          "+",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
  void addItem() {
    List<Widget> tempList= _listOfWidgets;
    tempList.add(const TextTile());
    setState((){
      _listOfWidgets = tempList;
    });
  }
}