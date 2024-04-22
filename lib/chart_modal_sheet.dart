import 'package:flutter/material.dart';
import 'package:mobileapp/goals_analytics_page.dart';
import 'package:provider/provider.dart';

Future<void> chartModalSheet(BuildContext context, String title) {
  bool editable = false;
  final formKey = GlobalKey<FormState>();

  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
      return StatefulBuilder(builder: (context, setState) {
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
                      Text(title),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() =>
                              (!editable) ? editable = true : editable = false);
                        },
                        child: Icon(
                          (!editable) ? Icons.edit : Icons.check,
                          size: 20,
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
                          initialValue:
                              context.watch<ChartDataState>().chartName,
                          onChanged: (value) => context
                              .read<ChartDataState>()
                              .updateChartName(value),
                          decoration: underlineInputDecoration(
                              context, "ex. A", "Grade"),
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          initialValue:
                              context.watch<ChartDataState>().chartName,
                          onChanged: (value) => context
                              .read<ChartDataState>()
                              .updateChartName(value),
                          decoration: underlineInputDecoration(
                              context, "ex. A", "Grade"),
                        ),
                        TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          initialValue:
                              context.watch<ChartDataState>().chartName,
                          onChanged: (value) => context
                              .read<ChartDataState>()
                              .updateChartName(value),
                          decoration: underlineInputDecoration(
                              context, "ex. A", "Grade"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const ChartDataInputWidget(),
                ],
              ),
            ),
          ),
        );
      });
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
  const ChartDataInputWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ChartDataInputWidgetState createState() => _ChartDataInputWidgetState();
}

class _ChartDataInputWidgetState extends State<ChartDataInputWidget> {
  @override
  Widget build(BuildContext context) {
    var readChartState = context.read<ChartDataState>();
    var watchChartState = context.watch<ChartDataState>();
    List<DataRow> rows = watchChartState.rows;

    void addRow() {
      watchChartState.addRow(
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
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width - 25,
      height: MediaQuery.of(context).size.height - 330,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: Row(
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
              const SizedBox(height: 16),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: addRow,
                    child: const Text('Add Row'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text("Remove Last Row"),
                    onPressed: () => readChartState.removeRow(),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () => readChartState.updateChartData(rows),
                    child: const Text('Update Chart'),
                  ),
                ],
              ),
            ],
          ),
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
      // enabledBorder: const UnderlineInputBorder(
      //     borderSide: BorderSide(color: Colors.black)),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}
