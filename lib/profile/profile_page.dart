import 'package:flutter/material.dart';
import 'package:mobileapp/profile/my_profile_xps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../theme.dart';
import 'profile_widgets.dart';

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
  final double leftPad = 15;
  final double width = 150;
  final double topPad = 90;

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
          icon: context.watch<MyProfileXPs>().serviceHrs,
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
      displayITs[i] = (context.watch<MyProfileXPs>().isChecked[i])
          ? ITs[i]
          : Container(height: 85);
    }

    for (var i = 0; i < TTs.length; i++) {
      displayTTs[i] = (context.watch<MyProfileXPs>().isChecked[i + 4])
          ? TTs[i]
          : Container();
    }

    // Displays text until boxes are checked
    Widget introText = (!context.watch<MyProfileXPs>().isChecked.contains(true))
        ? const Padding(
            padding: EdgeInsets.fromLTRB(10, 100, 10, 10),
            child: Text(
                "Looks a little empty in here. Click on the add button in the bottom right to get started!"),
          )
        : Container();

    Widget profilePic = SizedBox(
      height: width,
      width: width,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: (context.watch<MyProfileXPs>().pfp == null)
            ? Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Icon(
                  Icons.supervised_user_circle,
                  size: 150,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(6), // Border width
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle),
                child: ClipOval(
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(60),
                    child: Image.file(context.watch<MyProfileXPs>().pfp!,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
      ),
    );

    Widget picButtons = Column(
      children: [
        SizedBox(
          width: 35,
          height: 35,
          // This button lets users pick an image from their gallery
          child: FloatingActionButton(
            onPressed: () =>
                context.read<MyProfileXPs>().getImage(ImageSource.gallery),
            tooltip: 'Pick Image',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add_photo_alternate_rounded, size: 20),
          ),
        ),
        const SizedBox(height: 12.5),
        SizedBox(
          width: 35,
          height: 35,
          // This button lets users take and use an image from their camera
          child: FloatingActionButton(
            onPressed: () =>
                context.read<MyProfileXPs>().getImage(ImageSource.camera),
            tooltip: 'Capture Image',
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.add_a_photo, size: 20),
          ),
        ),
      ],
    );

    Widget profileInfo = Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  color: Colors.white,
                ),
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            school,
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
            softWrap: true,
          ),
          const SizedBox(height: 8),
          Text(
            'Class of $year',
            style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: Colors.white,
                ),
            softWrap: true,
          ),
        ],
      ),
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            height: MediaQuery.of(context).size.height / 3 + topPad + 15,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(17.5, 0, 20,
                      MediaQuery.of(context).size.height / 3 + topPad - 268),
                  child: Stack(children: [
                    Padding(
                      padding: EdgeInsets.only(left: leftPad),
                      child: Container(
                          height: 130, width: width, color: Colors.white),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 60, left: leftPad),
                      child: Container(
                        height: width,
                        width: width,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.only(top: 59, right: 0),
                        child: Image(
                          image: AssetImage('assets/logo.png'),
                          height: 36,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          // Profile image displayed
                          children: [
                            SizedBox(width: leftPad),
                            profilePic,
                            const SizedBox(width: 15),
                            profileInfo,
                          ],
                        ),
                        picButtons,
                      ],
                    ),
                  ]),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                SizedBox(
                    height:
                        MediaQuery.of(context).size.height / 3 + topPad - 75),
                introText,

                // Makes icon tiles be scrollable horizontally
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: displayITs,
                  ),
                ),
                const SizedBox(height: 15),
                ...displayTTs,
                const SizedBox(height: 100)
              ],
            ),
          ),
        ]),
      ),
      // This button opens up the menu to add and remove tiles
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 7.5),
        child: FloatingActionButton(
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
          value: context.read<MyProfileXPs>(),
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
                          value: context.watch<MyProfileXPs>().isChecked[index],
                          onChanged: (value) {
                            context
                                .read<MyProfileXPs>()
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
