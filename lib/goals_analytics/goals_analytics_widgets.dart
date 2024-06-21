import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_app_state.dart';
import 'chart_modal_sheet.dart';
import 'goal_modal_sheet.dart';

// This is the the class in which charts are stored
// Charts contain an ID, a name, X and Y-axis labels, a list of table data, and a list of points for the chart
// ignore: must_be_immutable
class ChartTile extends StatefulWidget {
  ChartTile({required this.chartName, super.key});
  final int chartID = DateTime.now().millisecondsSinceEpoch;
  String chartName;
  String xLabel = "";
  String yLabel = "";
  List<Map<String, double>> dataPoints =
      []; // List of maps containing x and y values

  @override
  State<ChartTile> createState() => _ChartTileState();

  // toMap method to convert the ChartTile instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'chartID': chartID,
      'chartName': chartName,
      'xLabel': xLabel,
      'yLabel': yLabel,
      'dataPoints': dataPoints,
    };
  }

  // fromMap method to create a ChartTile instance from a Map
  static ChartTile fromMap(Map<String, dynamic> map) {
    List<Map<String, double>> dataPoints =
        List<Map<String, double>>.from(map['dataPoints']);

    return ChartTile(
      chartName: map['chartName'],
    )
      ..xLabel = map['xLabel']
      ..yLabel = map['yLabel']
      ..dataPoints = dataPoints;
  }

  // Method to get spots from dataPoints
  List<FlSpot> get spots {
    return dataPoints.map((point) => FlSpot(point['x']!, point['y']!)).toList();
  }

  // Method to get rows from dataPoints
  List<DataRow> get rows {
    return dataPoints.map((point) {
      return DataRow(
        cells: [
          DataCell(TextField(
              controller: TextEditingController(text: point['x']!.toString()))),
          DataCell(TextField(
              controller: TextEditingController(text: point['y']!.toString()))),
        ],
      );
    }).toList();
  }
}

// This is where the chart is built, setting its index based on its ID
class _ChartTileState extends State<ChartTile> {
  @override
  Widget build(BuildContext context) {
    var index = context
        .watch<MyAppState>()
        .charts
        .indexWhere((chart) => chart.chartID == widget.chartID);

    return Column(
      children: [
        // This row contains the chart title and buttons to remove and edit the chart
        Row(
          children: [
            Text(
              context.watch<MyAppState>().charts[index].chartName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            IconButton(
              onPressed: () =>
                  chartModalSheet(context, widget.chartName, widget.chartID),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                context.read<MyAppState>().removeChart(widget.chartID);
              },
              icon: const Icon(Icons.remove),
            )
          ],
        ),

        // Here, the chart is displayed
        Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                width: MediaQuery.of(context).size.width - 50,
                height: 200,
                child: Container(
                    padding: const EdgeInsets.fromLTRB(5, 20, 20, 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                    child: CustomLineChart(
                      id: widget.chartID,
                    ))),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

// This is where data about the chart itself is stored
//The widget mplements the fl_charts package to store chart data
class CustomLineChart extends StatelessWidget {
  const CustomLineChart({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    var charts = context.watch<MyAppState>().charts;
    var index = charts.indexWhere((chart) => chart.chartID == id);

    // This is the variable will line chart data
    var chartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
            // The spots are the points that are displayed on the chart
            spots: context.watch<MyAppState>().charts[index].spots,
            isCurved: true,
            color: Colors.blue),
      ],
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.black),
          left: BorderSide(color: Colors.black),
        ),
      ),

      // Below is where data for the grid is set
      gridData: FlGridData(
        show: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        drawHorizontalLine: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) =>
            const FlLine(color: Colors.grey, dashArray: [5, 5]),
        getDrawingVerticalLine: (value) =>
            const FlLine(color: Colors.grey, dashArray: [5, 5]),
      ),

      // This where data for the axis titles is set
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          axisNameWidget:
              Text(context.watch<MyAppState>().charts[index].yLabel),
          sideTitles: const SideTitles(showTitles: true, reservedSize: 25),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget:
              Text(context.watch<MyAppState>().charts[index].xLabel),
          sideTitles: const SideTitles(showTitles: true, reservedSize: 25),
        ),
      ),
    );
    return LineChart(chartData);
  }
}

// This class defines a goal tile and requires a title
// ignore: must_be_immutable
class GoalTile extends StatelessWidget {
  final String title;
  String category = "Choose Category";
  String date = "";
  String description = "";
  List<Task> tasks = [];
  int totalTasks = 0;
  int completedTasks = 0;
  bool emptyGoal = true;

  GoalTile({
    super.key,
    required this.title,
  });

  // This method adds a task to the list of tasks and takes the task and context
  void addTask(task, context) {
    tasks.add(Task(task: task, isChecked: false));
    context.read<MyAppState>().addTotalTasks(title);
    emptyGoal = false;
  }

  // This method removes a task from the list of tasks and takes the index and context
  void removeTask(int index, context) {
    tasks.removeAt(index);
    context.read<MyAppState>().addCompletedTasks(title);
  }

  // Category getter method
  String getCategory() {
    return category;
  }

  // This method takes a category and change the current one with the new one
  void changeCategory(category) {
    this.category = category;
  }

  // Date getter method
  String getDate() {
    return date;
  }

  // This method takes a date and change the current one with the new one
  void changeDate(date) {
    this.date = date;
  }

  // Description getter method
  String getDescription() {
    return description;
  }

  // This method takes a description and change the current one with the new one
  void changeDescription(description) {
    this.description = description;
  }

  // Tasks getter method
  List<Task> getTasks() {
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    // Calculates how much progress a user has made on a goal
    double progressValue = context.read<MyAppState>().calculateProgress(title);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              title: Column(
                children: [
                  Row(
                    children: [
                      Text(title,
                          style: Theme.of(context).textTheme.headlineSmall),
                      const Spacer(),
                      // This button opens a modal sheet for each goal with its data
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return GoalModalSheet(title: title);
                              },
                            );
                          },
                          icon: const Icon(Icons.edit)),
                      // This button removes the goal from the list
                      IconButton(
                        onPressed: () {
                          context.read<MyAppState>().removeGoal(title);
                        },
                        icon: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                  // Creates a bar showing the progess of the goal
                  LinearProgressIndicator(
                    value: progressValue,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class LegendItem {
  final String name;
  final Color color;

  LegendItem({
    required this.name,
    required this.color,
  });
}

class CustomLegend extends StatelessWidget {
  final List<LegendItem> legendItems;

  const CustomLegend({super.key, required this.legendItems});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: legendItems.map((item) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.color,
                      border: Border.all(color: Colors.grey)),
                ),
                const SizedBox(width: 8),
                Text(item.name),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
