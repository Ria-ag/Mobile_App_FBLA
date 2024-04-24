import 'package:flutter/material.dart';
import 'goal_modal_sheet.dart';
import 'package:provider/provider.dart';

//this class defines a goal tile and requires a title
// ignore: must_be_immutable
class GoalTile extends StatelessWidget {
  final String title;
  String category = "Athletics";
  String date = "";
  String description = "";
  List<Task> tasks = [];
  int totalTasks = 0;
  int completedTasks = 0;

  GoalTile({
    super.key,
    required this.title,
  });

  //this method adds a task to the list of tasks and takes the task and context
  void addTask(task, context) {
    tasks.add(Task(task: task, isChecked: false));
    Provider.of<MyGoals>(context, listen: false).addTotalTasks(title);
  }

  //this method removes a task from the list of tasks and takes the index and context
  void removeTask(int index, context) {
    tasks.removeAt(index);
    Provider.of<MyGoals>(context, listen: false).addCompletedTasks(title);
  }

  //category getter method
  String getCategory() {
    return category;
  }

  //this method takes a category and change the current one with the new one
  void changeCategory(category) {
    this.category = category;
  }

  //date getter method
  String getDate() {
    return date;
  }

  //this method takes a date and change the current one with the new one
  void changeDate(date) {
    this.date = date;
  }

  //description getter method
  String getDescription() {
    return description;
  }

  //this method takes a description and change the current one with the new one
  void changeDescription(description) {
    this.description = description;
  }

  //tasks getter method
  List<Task> getTasks() {
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyGoals>(
      builder: (context, taskManager, _) {
        //calculates how much progress a user has made on a goal
        double progressValue = Provider.of<MyGoals>(context, listen: true)
            .calculateProgress(title);

        return Column(
          children: [
            ListTile(
              title: Row(
                children: [
                  Text(title, style: Theme.of(context).textTheme.headlineSmall),
                  const Spacer(),
                  //this button opens a modal sheet for each goal with its data
                  TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return GoalModalSheet(title: title);
                          },
                        );
                      },
                      child: const Icon(Icons.edit)),
                  //this button removes the goal from the list
                  TextButton(
                    onPressed: () {
                      Provider.of<MyGoals>(context, listen: false)
                          .remove(title);
                    },
                    child: const Icon(Icons.remove),
                  ),
                ],
              ),
            ),
            //creates a bar showing the progess of the goal
            LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color.fromARGB(255, 77, 145, 214)),
            ),
          ],
        );
      },
    );
  }
}
