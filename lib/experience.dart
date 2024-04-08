import 'package:flutter/material.dart';
//this is my silly lil change so i can commit again!!

class Experience extends StatefulWidget {
  const Experience(
      {super.key,
      required this.title,
      // required this.remove,
      // required this.index
      });
  // final void Function(int) remove;
  final String title;
  // final int index;

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  String name = "Name";
  String date = "4/6/24";
  String description = "In this I...";
  String score = "100";
  String grade = "A";
  String role = "President";
  bool editable = false;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(),
      ),
      // Row(
      //   children: [
      //     Text(widget.title),
      //     const Spacer(),
      //     TextButton(
      //       onPressed: () {
      //         widget.remove(widget.index);
      //       },
      //       child: const Icon(Icons.remove, size: 20),
      //     ),
      //   ],
      // ),
      Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ListTile(
              title: !editable ? Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)) : TextFormField(
                initialValue: name,
                onFieldSubmitted: (value) {
                  setState(() {editable = false; name = value;});
                },
                decoration: const InputDecoration(
                  hintText: "ex. FBLA",
                  labelText: "Name",
                ),
              ),
              subtitle: Column(
                children: [
                  !editable ? Text(date, style: const TextStyle(fontSize: 10.0)) : InputDatePickerFormField(
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(2025),
                                                errorInvalidText: "invalid date",
                                                fieldLabelText: "start date",
                                              ),
                  !editable ? Text(date, style: const TextStyle(fontSize: 10.0)) : InputDatePickerFormField(
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(2025),
                                            errorInvalidText: "invalid date",
                                            fieldLabelText: "end date",
                                          ),
                  if (widget.title == "Clubs/Organizations")
                                        !editable ? Text(role, style: const TextStyle(fontSize: 12,)) : TextFormField(
                                            initialValue: role,
                                            onFieldSubmitted: (value) {
                                              setState(() {editable = false; role = value;});
                                            },
                                            decoration: const InputDecoration(
                                              hintText: "President",
                                              labelText: "Role",
                                            ),
                                          ),
                    if (widget.title != "Tests" && widget.title != "Honors Classes") 
                    !editable ? Text(description, style: const TextStyle(fontSize: 12,)) : TextFormField(
                              initialValue: description,
                              onFieldSubmitted: (value) {
                                setState(() {editable = false; description = value;});
                              },
                              decoration: const InputDecoration(
                                hintText: "ex. In this I...",
                                labelText: "Description",
                              ),
                        ),
                    if (widget.title == "Tests") 
                    !editable ? Text(score, style: const TextStyle(fontSize: 12,)) : TextFormField(
                          initialValue: score,
                          onFieldSubmitted: (value) {
                            setState(() {editable = false; score = value;});
                          },
                          decoration: const InputDecoration(
                            hintText: "ex. In this I...",
                            labelText: "Description",
                          ),
                        ),
                    if (widget.title == "Honors Classes")
                    !editable ? Text(grade, style: const TextStyle(fontSize: 12,)) : TextFormField(
                          initialValue: grade,
                          onFieldSubmitted: (value) {
                            setState(() {editable = false; grade = value;});
                          },
                          decoration: const InputDecoration(
                            hintText: "A",
                            labelText: "Grade",
                          ),
                        ),
                ],
              ),
              trailing: TextButton(
                child: Icon( 
                  (!editable) ? Icons.edit : Icons.check,
                  color: Colors.black,
                  size: 20,
                ),
                onPressed: () {
                  !editable ? 
                  setState(() {editable = true;}) :
                  setState(() {editable = false;});
                }),  
            ),
          ),
        ]);
    }
}