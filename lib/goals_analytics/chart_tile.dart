import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chart_modal_sheet.dart';

// This is the ChangeNotifier model used to manage chart states
class ChartDataState extends ChangeNotifier {
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
}

// This is the the class in which charts are stored
// Charts contain an ID, a name, X and Y-axis labels, a list of table data, and a list of points for the chart
// ignore: must_be_immutable
class ChartTile extends StatefulWidget {
  ChartTile({required this.chartName, super.key});
  final chartID = DateTime.now().millisecondsSinceEpoch;
  String chartName;
  String xLabel = "";
  String yLabel = "";
  List<DataRow> rows = [];
  List<FlSpot> spots = [];

  @override
  State<ChartTile> createState() => _ChartTileState();
}

// This is where the chart is built, setting its index based on its ID
class _ChartTileState extends State<ChartTile> {
  @override
  Widget build(BuildContext context) {
    var index = context
        .watch<ChartDataState>()
        .charts
        .indexWhere((chart) => chart.chartID == widget.chartID);

    return Column(
      children: [
        // This row contains the chart title and buttons to remove and edit the chart
        Row(
          children: [
            Text(
              context.watch<ChartDataState>().charts[index].chartName,
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
                context.read<ChartDataState>().removeChart(widget.chartID);
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
    var charts = context.watch<ChartDataState>().charts;
    var index = charts.indexWhere((chart) => chart.chartID == id);

    // This is the variable will line chart data
    var chartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
            // The spots are the points that are displayed on the chart
            spots: context.watch<ChartDataState>().charts[index].spots,
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
              Text(context.watch<ChartDataState>().charts[index].yLabel),
          sideTitles: const SideTitles(showTitles: true, reservedSize: 25),
        ),
        bottomTitles: AxisTitles(
          axisNameWidget:
              Text(context.watch<ChartDataState>().charts[index].xLabel),
          sideTitles: const SideTitles(showTitles: true, reservedSize: 25),
        ),
      ),
    );
    return LineChart(chartData);
  }
}
