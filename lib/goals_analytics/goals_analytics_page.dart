import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'chart_tile.dart';
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
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((isGoal) ? 'Set a Goal' : 'Create New Chart'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: InputDecoration(
                labelText: (isGoal) ? 'Name of goal' : 'Name of chart'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),

            // The entered value for the name of the goal/chart cannot be empty
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  if (isGoal) {
                    Provider.of<MyGoals>(context, listen: false).add(title);
                  } else {
                    Provider.of<ChartDataState>(context, listen: false)
                        .addChart(title);
                  }
                  title = "";
                }
                Navigator.of(context).pop(title);
              },
              child: Text((isGoal) ? 'Add Goal' : 'Add Chart'),
            ),
          ],
        );
      },
    );
  }

  @override
  // This is where the pie chart showing analytics on goal categories is created as a variable
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartSectionData = [
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[0],
        title: Provider.of<MyGoals>(context, listen: false).items[0],
        color: const Color.fromARGB(255, 147, 187, 229),
        titlePositionPercentageOffset: 1.9,
      ),
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[1],
        title: Provider.of<MyGoals>(context, listen: false).items[1],
        color: const Color.fromARGB(255, 77, 145, 214),
      ),
      PieChartSectionData(
          value: Provider.of<MyGoals>(context, listen: false).numberOfItems[2],
          title: Provider.of<MyGoals>(context, listen: false).items[2],
          color: const Color.fromARGB(255, 28, 80, 133),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[3],
        title: Provider.of<MyGoals>(context, listen: false).items[3],
        color: const Color.fromARGB(255, 14, 50, 86),
        titlePositionPercentageOffset: 1.7,
      ),
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[4],
        title: Provider.of<MyGoals>(context, listen: false).items[4],
        color: const Color.fromARGB(255, 84, 26, 9),
        titlePositionPercentageOffset: 2,
      ),
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[5],
        title: Provider.of<MyGoals>(context, listen: false).items[5],
        color: const Color.fromARGB(255, 181, 52, 12),
      ),
      PieChartSectionData(
          value: Provider.of<MyGoals>(context, listen: false).numberOfItems[6],
          title: Provider.of<MyGoals>(context, listen: false).items[6],
          color: const Color.fromARGB(255, 218, 124, 96),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
          value: Provider.of<MyGoals>(context, listen: false).numberOfItems[7],
          title: Provider.of<MyGoals>(context, listen: false).items[7],
          color: const Color.fromARGB(255, 222, 168, 151),
          titlePositionPercentageOffset: 1.4),
      PieChartSectionData(
        value: Provider.of<MyGoals>(context, listen: false).numberOfItems[8],
        title: Provider.of<MyGoals>(context, listen: false).items[8],
        color: Colors.white,
        titlePositionPercentageOffset: 1.6,
      ),
    ];

    // Here is the main layout of the page
    //The first section is on goals, and the second section is data andn analytics
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text("Goals & Analytics",
                  style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 20),
              Text("Goals", style: Theme.of(context).textTheme.displayMedium),
              SizedBox(
                width: MediaQuery.of(context).size.width - 25,
                height: MediaQuery.of(context).size.height / 2 - 170,
                child: (context.watch<MyGoals>().goals.isNotEmpty)
                    ? SingleChildScrollView(
                        child: Column(
                          // The all goals are displayed as list tiles here
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
              Text("Analytics",
                  style: Theme.of(context).textTheme.displayMedium),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.background,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        // The first thing in the analtics page is the total number of tasks completed
                        child: Column(
                          children: [
                            Text(
                                Provider.of<MyGoals>(context, listen: false)
                                    .done,
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                            Text(
                              "Total Completed Tasks",
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .secondary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Afterwards, it shows the pie chart created previously with data from the MyGoals provider
              Consumer<MyGoals>(
                builder: (context, myGoals, child) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 25, bottom: 25),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 25,
                      height: 200,
                      child: Provider.of<MyGoals>(context, listen: false).sum !=
                              0.0
                          ? PieChart(
                              PieChartData(
                                sections: pieChartSectionData,
                              ),
                            )
                          : const Text("Add a goal to view chart"),
                    ),
                  );
                },
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
      floatingActionButton: ExpandableFab(
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
    );
  }

  // The method checks if any section of the pie chart data is empty
  bool checkIfEmpty() {
    for (double num
        in Provider.of<MyGoals>(context, listen: false).numberOfItems) {
      if (num.isNaN) {
        return false;
      } else if (num != 0) {
        return true;
      }
    }
    return false;
  }
}

// Below, the expandable floating action button is created
// It stores children buttons, whetherit should be open initially, and the distance of the children from itself
@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

// The expandable floating action button's display, state, and animations are managed here
// The mixin allows for animation statemanagement
class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override

  // When the class's initial state is displayed, all the vairables are set to given values
  // Tbe animation type is also set
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  // This method is to dispose of the controller and widget after it is not needed
  // It is called when this object is removed from the tree permanently.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // This method deals with toggling the expandable floating action button
  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  // THe floating action button setup is displayed here
  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  // This widget is what the parent floating action button looks like when opened
  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // This widget is the where the children floating action buttons are added
  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  // This widget is what the parent floating action button looks like when closed
  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

// The expanding action button is the class of the child floating action button
// It stores the angle that the button goes out to, the animation, the max linear distance, and a child widget
@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  // Here, the widget is built, using offset to position the widget relative to the parent button
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

// This is the actual layout and build of the children button of the floating action button
// It takes an onPressed callback function and an icon
@immutable
class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        color: theme.colorScheme.onSecondary,
      ),
    );
  }
}
