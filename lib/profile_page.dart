import 'package:flutter/material.dart';
import 'package:mobileapp/icon_tile.dart';
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

  // TODO: Implement this method to add new tiles
  // void addItem() {
  //   widgetList
  //       .add(const TextTile(name: "Class name", title: "Clubs/Organizations"));
  //   notifyListeners();
  // }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    List<IconTile> ITs = [
      const IconTile(title: "Athletics", icon: Icons.sports_tennis, index: 0),
      const IconTile(
          title: "Performing Arts", icon: Icons.music_note, index: 1),
      const IconTile(title: "Community Service", icon: Icons.help, index: 2),
      const IconTile(title: "Awards", icon: Icons.star, index: 3),
    ];

    List<TextTile> TTs = [
      const TextTile(name: "Class name", title: "Honors Classes", index: 4),
      const TextTile(name: "Club name", title: "Clubs/Organizations", index: 5),
      const TextTile(name: "Project name", title: "Projects", index: 6),
      const TextTile(name: "Test name", title: "Tests", index: 7),
    ];

    List<Widget> displayITs = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    List<Widget> displayTTs = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    for (var i = 0; i < ITs.length; i++) {
      displayITs[i] =
          (context.watch<MyProfileState>().isChecked[i]) ? ITs[i] : Container();
    }

    for (var i = 0; i < TTs.length; i++) {
      displayTTs[i] = (context.watch<MyProfileState>().isChecked[i + 4])
          ? TTs[i]
          : Container();
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
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
                        color: Theme.of(context).colorScheme.background,
                        child: Column(
                          children: [
                            Text(
                                context.watch<MyAppState>().nameController.text,
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            Text('Woodinville High School',
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                            Text('Class of 2025',
                                style:
                                    Theme.of(context).textTheme.headlineLarge),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 30),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: displayITs,
                ),
              ),
              const SizedBox(height: 30),
              ...displayTTs,
              ...context.watch<MyProfileState>().widgetList,
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
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
