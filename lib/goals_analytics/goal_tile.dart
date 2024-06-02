import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'goal_modal_sheet.dart';

// This class defines a goal tile and requires a title
// ignore: must_be_immutable
class GoalTile extends StatelessWidget {
  final String title;
  String category = "Athletics";
  String date = "";
  String description = "";
  List<Task> tasks = [];
  int totalTasks = 0;
  int completedTasks = 0;
  bool emptyGoal = true;

  GoalTile({
    super.key,
    required this.title,
  });

  // This method adds a task to the list of tasks and takes the task and context
  void addTask(task, context) {
    tasks.add(Task(task: task, isChecked: false));
    context.read<MyGoals>().addTotalTasks(title);
    emptyGoal = false;
  }

  // This method removes a task from the list of tasks and takes the index and context
  void removeTask(int index, context) {
    tasks.removeAt(index);
    context.read<MyGoals>().addCompletedTasks(title);
  }

  // Category getter method
  String getCategory() {
    return category;
  }

  // This method takes a category and change the current one with the new one
  void changeCategory(category) {
    this.category = category;
  }

  // Date getter method
  String getDate() {
    return date;
  }

  // This method takes a date and change the current one with the new one
  void changeDate(date) {
    this.date = date;
  }

  // Description getter method
  String getDescription() {
    return description;
  }

  // This method takes a description and change the current one with the new one
  void changeDescription(description) {
    this.description = description;
  }

  // Tasks getter method
  List<Task> getTasks() {
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    // Calculates how much progress a user has made on a goal
    double progressValue = context.read<MyGoals>().calculateProgress(title);

    return Column(
      children: [
        ListTile(
          title: Row(
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineSmall),
              const Spacer(),
              // This button opens a modal sheet for each goal with its data
              IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return GoalModalSheet(title: title);
                      },
                    );
                  },
                  icon: const Icon(Icons.edit)),
              // This button removes the goal from the list
              IconButton(
                onPressed: () {
                  context.read<MyGoals>().remove(title);
                },
                icon: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
        // Creates a bar showing the progess of the goal
        LinearProgressIndicator(
          value: progressValue,
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}