import 'package:flutter/material.dart';

Future<void> goalModalSheet(BuildContext context, title, progressValue) {
  bool editable = false;
  String category = "";
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.grey[200],
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height - 50,
        width: MediaQuery.of(context).size.width - 15,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(title),
                  const Spacer(),
                  TextButton(
                    onPressed: () => (!editable)
                    ? editable = true
                    : editable = false,
                    child: Icon(
                      (!editable) ? Icons.edit : Icons.check,
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
              const Text("Category:"),
              !editable
              ? Text(category)
              : DropdownButton<String>(
                value: category,
                onChanged: (newValue) {
                  category = newValue!;
                },
                items: <String>["Athletics", "Performing Arts", "Community Service", "Awards"
                "Honors Classes", "Clubs/Organizations", "Projects", "Tests"].map<DropdownMenuItem<String>>
                ((String value) {return DropdownMenuItem<String>(value: value, child: Text(value),);}).toList(),
              ),
              const Text("Deadline:"),
              const Text("Description:"),
              const Text("Tasks"),
            ],
          ),
        ),
      );
    }
  );
}