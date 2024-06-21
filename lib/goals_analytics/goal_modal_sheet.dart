import 'package:flutter/material.dart';
import '../my_app_state.dart';
import '../theme.dart';
import 'package:provider/provider.dart';

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
    context.read<MyAppState>().addTotalTasks(widget.title, value);
    taskController.clear();
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> items = context.read<MyAppState>().items;

    return SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width - 15,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Text(widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall!
                          .copyWith(color: Theme.of(context).primaryColor)),
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
                          .read<MyAppState>()
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
                        DropdownButton<String>(
                          //style: theme.dropdownMenuTheme.textStyle,
                          value: context
                              .read<MyAppState>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .getCategory(),
                          items: items
                              .map((item) => DropdownMenuItem<String>(
                                  value: item, child: Text(item)))
                              .toList(),
                          onChanged: (item) => setState(() {
                            context
                                .read<MyAppState>()
                                .goals
                                .firstWhere(
                                    (goal) => goal.title == widget.title)
                                .changeCategory(item);
                            context.read<MyAppState>().updatePieChart();
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
                              .read<MyAppState>()
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
                              .read<MyAppState>()
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
                                .read<MyAppState>()
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
                                    .read<MyAppState>()
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
                              .read<MyAppState>()
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
                                  .read<MyAppState>()
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
                          .read<MyAppState>()
                          .goals
                          .firstWhere((goal) => goal.title == widget.title)
                          .getDescription(),
                      onChanged: (value) {
                        setState(
                          () => context
                              .read<MyAppState>()
                              .goals
                              .firstWhere((goal) => goal.title == widget.title)
                              .changeDescription(value),
                        );
                      },
                      decoration: underlineInputDecoration(
                          context, "ex. In this I...", "Description"),
                    ),
              const SizedBox(height: 50),
              Text("Tasks",
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(color: Theme.of(context).primaryColor)),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 150,
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
                    padding: const EdgeInsets.fromLTRB(10, 15, 0, 0),
                    child: CircleAvatar(
                      maxRadius: 17.5,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      child: IconButton(
                        onPressed: () {
                          _addTaskAndUpdateList(taskController.text, context);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.background,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              // This displays list of all the tasks with a checkbox
              Expanded(
                child: Consumer<MyAppState>(
                  builder: (context, myAppState, _) {
                    final goal = myAppState.goals
                        .firstWhere((goal) => goal.title == widget.title);
                    final tasks = goal.tasks;

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return CheckboxListTile(
                            title: Text(task.task),
                            value: task.isChecked,
                            onChanged: (value) {
                              setState(() {
                                task.isChecked = value!;
                                if (value) {
                                  myAppState.addCompletedTasks(widget.title);
                                } else {
                                  myAppState.unCheck(widget.title);
                                }
                              });
                            },
                            secondary: IconButton(
                                icon:
                                    const Icon(Icons.cancel, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    myAppState.deleteTask(widget.title, index);
                                  });
                                }));
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
