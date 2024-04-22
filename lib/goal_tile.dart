import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';
import 'package:provider/provider.dart';

class GoalTile extends StatelessWidget {
  final String title;

  const GoalTile(
      {super.key,
      required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<MyGoals>(
      builder: (context, taskManager, _) {
        double progressValue = Provider.of<MyGoals>(context, listen: false).calculateProgress();

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