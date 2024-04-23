import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chart_tile.dart';

Future<void> chartModalSheet(BuildContext context, String title, int id) {
  final formKey = GlobalKey<FormState>();
  ChartTile chartTile = context
      .read<ChartDataState>()
      .charts
      .firstWhere((chart) => chart.chartID == id);

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
        value: context.read<ChartDataState>(),
        child: StatefulBuilder(builder: (context, setState) {
          final readChartState = context.read<ChartDataState>();
          int index = context.watch<ChartDataState>().charts.indexOf(chartTile);

          return SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.width - 15,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.headlineSmall),
                        const Spacer(),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        TextButton(
                            child: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            initialValue: chartTile.chartName,
                            onChanged: (value) =>
                                readChartState.updateName(value, index),
                            decoration: underlineInputDecoration(context,
                                "ex. Tasks Completed Last Month", "Chart Name"),
                          ),
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            initialValue: chartTile.xLabel,
                            onChanged: (value) =>
                                readChartState.updateXLabel(value, index),
                            decoration: underlineInputDecoration(context,
                                "ex. Days Since Jan 1st", "X-Axis Label"),
                          ),
                          TextFormField(
                            style: Theme.of(context).textTheme.bodyMedium,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            initialValue: chartTile.yLabel,
                            onChanged: (value) =>
                                readChartState.updateYLabel(value, index),
                            decoration: underlineInputDecoration(
                                context, "ex. # of Tasks", "Y-Axis Label"),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ChartDataInputWidget(chartTile: chartTile),
                  ],
                ),
              ),
            ),
          );
        }),
      );
    },
  );
}

InputDecoration underlineInputDecoration(
    BuildContext context, String hint, String label) {
  return InputDecoration(
    hintText: hint,
    labelText: label,
    floatingLabelBehavior: FloatingLabelBehavior.always,
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).colorScheme.secondary,
      ),
    ),
    enabledBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
    focusedErrorBorder:
        const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    floatingLabelStyle:
        MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
      final Color color = states.contains(MaterialState.focused)
          ? (states.contains(MaterialState.error)
              ? Colors.red
              : Theme.of(context).colorScheme.secondary)
          : Colors.black;
      return TextStyle(color: color);
    }),
  );
}

// ignore: must_be_immutable
class ChartDataInputWidget extends StatefulWidget {
  const ChartDataInputWidget({required this.chartTile, super.key});
  final ChartTile chartTile;

  @override
  // ignore: library_private_types_in_public_api
  _ChartDataInputWidgetState createState() => _ChartDataInputWidgetState();
}

class _ChartDataInputWidgetState extends State<ChartDataInputWidget> {
  late List<DataRow> rows;

  @override
  void initState() {
    super.initState();
    var chartState = context.read<ChartDataState>();
    int index = chartState.charts.indexOf(widget.chartTile);
    rows = List<DataRow>.from(chartState.charts[index].rows);
  }

  void addRow() {
    setState(() {
      rows.add(
        DataRow(
          cells: [
            DataCell(TextField(
                controller: TextEditingController(),
                decoration: underlineInputDecoration(context))),
            DataCell(TextField(
                controller: TextEditingController(),
                decoration: underlineInputDecoration(context))),
          ],
        ),
      );
    });
  }

  void removeRow() {
    setState(() {
      rows.removeAt(rows.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    var readChartState = context.read<ChartDataState>();
    var watchChartState = context.watch<ChartDataState>();
    int index = watchChartState.charts.indexOf(widget.chartTile);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 330,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DataTable(
                  columnSpacing: 40,
                  horizontalMargin: 20,
                  border: TableBorder.all(
                    width: 2,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  columns: const [
                    DataColumn(label: Text('X')),
                    DataColumn(label: Text('Y')),
                  ],
                  rows: rows,
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 150,
                      height: 30,
                      child: FloatingActionButton(
                        heroTag: "button 1",
                        onPressed: () => addRow(),
                        child: const Text('Add Row'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 150,
                      height: 30,
                      child: FloatingActionButton(
                        heroTag: "button 2",
                        child: const Text("Remove Last Row"),
                        onPressed: () => removeRow(),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ],
            ),
            TextButton(
              onPressed: () => readChartState.updateChartData(rows, index),
              child: Text('Save Chart',
                  style: Theme.of(context).textTheme.displaySmall),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration underlineInputDecoration(BuildContext context) {
    return InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}
