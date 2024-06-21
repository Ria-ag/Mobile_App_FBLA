import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/goals_analytics/goal_modal_sheet.dart';

import 'goals_analytics_widgets.dart';

// This is the ChangeNotifier model used to manage chart and goal states
class MyGoalsAnalytics extends ChangeNotifier {
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
  void updateChartData(List<DataRow> rows, int index) {
    List<FlSpot> newSpots = [];

    for (var row in rows) {
      var cells = row.cells;
      double? x =
          double.tryParse((cells[0].child as TextField).controller!.text);
      double? y =
          double.tryParse((cells[1].child as TextField).controller!.text);
      if (x != null && y != null) {
        newSpots.add(FlSpot(x, y));
      }
    }
    charts[index].spots = newSpots;

    charts[index].rows = rows;
    notifyListeners();
  }

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
  String done = "0";

  List<String> items = [
    "Athletics",
    "Performing Arts",
    "Community Service",
    "Awards",
    "Honors Classes",
    "Clubs/Organizations",
    "Projects",
    "Tests",
    "Other"
  ];
  List<double> numberOfItems = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  double sum = 0.0;

  GoalTile findGoal(String title) {
    return goals.firstWhere((goal) => goal.title == title);
  }

  // This method takes a title and adds a new goal tile to the list
  void add(String title) {
    goals.add(GoalTile(title: title));
    notifyListeners();
  }

  // This method takes a title and removes that goal tile from the list
  void remove(String title) {
    goals.remove(findGoal(title));
    notifyListeners();
  }

  // This method takes a title and calculates how much progress that goal has made
  // Progress is defined by completed/total
  double calculateProgress(title) {
    if (findGoal(title).totalTasks == 0) {
      return 0.0;
    }
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
    done = totalCompletedTasks.toString();
    notifyListeners();
  }

  void unCheck(title){
    findGoal(title).completedTasks--;
    totalCompletedTasks--;
    done = totalCompletedTasks.toString();
    notifyListeners();
  }

  void deleteTask(title, index){
    findGoal(title).tasks.removeAt(index);
    notifyListeners();
  }

  // This method updates the number of items of the new category
  void updatePieChart() {
    Map<String, int> categoryIndexMap = {
      for (int i = 0; i < items.length; i++) items[i]: i
    };

    for (final goal in goals) {
      int index = categoryIndexMap[goal.getCategory()] ?? 8;
      numberOfItems[index]++;
    }

    notifyListeners();
  }
}
