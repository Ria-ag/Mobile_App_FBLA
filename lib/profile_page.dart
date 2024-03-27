import 'package:flutter/material.dart';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/icon_tile.dart';
import 'package:mobileapp/text_tile.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List<Widget> widgetList = [];

  void addItem() {
    List<Widget> tempList = widgetList;
    tempList
        .add(const TextTile(name: "Class name", title: "Clubs/Organizations"));
    setState(() {
      widgetList = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
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
                            Text(
                                context.watch<MyAppState>().nameController.text,
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
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconTile(title: "Athletics", icon: Icons.sports_tennis),
                  IconTile(title: "Performing Arts", icon: Icons.music_note),
                  IconTile(title: "Community Serivce", icon: Icons.help),
                  IconTile(title: "Awards", icon: Icons.star),
                ],
              ),
              const TextTile(name: "Class name", title: "Honors Classes"),
              const TextTile(name: "Club name", title: "Clubs/Organizations"),
              const TextTile(name: "Project name", title: "Projects"),
              const TextTile(
                  name: "Test name", title: "Tests", trailing: "score/total"),
              Column(children: widgetList)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addItem();
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
