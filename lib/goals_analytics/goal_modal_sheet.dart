import 'package:flutter/material.dart';
import 'goal_tile.dart';
import 'package:provider/provider.dart';

//this is a provider class to manage changes in goals
class MyGoals extends ChangeNotifier {
  List<GoalTile> goals = [];
  int totalCompletedTasks = 0;
  String done = "0";

  List<String> items = [
    "Athletics",
    "Performing Arts",
    "Community Service",
    "Awards",
    "Honors Classes",
    "Clubs/Organizations",
    "Projects",
    "Tests",
    "Other"
  ];
  List<double> numberOfItems = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  double sum = 0.0;

  //this method takes a title and adds a new goal tile to the list
  void add(String title) {
    goals.add(GoalTile(title: title));
    notifyListeners();
  }

  //this method takes a title and removes that goal tile from the list
  void remove(String title) {
    goals.remove(goals.firstWhere((goal) => goal.title == title));
    notifyListeners();
  }

  //this method takes a title and calculates how much progress that goal has made
  //progress is defined by completed/total
  double calculateProgress(title) {
    if (goals.firstWhere((goal) => goal.title == title).totalTasks == 0) {
      return 0.0;
    }
    return goals.firstWhere((goal) => goal.title == title).completedTasks /
        goals.firstWhere((goal) => goal.title == title).totalTasks;
  }

  //this method takes a title and adds to the total number of tasks
  void addTotalTasks(title) {
    goals.firstWhere((goal) => goal.title == title).totalTasks++;
    notifyListeners();
  }

  //this method takes a title and addes to the completed tasks
  void addCompletedTasks(title) {
    goals.firstWhere((goal) => goal.title == title).completedTasks++;
    totalCompletedTasks++;
    done = totalCompletedTasks.toString();
    notifyListeners();
  }

  //this method updates the number of items of the new category
  void updatePiChart() {
    for (int i = 0; i < goals.length; i++) {
      if (goals[i].getCategory() == items[0]) {
        numberOfItems[0]++;
      } else if (goals[i].getCategory() == items[1]) {
        numberOfItems[1]++;
      } else if (goals[i].getCategory() == items[2]) {
        numberOfItems[2]++;
      } else if (goals[i].getCategory() == items[3]) {
        numberOfItems[3]++;
      } else if (goals[i].getCategory() == items[4]) {
        numberOfItems[4]++;
      } else if (goals[i].getCategory() == items[5]) {
        numberOfItems[5]++;
      } else if (goals[i].getCategory() == items[6]) {
        numberOfItems[6]++;
      } else if (goals[i].getCategory() == items[7]) {
        numberOfItems[7]++;
      } else {
        numberOfItems[8]++;
      }
    }
    notifyListeners();
  }
}

//this class builds the modal sheet for each goal and requires a title
class GoalModalSheet extends StatefulWidget {
  const GoalModalSheet({
    super.key,
    required this.title,
  });
  final String title;

  @override
  GoalModalSheetState createState() => GoalModalSheetState();
}

class GoalModalSheetState extends State<GoalModalSheet> {
  bool editable = true;
  List<String> items = [
    "Athletics",
    "Performing Arts",
    "Community Service",
    "Awards",
    "Honors Classes",
    "Clubs/Organizations",
    "Projects",
    "Tests",
    "Other"
  ];
  TextEditingController taskController = TextEditingController();

