import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class MyExperiences extends ChangeNotifier {
  List<List<Widget>> xpList = [[], [], [], [], [], [], [], []];

  void add(Experience xp, int index) {
    xpList[index].add(xp);
    notifyListeners();
  }
}

class Experience extends StatefulWidget {
  const Experience({
    super.key,
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
  String hours = "10";
  String award = "Woodinville High School";
  String location = "Hopelink";
  bool editable = false;
  File? _image;

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

      //TODO: Clean up this code, probably decomposing
      Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          title: widget.title != "Community Service"
              ? !editable
                  ? Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : TextFormField(
                      initialValue: name,
                      onFieldSubmitted: (value) {
                        setState(() {
                          editable = false;
                          name = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "ex. FBLA",
                        labelText: "Name",
                      ),
                    )
              : !editable
                  ? Text(
                      location,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : TextFormField(
                      initialValue: location,
                      onFieldSubmitted: (value) {
                        setState(() {
                          editable = false;
                          location = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "ex. Hopelink",
                        labelText: "Location",
                      ),
                    ),
          subtitle: Column(
            children: [
              !editable
                  ? Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : InputDatePickerFormField(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2025),
                      errorInvalidText: "invalid date",
                      fieldLabelText: "start date",
                    ),
              !editable
                  ? Text(
                      date,
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : InputDatePickerFormField(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2025),
                      errorInvalidText: "invalid date",
                      fieldLabelText: "end date",
                    ),
              if (widget.title == "Clubs/Organizations")
                !editable
                    ? Text(
                        role,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: role,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            role = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. President",
                          labelText: "Role",
                        ),
                      ),
              if (widget.title == "Awards")
                !editable
                    ? Text(
                        award,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: award,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            award = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. Woodinville High School",
                          labelText: "Issuer",
                        ),
                      ),
              if (widget.title != "Tests" && widget.title != "Honors Classes")
                !editable
                    ? Text(
                        description,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: description,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            description = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. In this I...",
                          labelText: "Description",
                        ),
                      ),
              if (widget.title == "Community Service")
                !editable
                    ? Text(
                        hours,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: hours,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            hours = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. 10",
                          labelText: "Hours",
                        ),
                      ),
              if (widget.title == "Tests")
                !editable
                    ? Text(
                        score,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: score,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            score = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. In this I...",
                          labelText: "Description",
                        ),
                      ),
              if (widget.title == "Honors Classes")
                !editable
                    ? Text(
                        grade,
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: grade,
                        onFieldSubmitted: (value) {
                          setState(() {
                            editable = false;
                            grade = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. A",
                          labelText: "Grade",
                        ),
                      ),
              !editable
                ? _image == null ? Text("No files selected") : Image.file(_image!)
                : Column(
                  children: [
                    SizedBox(
                      width: 50,
                      child: FloatingActionButton(
                        onPressed: () => getImage(ImageSource.gallery),
                        tooltip: 'Pick Image',
                        child: const Icon(Icons.add_a_photo),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: FloatingActionButton(
                         onPressed: () => getImage(ImageSource.camera),
                         tooltip: 'Capture Image',
                         child: const Icon(Icons.camera),
                      ),
                    ),
                  ],
                )
            ],
          ),
          trailing: TextButton(
              child: Icon(
                (!editable) ? Icons.edit : Icons.check,
                color: Colors.black,
                size: 20,
              ),
              onPressed: () {
                !editable
                    ? setState(() {
                        editable = true;
                      })
                    : setState(() {
                        editable = false;
                      });
              }),
        ),
      ),
    ]);
  }
  Future getImage(ImageSource source) async {
    final image = await ImagePicker().pickImage(
      source: source,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (image == null){
      return;
    }
    setState((){
      _image = File(image.path);
      
    });
  }
}
