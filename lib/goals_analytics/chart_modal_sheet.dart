import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../my_app_state.dart';
import '../theme.dart';
import 'goals_analytics_widgets.dart';

// This is the modal sheet for displaying the chart editor
Future<void> chartModalSheet(BuildContext context, String title, int id) {
  final formKey = GlobalKey<FormState>();
  ChartTile chartTile = context
      .read<MyAppState>()
      .charts
      .firstWhere((chart) => chart.chartID == id);

  // The modal sheet uses both a provider class and a stateful builder to manage states
  // It manages its own state, as well as the state of the chart displayed on the goals and analytics page
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
      return ChangeNotifierProvider.value(
        value: context.read<MyAppState>(),
        child: StatefulBuilder(builder: (context, setState) {
          final readChartState = context.read<MyAppState>();
          int index = context.watch<MyAppState>().charts.indexOf(chartTile);

          return SizedBox(
            height: MediaQuery.of(context).size.height - 50,
            width: MediaQuery.of(context).size.width - 15,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: Column(
                  // This is where the chart title and exit button are displayed
                  children: [
                    Row(
                      children: [
                        Text(title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall!
                                .copyWith(
                                    color: Theme.of(context).primaryColor)),
                        const Spacer(),
                        IconButton(
                            icon: const Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),

                    // Below are the various TextFormFields where the chart's name and labels can be edited
                    // All the fields are validated semantically and syntactically
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          validator: (value) => noEmptyField(value),
                          initialValue: chartTile.chartName,
                          onChanged: (value) =>
                              readChartState.updateName(value, index),
                          decoration: underlineInputDecoration(context,
                              "ex. Tasks Completed Last Month", "Chart Name"),
                        ),
                        TextFormField(
                          validator: (value) => noEmptyField(value),
                          initialValue: chartTile.xLabel,
                          onChanged: (value) =>
                              readChartState.updateXLabel(value, index),
                          decoration: underlineInputDecoration(context,
                              "ex. Days Since Jan 1st", "X-Axis Label"),
                        ),
                        TextFormField(
                          validator: (value) => noEmptyField(value),
                          initialValue: chartTile.yLabel,
                          onChanged: (value) =>
                              readChartState.updateYLabel(value, index),
                          decoration: underlineInputDecoration(
                              context, "ex. # of Tasks", "Y-Axis Label"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // This is a displayed widget that allows the user to change the chart's numerical data
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

// This widget allows users to edit the points on a certain line chart
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

  // The widget initially checks for pre-existing data and copies it into a local variable
  // The table displays this local variable, and all widget data is stored there, too
  // Data is transferred over after the user updates the chart
  @override
  void initState() {
    super.initState();
    var chartState = context.read<MyAppState>();
    int index = chartState.charts.indexOf(widget.chartTile);
    rows = List<DataRow>.from(chartState.charts[index].rows);
  }

  // This method adds a row to the table
  void addRow() {
    setState(() {
      rows.add(
        DataRow(
          cells: [
            DataCell(
              TextField(
                  controller: TextEditingController(),
                  decoration: underlineInputDecoration(context),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface)),
            ),
            DataCell(
              TextField(
                  controller: TextEditingController(),
                  decoration: underlineInputDecoration(context),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.surface)),
            ),
          ],
        ),
      );
    });
  }

  // This method removes the last row of the table
  void removeRow() {
    setState(() {
      rows.removeAt(rows.length - 1);
    });
  }

  // This is where the data table and buttons are displayed
  @override
  Widget build(BuildContext context) {
    var readChartState = context.read<MyAppState>();
    var watchChartState = context.watch<MyAppState>();
    int index = watchChartState.charts.indexOf(widget.chartTile);

    return SizedBox(
      height: MediaQuery.of(context).size.height - 375,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // These are the buttons that allow the user to update the table and chart
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 185,
                      height: 50,
                      child: CustomElevatedButton(
                        onPressed: () => addRow(),
                        buttonColor: Theme.of(context).colorScheme.secondary,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.add),
                            Text(
                              "Add Row",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 185,
                      height: 50,
                      child: CustomElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.remove),
                            Text(
                              "Remove Last Row",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        onPressed: () => removeRow(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: 185,
                      height: 50,
                      child: CustomElevatedButton(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Icon(Icons.save),
                            Text(
                              "Save Chart",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        onPressed: () =>
                            readChartState.updateChartData(rows, index),
                      ),
                    ),
                  ],
                ),
                // Here is the data table, which contains the columns "X" and "Y"
                Column(
                  children: [
                    Text("Data",
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall!
                            .copyWith(
                                color:
                                    Theme.of(context).colorScheme.secondary)),
                    const SizedBox(height: 5),
                    DataTable(
                      columnSpacing: 40,
                      horizontalMargin: 20,
                      border: const TableBorder(
                        verticalInside: BorderSide(
                            width: 1,
                            style: BorderStyle.solid,
                            color: Colors.grey),
                        horizontalInside: BorderSide(
                            width: 2,
                            style: BorderStyle.solid,
                            color: Colors.grey),
                      ),
                      dataRowColor: WidgetStateColor.resolveWith(
                          (states) => const Color.fromARGB(255, 88, 108, 139)),
                      columns: [
                        DataColumn(
                            label: Text('X',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary))),
                        DataColumn(
                          label: Text(
                            'Y',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondary),
                          ),
                        ),
                      ],
                      rows: rows,
                    ),
                  ],
                ),
                const SizedBox(width: 10),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // This is the decoration used by date cells
  InputDecoration underlineInputDecoration(BuildContext context) {
    return const InputDecoration(
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Colors.transparent,
        ),
      ),
    );
  }
}