  //this method takes a value and context and adds a task to the goal
  void _addTaskAndUpdateList(String value, BuildContext context) {
    Provider.of<MyGoals>(context, listen: false)
        .goals
        .firstWhere((goal) => goal.title == widget.title)
        .addTask(value, context);
    taskController.clear();
    FocusScope.of(context).unfocus();
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
                  Text(widget.title,
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  //this button puts the data in edit mode
                  TextButton(
                    onPressed: () {
                      !editable
                          ? setState(() {
                              editable = true;
                            })
                          : setState(() {
                              editable = false;
                            });
                    },
                    child: Icon(
                      (!editable) ? Icons.edit : Icons.check,
                      size: 20,
                    ),
                  ),
                  //this button closes the modal sheet
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
              //catetory is a dropdown menu to pick from in edit mode
              !editable
                  ? buildRichText(
                      context,
                      "Category: ",
                      Provider.of<MyGoals>(context, listen: false)
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .getCategory(),
                      Theme.of(context).textTheme.bodyMedium)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category",
                            style: Theme.of(context).textTheme.bodyMedium),
                        DropdownButton<String>(
                          value: Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getCategory(),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) => setState(() {
                            Provider.of<MyGoals>(context, listen: false)
                                .goals
                                .firstWhere(
                                    (goal) => goal.title == widget.title)
                                .changeCategory(item);
                            Provider.of<MyGoals>(context, listen: false)
                                .updatePiChart();
                            Provider.of<MyGoals>(context, listen: false).sum =
                                1.0;
                          }),
                        ),
                      ],
                    ),
              //deadline of goal
              (!editable)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: buildRichText(
                          context,
                          "Deadline: ",
                          Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDate(),
                          Theme.of(context).textTheme.bodyMedium),
                    )
                  : (!editable)
                      ? buildRichText(
                          context,
                          "Deadline",
                          Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDate(),
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                        //has to have a value to continue
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller: TextEditingController(
                            text: Provider.of<MyGoals>(context, listen: false)
                                .goals
                                .firstWhere(
                                    (goal) => goal.title == widget.title)
                                .getDate(),
                          ),
                          readOnly: true, // Prevents manual editing
                          decoration: underlineInputDecoration(
                              context, "ex. 4/24/2024", "Deadline"),
                          //date picker
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 25)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                Provider.of<MyGoals>(context, listen: false)
                                    .goals
                                    .firstWhere(
                                        (goal) => goal.title == widget.title)
                                    .changeDate(formatDate(pickedDate
                                        .toString()
                                        .substring(0, 10)));
                              });
                            }
                          },
                        ),
              //description of goal
              (!editable)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: (Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDescription()
                              .isEmpty)
                          ? Text("No description",
                              style: Theme.of(context).textTheme.bodyMedium)
                          : buildRichText(
                              context,
                              "Description:\n",
                              Provider.of<MyGoals>(context, listen: false)
                                  .goals
                                  .firstWhere(
                                      (goal) => goal.title == widget.title)
                                  .getDescription(),
                              Theme.of(context).textTheme.bodyMedium),
                    )
                  : TextFormField(
                      style: Theme.of(context).textTheme.bodyMedium,
                      minLines: 1,
                      maxLines: 4,
                      initialValue: Provider.of<MyGoals>(context, listen: false)
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .getDescription(),
                      onChanged: (value) {
                        setState(
                          () => Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .changeDescription(value),
                        );
                      },
                      decoration: underlineInputDecoration(
                          context, "ex. In this I...", "Description"),
                    ),
              const SizedBox(height: 50),
              Text("Tasks", style: Theme.of(context).textTheme.headlineSmall),
              Divider(
                  color: Theme.of(context).colorScheme.secondary, thickness: 2),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 125,
                    //input field to add tasks
                    child: TextField(
                      controller: taskController,
                      decoration: const InputDecoration(
                        labelText: 'Enter Task',
                        hintText: 'ex. Complete draft of business report',
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black)),
                      ),
                      onSubmitted: (value) {
                        _addTaskAndUpdateList(value, context);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                    child: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: IconButton(
                        onPressed: () {
                          _addTaskAndUpdateList(taskController.text, context);
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //displays list of all the tasks with a checkbox
              Expanded(
                child: ListView.builder(
                  itemCount: Provider.of<MyGoals>(context, listen: false)
                      .goals
                      .firstWhere((goal) => goal.title == widget.title)
                      .tasks
                      .length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(Provider.of<MyGoals>(context, listen: false)
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .tasks[index]
                          .task),
                      value: Provider.of<MyGoals>(context, listen: false)
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .tasks[index]
                          .isChecked,
                      onChanged: (value) {
                        setState(() {
                          Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .tasks[index]
                              .isChecked = value!;
                            //goal removed when checked
                          Provider.of<MyGoals>(context, listen: false)
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .removeTask(index, context);
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

  //takes a date and formats it into month day year
  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }

  //ui style changes
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

//this class defines a task that requires a task name and if it is checked yet
class Task {
  Task({required this.task, required this.isChecked});
  final String task;
  bool isChecked = false;
}
