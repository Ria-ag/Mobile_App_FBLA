import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/goals_analytics/goal_modal_sheet.dart';
import 'package:mobileapp/theme.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'appuser.dart';
import 'goals_analytics/goals_analytics_widgets.dart';
import 'profile/experience.dart';

// This is the ChangeNotifier model used to manage profile page states
class MyAppState extends ChangeNotifier {
  late AppUser appUser;
  final ValueNotifier<String?> tokenNotifier = ValueNotifier<String?>(null);
  Map<String, dynamic> profileInfo = {};
  double serviceHrs = 0;
  int xpNum = 0;

  String? get token => tokenNotifier.value;

  set token(String? newToken) {
    tokenNotifier.value = newToken;
    notifyListeners();
  }

  void setProfile(String? newToken, Map<String, dynamic>? newProfileInfo) {
    token = newToken;
    if (newProfileInfo != null) {
      profileInfo = newProfileInfo;
    }
    notifyListeners();
  }

  DocumentReference<Map<String, dynamic>> getUserRef() {
    if (FirebaseAuth.instance.currentUser == null) {
      return FirebaseFirestore.instance.collection('users').doc(
            profileInfo["email"],
          );
    } else {
      return FirebaseFirestore.instance.collection('users').doc(
            FirebaseAuth.instance.currentUser!.email!,
          );
    }
  }

  Future<bool> checkIfUserExists(String email) {
    return FirebaseFirestore.instance.collection('users').doc(email).get().then(
      (docSnapshot) {
        return docSnapshot.exists;
      },
    );
  }

  void createLocalUser(String name, String school, int year) {
    appUser = AppUser.newUser(name: name, school: school, year: year);
  }

  Future createUserInDB() async {
    print('Creating user in database...');
    try {
      await getUserRef().set(appUser.toMap());
      return Future.value();
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return Future.error('(From createUserInDB()) $error');
    }
  }

  Future readUser() async {
    print('Retrieving user data from database...');
    try {
      DocumentSnapshot<Map<String, dynamic>> value = await getUserRef().get();
      Map<String, dynamic> userMap = value.data()!;
      appUser = AppUser.fromMap(userMap);
      totalHrs();
      totalXps();
      appUser.pfp = (appUser.pfpPath.isEmpty) ? null : File(appUser.pfpPath);
      return Future.value(appUser);
    } catch (error, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      return Future.error('(From readUser()) $error');
    }
  }

  saveUserInfoLocalandDB(String name, String school, int year) async {
    appUser.name = name;
    appUser.school = school;
    appUser.year = year;
    notifyListeners();

    try {
      await getUserRef().update({"isChecked": appUser.isChecked});
      showTextSnackBar('Account info saved');
    } catch (error) {
      showTextSnackBar('Error saving account info to database: $error');
    }
  }

  // This method takes a value and index and updates the checked list
  onChecklistChange(bool value, int index) {
    appUser.isChecked[index] = value;
    notifyListeners();
  }

  saveChecklistInDB() async {
    try {
      await getUserRef().update({"isChecked": appUser.isChecked});
      showTextSnackBar('Page settings saved');
    } catch (error) {
      showTextSnackBar('Error saving page settings to database: $error');
    }
  }

