import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chart_modal_sheet.dart';

class ChartDataState extends ChangeNotifier {
  List<ChartTile> charts = [];
  void addChart(String title) {
    charts.add(ChartTile(
      chartName: title,
    ));
    notifyListeners();
  }

  void removeChart(int id) {
    charts.remove(charts.firstWhere((chart) => chart.chartID == id));
    notifyListeners();
  }

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

  updateName(String name, int index) {
    charts[index].chartName = name;
    notifyListeners();
  }

  updateXLabel(String label, int index) {
    charts[index].xLabel = label;
    notifyListeners();
  }

  updateYLabel(String label, int index) {
    charts[index].yLabel = label;
    notifyListeners();
  }
}

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

class _ChartTileState extends State<ChartTile> {
  @override
  Widget build(BuildContext context) {
    var index = context
        .watch<ChartDataState>()
        .charts
        .indexWhere((chart) => chart.chartID == widget.chartID);

    return Column(
      children: [
        Row(
          children: [
            Text(
              context.watch<ChartDataState>().charts[index].chartName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const Spacer(),
            TextButton(
              onPressed: () =>
                  chartModalSheet(context, widget.chartName, widget.chartID),
              child: const Icon(Icons.edit),
            ),
            TextButton(
              onPressed: () {
                context.read<ChartDataState>().removeChart(widget.chartID);
              },
              child: const Icon(Icons.remove),
            )
          ],
        ),
        Center(
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
        const SizedBox(height: 10),
      ],
    );
  }
}

class CustomLineChart extends StatelessWidget {
  const CustomLineChart({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    var charts = context.watch<ChartDataState>().charts;
    var index = charts.indexWhere((chart) => chart.chartID == id);

    var chartData = LineChartData(
      lineBarsData: [
        LineChartBarData(
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
