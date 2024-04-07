import 'package:flutter/material.dart';
import 'package:mobileapp/icon_tile.dart';
import 'package:mobileapp/icon_tile_provider';
import 'package:mobileapp/main.dart';
import 'package:mobileapp/text_tile.dart';
import 'package:provider/provider.dart';

class MyProfileState extends ChangeNotifier {
  List<Widget> widgetList = [];
  List<bool> isChecked = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  onChange(bool value, int index) {
    isChecked[index] = value;
    notifyListeners();
  }

  void addItem() {
    List<Widget> tempList = widgetList;
    tempList
        .add(const TextTile(name: "Class name", title: "Clubs/Organizations"));
    widgetList = tempList;
    notifyListeners();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconTile> ITs = [
      const IconTile(title: "Athletics", icon: Icons.sports_tennis),
      const IconTile(title: "Performing Arts", icon: Icons.music_note),
      const IconTile(title: "Community Serivce", icon: Icons.help),
      const IconTile(title: "Awards", icon: Icons.star),
    ];

    List<TextTile> TTs = [
      const TextTile(name: "Class name", title: "Honors Classes"),
      const TextTile(name: "Club name", title: "Clubs/Organizations"),
      const TextTile(name: "Project name", title: "Projects"),
      const TextTile(
          name: "Test name", title: "Tests", trailing: "score/total"),
    ];

    List<Widget> displayITs = [];

    List<Widget> displayTTs = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    for (var i = 0; i < ITs.length; i++) {
      if (context.watch<MyProfileState>().isChecked[i]) {
        displayITs.add(ITs[i]);
      }
    }

    for (var i = 0; i < TTs.length; i++) {
      displayTTs[i] = (context.watch<MyProfileState>().isChecked[i + 4])
          ? TTs[i]
          : Container();
    }

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
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: displayITs,
                ),
              ),
              ...displayTTs,
              ...context.watch<MyProfileState>().widgetList,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () => _dialogBuilder(context),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    List<String> blocks = [
      "Athletics",
      "Performing Arts",
      "Community Service",
      "Awards",
      "Honors Class",
      "Clubs/Organizations",
      "Projects",
      "Tests",
    ];

    return showDialog<void>(
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return ChangeNotifierProvider.value(
          value: context.read<MyProfileState>(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 15, 165),
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(7)),
                    color: Theme.of(context).dialogBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        offset: const Offset(0, 4),
                        blurRadius: 8,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Material(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: blocks.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          title: Text(blocks[index]),
                          value:
                              context.watch<MyProfileState>().isChecked[index],
                          onChanged: (value) => context
                              .read<MyProfileState>()
                              .onChange(value!, index),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