  // This method takes the image source (camera or gallery) and gets an image using uses image picker package
  Future getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: source,
        maxHeight: 150,
        maxWidth: 150,
      );
      if (pickedImage == null) {
        return;
      }
      appUser.pfp = File(pickedImage.path);
      notifyListeners();

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;

      await appUser.pfp!.copy('$path/${basename(pickedImage.path)}');
      appUser.pfpPath = appUser.pfp!.path;
      await getUserRef().update({'pfpPath': appUser.pfpPath});
    } catch (error) {
      showTextSnackBar('Error retrieving or saving image: $error');
    }
  }

  // This method adds an experience to the list and takes the title and type of tile
  void addXp(int tileIndex) {
    appUser.xpList[tileIndex].add(Experience(
        xpID: DateTime.now().microsecondsSinceEpoch, tileIndex: tileIndex));
    notifyListeners();
  }

  void addXpFromGoal(String name, String category, String start, String end,
      [String? otherInfo, String description = ""]) {
    int tileIndex = items.keys.toList().indexOf(category);
    Experience goalXP = Experience(
        xpID: DateTime.now().microsecondsSinceEpoch, tileIndex: tileIndex);
    goalXP.name = name;
    goalXP.startDate = start;
    goalXP.endDate = end;
    goalXP.editable = false;
    if (items[category] != null) {
      String xpCategory = items[category] ?? '';
      switch (xpCategory) {
        case "Hours":
          goalXP.hours = otherInfo!;
          break;
        case "Grade":
          goalXP.grade = otherInfo!;
          break;
        case "Role":
          goalXP.role = otherInfo!;
          break;
        case "Score":
          goalXP.score = otherInfo!;
          break;
        case "Issuer":
          if (otherInfo != null) {
            goalXP.award = otherInfo;
          }
          break;
      }
    }
    appUser.xpList[tileIndex].add(goalXP);
    saveXpToDB(tileIndex);
    notifyListeners();
  }

  // This method removes experiences from the list and takes the id and type of tile
  void removeXp(int id, int tileIndex) {
    appUser.xpList[tileIndex]
        .remove(appUser.xpList[tileIndex].firstWhere((xp) => xp.xpID == id));
    notifyListeners();
  }

  // This method updates the user's xpList in Firestore as a list of maps
  void saveXpToDB(int tileIndex) async {
    try {
      List<Map<String, dynamic>> xps = [];
      for (Experience xp in appUser.xpList[tileIndex]) {
        xps.add(xp.toMap());
      }
      totalXps();
      if (tileIndex == 2) {
        totalHrs();
      }
      notifyListeners();
      await getUserRef().update({'xpList.$tileIndex': xps});
      showTextSnackBar('Experiences saved');
    } catch (error) {
      showTextSnackBar('Error saving experiences to database: $error');
    }
  }

  void totalXps() {
    int totalXps = 0;
    for (List<Experience> xps in appUser.xpList) {
      totalXps += xps.length;
    }
    xpNum = totalXps;
    notifyListeners();
  }

  // This method adds up all the hours of each experience in the community service tile
  void totalHrs() {
    double totalHrs = 0;
    for (Experience xp in appUser.xpList[2]) {
      totalHrs += double.parse(xp.hours);
    }
    serviceHrs = totalHrs;
    notifyListeners();
  }

  // In the list of ChartTiles, all the charts and their data are stored
  List<ChartTile> charts = [];

  // This method adds a chart to charts
  void addChart(String title) {
    charts.add(ChartTile(
      chartName: title,
    ));
    notifyListeners();
  }

  // This method removes a chart from charts
  void removeChart(int id) {
    charts.remove(charts.firstWhere((chart) => chart.chartID == id));
    notifyListeners();
  }

  // This method updates chart data with a list of rows and an index of the specific chart
  void updateChartData(List<DataRow> rows, int index) async {
    List<Map<String, double>> newDataPoints = [];

    for (var row in rows) {
      var cells = row.cells;
      double? x =
          double.tryParse((cells[0].child as TextField).controller!.text);
      double? y =
          double.tryParse((cells[1].child as TextField).controller!.text);
      if (x != null && y != null) {
        newDataPoints.add({'x': x, 'y': y});
      }
    }
    charts[index].dataPoints = newDataPoints;
    notifyListeners();
  }

  // This method updates chart data with a list of rows and an index of the specific chart
  // void updateChartData(List<DataRow> rows, int index) {
  //   List<FlSpot> newSpots = [];

  //   for (var row in rows) {
  //     var cells = row.cells;
  //     double? x =
  //         double.tryParse((cells[0].child as TextField).controller!.text);
  //     double? y =
  //         double.tryParse((cells[1].child as TextField).controller!.text);
  //     if (x != null && y != null) {
  //       newSpots.add(FlSpot(x, y));
  //     }
  //   }
  //   charts[index].spots = newSpots;

  //   charts[index].rows = rows;
  //   notifyListeners();
  // }

  // This is a setter for the chart name
  updateName(String name, int index) {
    charts[index].chartName = name;
    notifyListeners();
  }

  // This is a setter for the chart's X-axis
  updateXLabel(String label, int index) {
    charts[index].xLabel = label;
    notifyListeners();
  }

  // This is a setter for the chart's Y-axis
  updateYLabel(String label, int index) {
    charts[index].yLabel = label;
    notifyListeners();
  }

  List<GoalTile> goals = [];
  int totalCompletedTasks = 0;
  List<int> numberOfItems = [0, 0, 0, 0, 0, 0, 0, 0, 0];

  GoalTile findGoal(String title) {
    return goals.firstWhere((goal) => goal.title == title);
  }

  // This method takes a title and adds a new goal tile to the list
  void addGoal(String title) {
    goals.add(GoalTile(
      title: title,
      createdDate: formatDate(DateTime.now()),
    ));
    notifyListeners();
  }

  // This method takes a title and removes that goal tile from the list
  void removeGoal(String title) {
    goals.remove(findGoal(title));
    updatePieChart();

    notifyListeners();
  }

  // This method takes a title and calculates how much progress that goal has made
  // Progress is defined by completed/total
  double calculateProgress(title) {
    if (findGoal(title).totalTasks == 0) {
      return 0.0;
    }
    // No notifyListeners(); in this method
    return findGoal(title).completedTasks / findGoal(title).totalTasks;
  }

  // This method takes a title and adds to the total number of tasks
  void addTotalTasks(title, task) {
    findGoal(title).totalTasks++;
    findGoal(title).tasks.add(Task(task: task, isChecked: false));
    findGoal(title).emptyGoal = false;
    notifyListeners();
  }

  // This method takes a title and addes to the completed tasks
  void addCompletedTasks(title) {
    findGoal(title).completedTasks++;
    totalCompletedTasks++;
    notifyListeners();
  }

  //This method removes the task from completed
  void uncheck(title) {
    findGoal(title).completedTasks--;
    totalCompletedTasks--;
    notifyListeners();
  }

  //This method removes the task from the task list entirely
  void deleteTask(title, index) {
    if (findGoal(title).tasks[index].isChecked) {
      findGoal(title).completedTasks--;
      totalCompletedTasks--;
    }
    findGoal(title).tasks.removeAt(index);
    findGoal(title).totalTasks--;

    notifyListeners();
  }

  // This method updates the number of items of the new category
  void updatePieChart() {
    Map<String, int> categoryIndexMap = {
      for (int i = 0; i < items.length; i++) items.keys.toList()[i]: i
    };

    List<int> updatedItems = [0, 0, 0, 0, 0, 0, 0, 0, 0];
    for (GoalTile goal in goals) {
      int index = categoryIndexMap[goal.category] ?? 8;
      updatedItems[index]++;
    }
    numberOfItems = updatedItems;
    notifyListeners();
  }
}
