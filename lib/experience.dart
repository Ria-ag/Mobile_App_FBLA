import 'package:flutter/material.dart';

class Experience extends StatelessWidget {
  const Experience(
      {super.key,
      required this.title,
      required this.remove,
      required this.index});
  final void Function(int) remove;
  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(),
      ),
      Row(
        children: [
          Text(title),
          const Spacer(),
          TextButton(
            onPressed: () {
              remove(index);
            },
            child: const Icon(Icons.remove, size: 20),
          ),
        ],
      ),
    ]);
  }
}
