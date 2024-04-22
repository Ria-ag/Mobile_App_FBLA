import 'package:flutter/material.dart';
import 'package:mobileapp/goal_tile.dart';
import 'package:provider/provider.dart';

class MyGoals extends ChangeNotifier {
  List<GoalTile> goals = [];
  int totalTasks = 0;
  int completedTasks = 0;

  void add(String title) {
    goals.add(GoalTile(title: title));
    notifyListeners();
  }

  double calculateProgress() {
    if (totalTasks == 0) {
      return 0.0;
    }
    return completedTasks / totalTasks;
  }
  void addTotalTasks() {
    totalTasks++;
    notifyListeners();
  }

  void addCompletedTasks() {
    completedTasks++;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class GoalModalSheet extends StatefulWidget {
  GoalModalSheet({super.key, required this.title});
  final String title;

  String category = "Athletics";
  String date = "";
  String description = "";
  List<Task> tasks = [];
  bool editable = false;
  List<String> items = ["Athletics", "Performing Arts", "Community Service", "Awards",
                "Honors Classes", "Clubs/Organizations", "Projects", "Tests", "Other"];
  TextEditingController taskController = TextEditingController();

  @override
  GoalModalSheetState createState() => GoalModalSheetState();
}

class GoalModalSheetState extends State<GoalModalSheet> {
  void addTask(String task) {
    setState(() {
      widget.tasks.add(Task(task: task, isChecked: false));
    });
    Provider.of<MyGoals>(context, listen: false).addTotalTasks();
    widget.taskController.clear();
  }

  void removeTask(int index) {
    setState(() {
      widget.tasks.removeAt(index);
    });
    Provider.of<MyGoals>(context, listen: false).addCompletedTasks();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
          height: MediaQuery.of(context).size.height - 50,
          width: MediaQuery.of(context).size.width - 15,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(widget.title, style: Theme.of(context).textTheme.headlineSmall),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          !widget.editable
                          ? setState(() {
                              widget.editable = true;
                          })
                          : setState(() {
                              widget.editable = false;
                          });
                        },
                        child: Icon(
                          (!widget.editable) ? Icons.edit : Icons.check,
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
                  !widget.editable
                  ? buildRichText(context, "Category: ", widget.category, Theme.of(context).textTheme.bodyMedium)
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Category", style: Theme.of(context).textTheme.bodyMedium),
                      DropdownButton<String>(
                        value: widget.category,
                        items: widget.items
                          .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
                          .toList(),
                        onChanged: (item) {setState(() {widget.category = item!;});},
                      ),
                    ],
                  ),
                  (!widget.editable)
                  ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: buildRichText(context, "Deadline: ", widget.date, Theme.of(context).textTheme.bodyMedium),
                  )
                  : (!widget.editable)
                  ? buildRichText(context, "Deadline", widget.date,
                    Theme.of(context).textTheme.bodyMedium)
                  : TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: TextEditingController(text: widget.date),
                    readOnly: true, // Prevents manual editing
                    decoration: underlineInputDecoration(
                        context, "ex. 4/24/2024", "Deadline"),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 25)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          widget.date = formatDate(pickedDate.toString().substring(0, 10));
                        });
                      }
                    },
                  ),
                  (!widget.editable)
                  ? Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: (widget.description.isEmpty)
                        ? Text("No description",
                            style: Theme.of(context).textTheme.bodyMedium)
                        : buildRichText(
                            context,
                            "Description:\n",
                            widget.description,
                            Theme.of(context).textTheme.bodyMedium),
                  )
                  : TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      minLines: 1,
                      maxLines: 4,
                      initialValue: widget.description,
                      onChanged: (value) {
                        setState(() {
                          widget.description = value;
                        });
                      },
                      decoration: underlineInputDecoration(
                          context, "ex. In this I...", "Description"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Divider(
                            color: Theme.of(context).colorScheme.secondary,
                            thickness: 2,
                          ),
                    ),
                  Text("Tasks", style: Theme.of(context).textTheme.headlineSmall),
                  TextField(
                    controller: widget.taskController,
                    decoration: const InputDecoration( labelText: 'Enter Task',),
                    onSubmitted: (value) {
                      addTask(value);
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                    itemCount: widget.tasks.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        title: Text(widget.tasks[index].task),
                        value: widget.tasks[index].isChecked,
                        onChanged: (value) {
                          setState(() {
                            widget.tasks[index].isChecked = value!;
                            removeTask(index);
                          });
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
      ),
    );
  }

  Widget buildRichText(
      BuildContext context, String label, String value, TextStyle? style) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: style,
          ),
        ],
      ),
    );
  }

  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }

  InputDecoration underlineInputDecoration(
      BuildContext context, String hint, String label,
      {String? errorText}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // enabledBorder: const UnderlineInputBorder(
      //     borderSide: BorderSide(color: Colors.blueGrey)),
      //labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 13),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
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
}

class Task {
  Task({required this.task, required this.isChecked});
  final String task;
  bool isChecked = false;
}