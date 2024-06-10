import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../main.dart';
import 'experience.dart';

// This is the ChangeNotifier model used to manage profile page states
class MyProfileXPs extends ChangeNotifier {
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

  // Experiences are stored in a list which is stored in a list of each list of experiences per tile type
  List<List<Experience>> xpList = [[], [], [], [], [], [], [], []];
  double serviceHrs = 0;

  // This method adds an experience to the list and takes the title and type of tile
  void add(String title, int tileIndex) {
    xpList[tileIndex].add(Experience(
        title: title,
        xpID: DateTime.now().microsecondsSinceEpoch,
        tileIndex: tileIndex));
    notifyListeners();
  }

  // This method removes experiences from the list and takes the id and type of tile
  void remove(int id, int tileIndex) {
    xpList[tileIndex]
        .remove(xpList[tileIndex].firstWhere((xp) => xp.xpID == id));
    notifyListeners();
  }

  // This method saves every experience in the list to the shared preferences as a json string
  void saveXP(int tileIndex) async {
    List<String> xps = [];
    for (Experience xp in xpList[tileIndex]) {
      xps.add(xp.toJsonString());
    }
    if (tileIndex == 2) {
      addHrs();
    }
    notifyListeners();
    await prefs.setStringList('$tileIndex', xps);
  }

  // This method adds up all the hours of each experience in the community service tile
  void addHrs() {
    double totalHrs = 0;
    for (Experience xp in xpList[2]) {
      totalHrs += double.parse(xp.hours);
    }
    serviceHrs = totalHrs;
  }
}
