import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'package:mobileapp/goal_tile.dart';
import 'package:provider/provider.dart';

import 'chart_modal_sheet.dart';

class ChartDataState extends ChangeNotifier {
  String chartName = "";
  String xLabel = "";
  String yLabel = "";
  List<DataRow> rows = [];
  List<FlSpot> spots = [];

  void removeRow() {
    rows.removeAt(rows.length - 1);
    notifyListeners();
  }

  void addRow(DataRow row) {
    rows.add(row);
    notifyListeners();
  }

  void clearChart() {
    rows = [];
    spots = [];
    notifyListeners();
  }

  void updateChartName(String value) {
    chartName = value;
    notifyListeners();
  }

  void updateChartData(List<DataRow> rows) {
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
    spots = newSpots;
    notifyListeners();
  }
}

class GoalsAnalyticsPage extends StatefulWidget {
  const GoalsAnalyticsPage({super.key});
  
  @override
  State<GoalsAnalyticsPage> createState() => _GoalsAnalyticsPageState();
}

class _GoalsAnalyticsPageState extends State<GoalsAnalyticsPage> {
  String title = "";

  Future<void> addGoalDialog() async {
   await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set a Goal'),
          content: TextField(
            onChanged: (value) {
              title = value;
            },
            decoration: const InputDecoration(labelText: 'Name of goal'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                debugPrint("clicked");
                if (title.isNotEmpty) {
                  Provider.of<MyGoals>(context, listen: false).add(title);
                }
                Navigator.of(context).pop(title);
              },
              child: const Text('Add Goal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: context.read<MyGoals>(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:  Column(
            children:[ 
              const Text("Goals & Analytics", style: TextStyle(fontSize: 20)),
              const Text("Goals"),
              SizedBox(
                    width: MediaQuery.of(context).size.width - 25,
                    height: 400,
                    child: (context.watch<MyGoals>().goals.isNotEmpty)
                        ? SingleChildScrollView(
                            child: Column(
                              children: context
                                  .watch<MyGoals>().goals,
                            ),
                          )
                        : const Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                                "Looks a little empty in here. Click on the edit button in the bottom right to get started!"),
                          ),
                  ),
              const Text("Analytics"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: (context.watch<ChartDataState>().rows.isEmpty)
                    ? []
                    : [
                        Text(context.watch<ChartDataState>().chartName),
                        TextButton(
                          onPressed: () =>
                              chartModalSheet(context, "Sample Chart"),
                          child: const Icon(Icons.edit),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<ChartDataState>().clearChart();
                          },
                          child: const Icon(Icons.remove),
                        )
                      ],
              ),
              Center(
                child: (context.watch<ChartDataState>().rows.isEmpty)
                    ? Container()
                    : SizedBox(
                        width: MediaQuery.of(context).size.width - 50,
                        height: 200,
                        child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 20, 20, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.secondary),
                            ),
                            child: const CustomLineChart())),
              ),
            ],
          ),
        ),
        floatingActionButton: ExpandableFab(
          distance: 60,
          children: [
            ActionButton(
              onPressed: () => chartModalSheet(context, "Sample Quiz"),
              icon: const Icon(Icons.addchart),
            ),
            ActionButton(
              onPressed: () => addGoalDialog(),
              icon: const Icon(Icons.checklist),
            ),
          ],
        )
      ),
    );
  }
}

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

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

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

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    var chartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
            spots: context.watch<ChartDataState>().spots,
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
      titlesData: const FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
    );
    return LineChart(chartData);
  }
}
