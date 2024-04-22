
import 'package:flutter/material.dart';
import 'package:mobileapp/goal_modal_sheet.dart';

class GoalTile extends StatelessWidget {
  final String title;
  final double progressValue;

const GoalTile(
      {super.key,
      required this.title,
      required this.progressValue});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: LinearProgressIndicator(
        value: progressValue,
        backgroundColor: Colors.grey[200],
        valueColor: const AlwaysStoppedAnimation<Color>(Color.fromARGB(255, 77, 145, 214)),
      ),
      onTap: () {
        goalModalSheet(context, title, progressValue);
      },
    );
  }
}