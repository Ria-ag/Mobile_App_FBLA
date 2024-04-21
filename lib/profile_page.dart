import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'icon_tile.dart';
import 'main.dart';
import 'text_tile.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class MyProfileState extends ChangeNotifier {
  List<Widget> widgetList = [];

  List<bool> isChecked = (prefs.getString("isChecked") == null)
      ? [
          false,
          false,
          false,
          false,
          false,
          false,
          false,
          false,
        ]
      : prefs
          .getString("isChecked")!
          .split(',')
          .map((s) => s == 'true')
          .toList();

  onChange(bool value, int index) {
    isChecked[index] = value;
    String isCheckedStr = isChecked.map((b) => b.toString()).join(',');
    prefs.setString("isChecked", isCheckedStr);
    notifyListeners();
  }

  // TODO: Implement this method to add new tiles
  // void addItem() {
  //   widgetList
  //       .add(const TextTile(name: "Class name", title: "Clubs/Organizations"));
  //   notifyListeners();
  // }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showButton = false;
  File? _image;
  String name = "name";
  String school = "school";
  String year = "year";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempName = prefs.getString('name');
    String? tempSchool = prefs.getString('school');
    String? tempYear = prefs.getString('year');
    if (tempName != null && tempSchool != null && tempYear != null) {
      setState(() {
        name = tempName;
        school = tempSchool;
        year = tempYear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<IconTile> ITs = [
      const IconTile(
          title: "Athletics", icon: Icons.sports_tennis, tileIndex: 0),
      const IconTile(
          title: "Performing Arts", icon: Icons.music_note, tileIndex: 1),
      const IconTile(
          title: "Community Service", icon: Icons.help, tileIndex: 2),
      const IconTile(title: "Awards", icon: Icons.star, tileIndex: 3),
    ];

    List<TextTile> TTs = [
      const TextTile(name: "Class name", title: "Honors Classes", tileIndex: 4),
      const TextTile(
          name: "Club name", title: "Clubs/Organizations", tileIndex: 5),
      const TextTile(name: "Project name", title: "Projects", tileIndex: 6),
      const TextTile(name: "Test name", title: "Tests", tileIndex: 7),
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
                    MouseRegion(
                      onEnter: (_) => setState(() {
                        showButton = true;
                      }),
                      onExit: (_) => setState(() {
                        showButton = false;
                      }),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Center(
                            child: _image == null
                                ? const Icon(Icons.supervised_user_circle,
                                    size: 150)
                                : Image.file(_image!),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: showButton
                                ? Row(
                                    children: [
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: FloatingActionButton(
                                          onPressed: () =>
                                              getImage(ImageSource.gallery),
                                          tooltip: 'Pick Image',
                                          child: const Icon(Icons.add_a_photo),
                                        ),
                                      ),
                                      const SizedBox(width: 20, height: 20),
                                      SizedBox(
                                        width: 40,
                                        height: 40,
                                        child: FloatingActionButton(
                                          onPressed: () =>
                                              getImage(ImageSource.camera),
                                          tooltip: 'Capture Image',
                                          child: const Icon(Icons.camera),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width - 230),
                        child: Container(
                          padding: const EdgeInsets.all(5.0),
                          color: Theme.of(context).colorScheme.background,
                          child: Column(
                            children: [
                              Text(
                                name,
                                style:
                                    Theme.of(context).textTheme.headlineLarge,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                school,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Class of $year',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
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

  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (image == null) {
      return;
    }
    setState(() {
      _image = File(image.path);
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    List<String> blocks = [
      "Athletics",
      "Performing Arts",
      "Community Service",
      "Awards",
      "Honors Classes",
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
                          onChanged: (value) {
                            context
                                .read<MyProfileState>()
                                .onChange(value!, index);
                          },
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
