import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class GoalTile extends StatelessWidget {
  final String title;
  String category = "Athletics";
  String date = "";
  String description = "";
  List<Task> tasks = [];
  int totalTasks = 0;
  int completedTasks = 0;

  GoalTile(
      {super.key,
      required this.title,
  });

  void addTask(task, context){
    tasks.add(Task(task: task, isChecked: false));
    Provider.of<MyGoals>(context, listen: false).addTotalTasks(title);
  }

  void removeTask(int index, context) {
      tasks.removeAt(index);
      Provider.of<MyGoals>(context, listen: false).addCompletedTasks(title);
  }

  String getCategory(){
    return category;
  }

  void changeCategory(category){
    this.category = category;
  }

  String getDate(){
    return date;
  }

  void changeDate(date){
    this.date = date;
  }

  String getDescription(){
    return description;
  }

  void changeDescription(description){
    this.description = description;
  }

 List<Task> getTasks(){
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MyGoals>(
      builder: (context, taskManager, _) {
        double progressValue = Provider.of<MyGoals>(context, listen: true).calculateProgress(title);

        return ListTile(
          title: Text(title),
          subtitle: LinearProgressIndicator(
            value: progressValue,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 77, 145, 214)),
          ),
          trailing: TextButton(
              onPressed: () {
                Provider.of<MyGoals>(context, listen: false).remove(title);
              },
              child: const Icon(Icons.remove, size: 20),
            ),
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return GoalModalSheet(title: title);
              },
            );
          },
        );
      }
    );
  }
}