import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import 'chart_tile.dart';

// This is the modal sheet for displaying the chart editor
Future<void> chartModalSheet(BuildContext context, String title, int id) {
  final formKey = GlobalKey<FormState>();
  ChartTile chartTile = context
      .read<ChartDataState>()
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
                  // This is where the chart title and exit button are displayed
                  children: [
                    Row(
                      children: [
                        Text(title,
                            style: Theme.of(context).textTheme.headlineSmall),
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

// This is the text field decoration used throughout the app

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
    var chartState = context.read<ChartDataState>();
    int index = chartState.charts.indexOf(widget.chartTile);
    rows = List<DataRow>.from(chartState.charts[index].rows);
  }

  // This method adds a row to the table
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

  // This method removes the last row of the table
  void removeRow() {
    setState(() {
      rows.removeAt(rows.length - 1);
    });
  }

  // This is where the data table and buttons are displayed
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
                // These are the buttons that allow the user to update the table and chart
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SizedBox(
                      width: 225,
                      height: 50,
                      child: CustomElevatedButton(
                        onPressed: () => addRow(),
<<<<<<< Updated upstream
=======
<<<<<<< Updated upstream
                        child: const Text('Add Row'),
=======
                        buttonColor: Theme.of(context).colorScheme.secondary,
>>>>>>> Stashed changes
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.add),
                            Text("Add Row"),
                          ],
                        ),
<<<<<<< Updated upstream
=======
>>>>>>> Stashed changes
>>>>>>> Stashed changes
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
<<<<<<< Updated upstream
                      width: 225,
                      height: 50,
                      child: CustomElevatedButton(
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.remove),
                            Text("Remove Last Row"),
                          ],
                        ),
=======
<<<<<<< Updated upstream
                      width: 150,
                      height: 30,
                      child: FloatingActionButton(
                        heroTag: "button 2",
                        child: const Text("Remove Last Row"),
>>>>>>> Stashed changes
                        onPressed: () => removeRow(),
                      ),
                    ),
                    const SizedBox(height: 10),
<<<<<<< Updated upstream
=======
=======
                      width: 225,
                      height: 50,
                      child: CustomElevatedButton(
                        onPressed: () => removeRow(),
                        buttonColor: Theme.of(context).colorScheme.secondary,
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.remove),
                            Text("Remove Last Row"),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
>>>>>>> Stashed changes
                    SizedBox(
                      width: 225,
                      height: 50,
                      child: CustomElevatedButton(
<<<<<<< Updated upstream
=======
                        onPressed: () =>
                            readChartState.updateChartData(rows, index),
                        buttonColor: Theme.of(context).colorScheme.secondary,
>>>>>>> Stashed changes
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.save),
                            Text("Save Chart"),
                          ],
                        ),
<<<<<<< Updated upstream
                        onPressed: () =>
                            readChartState.updateChartData(rows, index),
                      ),
                    ),
=======
                      ),
                    ),
>>>>>>> Stashed changes
>>>>>>> Stashed changes
                  ],
                ),
                // Here is the data table, which contains the columns "X" and "Y"
                DataTable(
                  columnSpacing: 40,
                  horizontalMargin: 20,
                  showBottomBorder: true,
                  dividerThickness: 2,
                  // border: 
                  // const TableBorder({BorderSide top = BorderSide.none})

                  // TableBorder.all(
                  //   width: 2,
                  //   color: Theme.of(context).colorScheme.secondary,
                  // ),
                  columns: const [
                    DataColumn(label: Text('X')),
                    DataColumn(label: Text('Y')),
                  ],
                  rows: rows,
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
