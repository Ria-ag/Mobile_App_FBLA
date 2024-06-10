import 'package:flutter/material.dart';
import '../theme.dart';
import 'goal_tile.dart';
import 'package:provider/provider.dart';

// This is a provider class to manage changes in goals
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

  GoalTile findGoal(String title) {
    return goals.firstWhere((goal) => goal.title == title);
  }

  // This method takes a title and adds a new goal tile to the list
  void add(String title) {
    goals.add(GoalTile(title: title));
    notifyListeners();
  }

  // This method takes a title and removes that goal tile from the list
  void remove(String title) {
    goals.remove(findGoal(title));
    notifyListeners();
  }

  // This method takes a title and calculates how much progress that goal has made
  // Progress is defined by completed/total
  double calculateProgress(title) {
    if (findGoal(title).totalTasks == 0) {
      return 0.0;
    }
    return findGoal(title).completedTasks / findGoal(title).totalTasks;
  }

  // This method takes a title and adds to the total number of tasks
  void addTotalTasks(title) {
    findGoal(title).totalTasks++;
    notifyListeners();
  }

  // This method takes a title and addes to the completed tasks
  void addCompletedTasks(title) {
    findGoal(title).completedTasks++;
    totalCompletedTasks++;
    done = totalCompletedTasks.toString();
    notifyListeners();
  }

  // This method updates the number of items of the new category
  void updatePieChart() {
    Map<String, int> categoryIndexMap = {
      for (int i = 0; i < items.length; i++) items[i]: i
    };

    for (final goal in goals) {
      int index = categoryIndexMap[goal.getCategory()] ?? 8;
      numberOfItems[index]++;
    }

    notifyListeners();
  }
}

// This class builds the modal sheet for each goal and requires a title
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
  TextEditingController taskController = TextEditingController();

  // This method takes a value and context and adds a task to the goal
  void _addTaskAndUpdateList(String value, BuildContext context) {
    context
        .read<MyGoals>()
        .goals
        .firstWhere((goal) => goal.title == widget.title)
        .addTask(value, context);
    taskController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = context.read<MyGoals>().items;

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width - 15,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(widget.title,
                      style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).primaryColor)),
                  const Spacer(),
                  // This button makes the data editable
                  IconButton(
                    onPressed: () {
                      !editable
                          ? setState(() {
                              editable = true;
                            })
                          : setState(() {
                              editable = false;
                            });
                    },
                    icon: Icon(
                      (!editable) ? Icons.edit : Icons.check,
                      size: 20,
                    ),
                  ),
                  // This button closes the modal sheet
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
              // Users can pick a category using a dropdown menu
              !editable
                  ? buildRichText(
                      context,
                      "Category: ",
                      context
                          .read<MyGoals>()
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .getCategory(),
                      Theme.of(context).textTheme.bodyMedium)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        Text("Category",
                            style: Theme.of(context).textTheme.bodySmall),
                        const SizedBox(height: 10),
                        Text("Category", style: Theme.of(context).textTheme.bodySmall),
                        DropdownButton<String>(
                          style: theme.dropdownMenuTheme.textStyle,
                          value: context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getCategory(),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) => setState(() {
                            context
                                .read<MyGoals>()
                                .goals
                                .firstWhere(
                                    (goal) => goal.title == widget.title)
                                .changeCategory(item);
                            context.read<MyGoals>().updatePieChart();
                            context.read<MyGoals>().sum = 1.0;
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
                          context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDate(),
                          Theme.of(context).textTheme.bodyMedium),
                    )
                  : (!editable)
                      ? buildRichText(
                          context,
                          "Deadline",
                          context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDate(),
                          Theme.of(context).textTheme.bodySmall)
                      : TextFormField(
                          //has to have a value to continue
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodySmall,
                          controller: TextEditingController(
                            text: context
                                .read<MyGoals>()
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
                                context
                                    .read<MyGoals>()
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
              // The description of goal
              (!editable)
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: (context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getDescription()
                              .isEmpty)
                          ? Text("No description",
                              style: Theme.of(context).textTheme.bodyMedium)
                          : buildRichText(
                              context,
                              "Description:\n",
                              context
                                  .read<MyGoals>()
                                  .goals
                                  .firstWhere(
                                      (goal) => goal.title == widget.title)
                                  .getDescription(),
                              Theme.of(context).textTheme.bodyMedium),
                    )
                  : TextFormField(
                      style: Theme.of(context).textTheme.bodySmall,
                      minLines: 1,
                      maxLines: 4,
                      initialValue: context
                          .read<MyGoals>()
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .getDescription(),
                      onChanged: (value) {
                        setState(
                          () => context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .changeDescription(value),
                        );
                      },
                      decoration: underlineInputDecoration(
                          context, "ex. In this I...", "Description"),
                    ),
              const SizedBox(height: 50),
              Text("Tasks", style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Theme.of(context).primaryColor)),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 125,
                    // Input field to add tasks
                    child: TextField(
                      controller: taskController,
                      decoration: underlineInputDecoration(
                        alwaysFloat: false,
                        context,
                        'ex. Complete draft of business report',
                        'Enter Task',
                      ),
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
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // This displays list of all the tasks with a checkbox
              Expanded(
                child: ListView.builder(
                  itemCount: context
                      .read<MyGoals>()
                      .goals
                      .firstWhere((goal) => goal.title == widget.title)
                      .tasks
                      .length,
                  itemBuilder: (context, index) {
                    return CheckboxListTile(
                      title: Text(context
                          .read<MyGoals>()
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .tasks[index]
                          .task),
                      value: context
                          .read<MyGoals>()
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .tasks[index]
                          .isChecked,
                      onChanged: (value) {
                        setState(() {
                          context
                              .read<MyGoals>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .tasks[index]
                              .isChecked = value!;
                          // Goal removed when checked
                          context
                              .read<MyGoals>()
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

  // Takes a date and formats it into month day year
  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }
}

// This class defines a task that requires a task name and if it is checked yet
class Task {
  Task({required this.task, required this.isChecked});
  final String task;
  bool isChecked = false;
}