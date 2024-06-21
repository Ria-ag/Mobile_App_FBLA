import 'dart:math';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'goals_analytics_widgets.dart';
import 'my_goals_analytics.dart';
import 'package:provider/provider.dart';
import '../my_app_state.dart';
import '../theme.dart';
import 'expandable_fab.dart';

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
                      context.read<MyAppState>().addGoal(title);
                    } else {
                      context.read<MyAppState>().addChart(title);
                    }
                    Navigator.of(context).pop();
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
    final colors = [
      const Color.fromARGB(255, 147, 187, 229),
      const Color.fromARGB(255, 77, 145, 214),
      const Color.fromARGB(255, 28, 80, 133),
      const Color.fromARGB(255, 14, 50, 86),
      const Color.fromARGB(255, 84, 26, 9),
      const Color.fromARGB(255, 181, 52, 12),
      const Color.fromARGB(255, 218, 124, 96),
      const Color.fromARGB(255, 222, 168, 151),
      Colors.white
    ];

    List<PieChartSectionData> pieChartSectionData =
        List.generate(context.read<MyAppState>().items.length, (index) {
      return PieChartSectionData(
        value: context.read<MyAppState>().numberOfItems[index].toDouble(),
        color: colors[index],
      );
    });

    List<LegendItem> legendItems = [
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[0],
          color: const Color.fromARGB(255, 147, 187, 229)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[1],
          color: const Color.fromARGB(255, 77, 145, 214)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[2],
          color: const Color.fromARGB(255, 28, 80, 133)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[3],
          color: const Color.fromARGB(255, 14, 50, 86)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[4],
          color: const Color.fromARGB(255, 84, 26, 9)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[5],
          color: const Color.fromARGB(255, 181, 52, 12)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[6],
          color: const Color.fromARGB(255, 218, 124, 96)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[7],
          color: const Color.fromARGB(255, 222, 168, 151)),
      LegendItem(
          name: context.read<MyGoalsAnalytics>().items[8], color: Colors.white),
    ];

    final theme = Theme.of(context);

    // Here is the main layout of the page
    // The first section is on goals, and the second section is data and analytics
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text("Goals",
                        style: theme.textTheme.displayMedium!.copyWith(
                            color: Theme.of(context).colorScheme.background)),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 25,
                    height: MediaQuery.of(context).size.height / 2 - 100,
                    child: (context.watch<MyAppState>().goals.isNotEmpty)
                        ? SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 25, top: 15),
                              child: Column(
                                // All the goals are displayed as list tiles here
                                children: context.watch<MyAppState>().goals,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 25, top: 15),
                            child: Text(
                                "Looks a little empty in here. Click on the add button in the bottom right to get started!",
                                style: theme.textTheme.bodyMedium!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                          ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, top: 10),
              child: Text("Analytics",
                  style: theme.textTheme.displayMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary)),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, right: 20, top: 20),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        width: MediaQuery.of(context).size.width / 3,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            shadow,
                          ],
                        ),
                        child: Center(
                          // The first thing in the analytics page is the total number of tasks completed
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 20, right: 20),
                            child: Text(
                                context
                                    .read<MyGoalsAnalytics>()
                                    .totalCompletedTasks
                                    .toString(),
                                style: theme.textTheme.headlineLarge!.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .background)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        "Total Completed Tasks",
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                // Afterwards, it shows the pie chart created previously with data from the MyGoals provider
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 150,
                    child: context.read<MyGoalsAnalytics>().sum != 0.0
                        ? PieChart(
                          PieChartData(
                            sections: pieChartSectionData,
                          ),
                        )
                      : const Padding(
                        padding:  EdgeInsets.only(left: 18, top: 40),
                        child: Text("Add a goal to view chart"),
                      ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 15),
                      child: CustomLegend(legendItems: legendItems),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 5),

            // Finally, all the charts are displayed
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 25,
                height: MediaQuery.of(context).size.height / 2 - 100,
                child: (context.watch<MyAppState>().charts.isNotEmpty)
                    ? SingleChildScrollView(
                        child: Column(
                            children: context.watch<MyAppState>().charts),
                      )
                    : const Padding(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          "Looks a little empty in here. Click on the add button in the bottom right to get started!",
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 100),
          ],
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
              onPressed: () {
                log(1);
                addElementDialog(false);
              },
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
    for (int num in context.read<MyAppState>().numberOfItems) {
      if (num.isNaN) {
        return false;
      } else if (num != 0) {
        return true;
      }
    }
    return false;
  }
}
