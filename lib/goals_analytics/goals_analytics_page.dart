import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'chart_tile.dart';
import 'expandable_fab.dart';
import 'goal_modal_sheet.dart';

class GoalsAnalyticsPage extends StatefulWidget {
  const GoalsAnalyticsPage({super.key});

  @override
  State<GoalsAnalyticsPage> createState() => _GoalsAnalyticsPageState();
}

// This class is where the goals and analytics are displayed
class _GoalsAnalyticsPageState extends State<GoalsAnalyticsPage> {
  String title = "";

  // This is the dialog box where a new chart or goal can be added
  Future<void> addElementDialog(bool isGoal) async {
    final formKey = GlobalKey<FormState>();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        title = "";
        return Form(
          key: formKey,
          child: AlertDialog(
            title: Text((isGoal) ? 'Set a Goal' : 'Create New Chart'),
            content: TextFormField(
              onChanged: (value) {
                title = value;
              },
              validator: (value) {
                if (title.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              decoration: underlineInputDecoration(
                  alwaysFloat: false,
                  context,
                  (isGoal)
                      ? 'ex. Finish FBLA Preparation'
                      : 'ex. Tasks Completed Last Month',
                  (isGoal) ? 'Name of goal' : 'Name of chart'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),

              // The entered value for the name of the goal/chart cannot be empty
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    if (isGoal) {
                      context.read<MyGoals>().add(title);
                    } else {
                      context.read<ChartDataState>().addChart(title);
                    }
                    Navigator.of(context).pop(title);
                  }
                },
                child: Text((isGoal) ? 'Add Goal' : 'Add Chart'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  // This is where the pie chart showing analytics on goal categories is created as a variable
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartSectionData = [
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[0],
        title: context.read<MyGoals>().items[0],
        color: const Color.fromARGB(255, 147, 187, 229),
        titlePositionPercentageOffset: 1.9,
      ),
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[1],
        title: context.read<MyGoals>().items[1],
        color: const Color.fromARGB(255, 77, 145, 214),
      ),
      PieChartSectionData(
          value: context.read<MyGoals>().numberOfItems[2],
          title: context.read<MyGoals>().items[2],
          color: const Color.fromARGB(255, 28, 80, 133),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[3],
        title: context.read<MyGoals>().items[3],
        color: const Color.fromARGB(255, 14, 50, 86),
        titlePositionPercentageOffset: 1.7,
      ),
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[4],
        title: context.read<MyGoals>().items[4],
        color: const Color.fromARGB(255, 84, 26, 9),
        titlePositionPercentageOffset: 2,
      ),
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[5],
        title: context.read<MyGoals>().items[5],
        color: const Color.fromARGB(255, 181, 52, 12),
      ),
      PieChartSectionData(
          value: context.read<MyGoals>().numberOfItems[6],
          title: context.read<MyGoals>().items[6],
          color: const Color.fromARGB(255, 218, 124, 96),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
          value: context.read<MyGoals>().numberOfItems[7],
          title: context.read<MyGoals>().items[7],
          color: const Color.fromARGB(255, 222, 168, 151),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
        value: context.read<MyGoals>().numberOfItems[8],
        title: context.read<MyGoals>().items[8],
        color: Colors.white,
        titlePositionPercentageOffset: 1.6,
      ),
    ];
    final theme = Theme.of(context);

    // Here is the main layout of the page
    // The first section is on goals, and the second section is data and analytics
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Goals & Analytics", style: theme.textTheme.displayLarge),
              const SizedBox(height: 20),
              Text("Goals", style: theme.textTheme.displayMedium),
              SizedBox(
                width: MediaQuery.of(context).size.width - 25,
                height: MediaQuery.of(context).size.height / 2 - 170,
                child: (context.watch<MyGoals>().goals.isNotEmpty)
                    ? SingleChildScrollView(
                        child: Column(
                          // All the goals are displayed as list tiles here
                          children: context.watch<MyGoals>().goals,
                        ),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Looks a little empty in here. Click on the add button in the bottom right to get started!",
                        ),
                      ),
              ),
              Text("Analytics", style: theme.textTheme.displayMedium),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.background,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          shadow,
                        ],
                      ),
                      child: Center(
                        // The first thing in the analytics page is the total number of tasks completed
                        child: Column(
                          children: [
                            Text(context.read<MyGoals>().done,
                                style: theme.textTheme.displayLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary)),
                            Text(
                              "Total Completed Tasks",
                              style: theme.textTheme.displaySmall!.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Afterwards, it shows the pie chart created previously with data from the MyGoals provider
              Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 25,
                  height: 200,
                  child: context.read<MyGoals>().sum != 0.0
                      ? PieChart(
                          PieChartData(
                            sections: pieChartSectionData,
                          ),
                        )
                      : const Text("Add a goal to view chart"),
                ),
              ),

              const SizedBox(height: 5),

              // Finally, all the charts are displayed
              SizedBox(
                width: MediaQuery.of(context).size.width - 25,
                height: MediaQuery.of(context).size.height / 2 - 160,
                child: (context.watch<ChartDataState>().charts.isNotEmpty)
                    ? SingleChildScrollView(
                        child: Column(
                            children: context.watch<ChartDataState>().charts),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Looks a little empty in here. Click on the add button in the bottom right to get started!",
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),

      // The floating action button used on this page is a button that can be expanded into two others
      // One is to create a new goal, the other is to create a new chart
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 75, right: 7.5),
        child: ExpandableFab(
          distance: 60,
          children: [
            ActionButton(
              onPressed: () => addElementDialog(false),
              icon: const Icon(Icons.addchart),
            ),
            ActionButton(
              onPressed: () => addElementDialog(true),
              icon: const Icon(Icons.assignment_add),
            ),
          ],
        ),
      ),
    );
  }

  // The method checks if any section of the pie chart data is empty
  bool checkIfEmpty() {
    for (double num in context.read<MyGoals>().numberOfItems) {
      if (num.isNaN) {
        return false;
      } else if (num != 0) {
        return true;
      }
    }
    return false;
  }
}
