import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../main.dart';
import '../theme.dart';
import 'text_tile.dart';
import 'experience.dart';
import 'icon_tile.dart';

// This is a provider class to manage changes in the profile
class MyProfileState extends ChangeNotifier {
  File? pfp = (prefs.getString('image') != null)
      ? File(prefs.getString('image')!)
      : null;

  // Checklist starts off empty and updates list as it's checked
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

  // This method takes a value and index and updates the checked list
  onChange(bool value, int index) async {
    isChecked[index] = value;
    String isCheckedStr = isChecked.map((b) => b.toString()).join(',');
    await prefs.setString("isChecked", isCheckedStr);
    notifyListeners();
  }

  // This method takes the image source (camera or gallery) and gets an image using uses image picker package
  Future getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }
    pfp = File(pickedImage.path);
    notifyListeners();

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    await pfp!.copy('$path/${basename(pickedImage.path)}');
    await prefs.setString('image', pfp!.path);
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

// This class defines the profile page
class _ProfilePageState extends State<ProfilePage> {
  bool showButton = false;
  String name = "";
  String school = "";
  String year = "";

  // This method retrieves the user data immediately every time
  @override
  void initState() {
    super.initState();
    getData();
  }

  // This method gets the stored data from shared preferences
  void getData() async {
    prefs = await SharedPreferences.getInstance();
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
    // ignore: non_constant_identifier_names
    List<IconTile> ITs = [
      const IconTile(
          title: "Athletics", icon: Icons.sports_tennis, tileIndex: 0),
      const IconTile(
          title: "Performing Arts", icon: Icons.music_note, tileIndex: 1),
      IconTile(
          title: "Community Service",
          icon: context.watch<MyExperiences>().serviceHrs,
          tileIndex: 2),
      const IconTile(title: "Awards", icon: Icons.star, tileIndex: 3),
    ];

    // ignore: non_constant_identifier_names
    List<TextTile> TTs = [
      const TextTile(title: "Honors Classes", tileIndex: 4),
      const TextTile(title: "Clubs/Organizations", tileIndex: 5),
      const TextTile(title: "Projects", tileIndex: 6),
      const TextTile(title: "Tests", tileIndex: 7),
    ];

    // Displays icon tiles
    List<Widget> displayITs = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    // Displays text tiles
    List<Widget> displayTTs = [
      Container(),
      Container(),
      Container(),
      Container(),
    ];

    // Tiles are displayed only when their corresponding checkbox is checked
    for (var i = 0; i < ITs.length; i++) {
      displayITs[i] =
          (context.watch<MyProfileState>().isChecked[i]) ? ITs[i] : Container();
    }

    for (var i = 0; i < TTs.length; i++) {
      displayTTs[i] = (context.watch<MyProfileState>().isChecked[i + 4])
          ? TTs[i]
          : Container();
    }

    // Displays text until boxes are checked
    Widget introText =
        (!context.watch<MyProfileState>().isChecked.contains(true))
            ? const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                    "Looks a little empty in here. Click on the add button in the bottom right to get started!"),
              )
            : Container();

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
                    Column(
                      children: [
                        //profile image displayed
                        context.watch<MyProfileState>().pfp == null
                            ? const Icon(Icons.supervised_user_circle,
                                size: 150)
                            : Container(
                                padding:
                                    const EdgeInsets.all(6), // Border width
                                decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle),
                                child: ClipOval(
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        60), // Image radius
                                    child: Image.file(
                                        context.watch<MyProfileState>().pfp!,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                        Row(
                          children: [
                            SizedBox(
                              width: 45,
                              height: 45,
                              //this button lets users pick an image from their gallery
                              child: FloatingActionButton(
                                onPressed: () => context
                                    .read<MyProfileState>()
                                    .getImage(ImageSource.gallery),
                                tooltip: 'Pick Image',
                                child: const Icon(
                                    Icons.add_photo_alternate_rounded),
                              ),
                            ),
                            const SizedBox(width: 20, height: 20),
                            SizedBox(
                              width: 45,
                              height: 45,
                              //this button lets users take and use an image from their camera
                              child: FloatingActionButton(
                                onPressed: () => context
                                    .read<MyProfileState>()
                                    .getImage(ImageSource.camera),
                                tooltip: 'Capture Image',
                                child: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ],
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Theme.of(context).textTheme.displaySmall,
                                softWrap: true,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                school,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                softWrap: true,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Class of $year',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                                softWrap: true,
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
              introText,
              //makes icon tiles be scrollable horizontally
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: displayITs,
                ),
              ),
              const SizedBox(height: 30),
              ...displayTTs,
            ],
          ),
        ),
      ),
      // This button opens up the menu to add and remove tiles
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 7.5),
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          child: const Icon(Icons.add),
          onPressed: () => _dialogBuilder(context),
        ),
      ),
    );
  }

  // This method displays a pop up with a checklist to add and remove tiles
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
                padding: const EdgeInsets.fromLTRB(0, 0, 25, 165),
                child: Container(
                  alignment: Alignment.center,
                  width: 300,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Theme.of(context).dialogBackgroundColor,
                    boxShadow: [
                      shadow,
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
