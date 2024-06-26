import 'dart:io';

import 'goals_analytics/goals_analytics_widgets.dart';
import 'profile/experience.dart';

class AppUser {
  String name;
  String school;
  int year;

  String pfpPath = "";
  File? pfp;

  // List of which tiles are checked to be shown, starts off empty and updates list as it's checked
  List<bool> isChecked;

  // Experiences are stored in a list of lists, with each sublist containing the experiences of a category
  List<List<Experience>> xpList;

  // These are referred to as "tiles" simply because they are directly shown on the goals page. Experiences are technically "tiles", too
  List<ChartTile> charts;
  List<int> numberOfItems;

  List<GoalTile> goals;
  int totalCompletedTasks;

  // The constructor for AppUser requrires all field values except for profile picture and its path.
  AppUser({
    required this.name,
    required this.school,
    required this.year,
    required this.isChecked,
    required this.xpList,
    required this.charts,
    required this.numberOfItems,
    required this.goals,
    required this.totalCompletedTasks,
  });

  // This is a constructor for a new user
  AppUser.newUser(
      {required String name, required String school, required int year})
      : this(
          name: name,
          school: school,
          year: year,
          isChecked: [false, false, false, false, false, false, false, false],
          xpList: [[], [], [], [], [], [], [], []],
          charts: [],
          numberOfItems: [0, 0, 0, 0, 0, 0, 0, 0],
          goals: [],
          totalCompletedTasks: 0,
        );

  // This is a constructor to create an AppUser from a map
  factory AppUser.fromMap(Map<String, dynamic> userMap) {
    List<List<Experience>> convertedXpList = List.generate(8, (index) {
      String key = index.toString();
      if (userMap['xpList'][key] != null) {
        return (userMap['xpList'][key] as List).map((xpMap) {
          return Experience.fromMap(Map<String, dynamic>.from(xpMap));
        }).toList();
      } else {
        return [];
      }
    });
    AppUser appUser = AppUser(
      name: userMap['name'],
      school: userMap['school'],
      year: userMap['year'],
      isChecked: List<bool>.from(userMap['isChecked'] as List),
      xpList: convertedXpList,
      charts: [],
      numberOfItems: [0, 0, 0, 0, 0, 0, 0, 0, 0],
      goals: [],
      totalCompletedTasks: 0,
      // These fields have not been implemented in Firebase yet
      // DO NOT DELETE: may implement later
      //   charts: userMap['charts'],
      //   numberOfItems: userMap['numberOfItems'],
      //   goals: userMap['goals'],
      //   totalCompletedTasks: userMap['totalCompletedTasks'],
    );
    appUser.pfpPath = userMap['pfpPath'] ?? "";
    return appUser;
  }

  // This method converts the current instance of an AppUser to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'school': school,
      'year': year,
      'pfpPath': pfpPath,
      'isChecked': isChecked,
      'xpList': {
        '0': xpList[0],
        '1': xpList[1],
        '2': xpList[2],
        '3': xpList[3],
        '4': xpList[4],
        '5': xpList[5],
        '6': xpList[6],
        '7': xpList[7],
      },
      'charts': charts,
      'numberOfItems': numberOfItems,
      'goals': goals,
      'totalCompletedTasks': totalCompletedTasks,
    };
  }
}
