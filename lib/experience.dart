import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MyExperiences extends ChangeNotifier {
  List<List<Experience>> xpList = [[], [], [], [], [], [], [], []];

  void add(String title, int tileIndex) {
    xpList[tileIndex].add(Experience(
        title: title, xpID: xpList[tileIndex].length, tileIndex: tileIndex));
    notifyListeners();
  }

  void remove(int id, int tileIndex) {
    xpList[tileIndex]
        .remove(xpList[tileIndex].firstWhere((xp) => xp.xpID == id));
    notifyListeners();
  }
}

class Experience extends StatefulWidget {
  Experience(
      {super.key,
      required this.title,
      required this.xpID,
      required this.tileIndex});
  final String title;
  final int tileIndex;
  int xpID;

  String name = "";
  String date = "";
  String description = "";
  String score = "";
  String grade = "";
  String role = "";
  String hours = "";
  String award = "";
  String location = "";
  bool editable = false;
  File? _image;

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  //TODO: Change tips
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Divider(),
      ),

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.title != "Community Service"
                  ? !widget.editable
                      ? Text(
                          "Name: ${widget.name}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : TextFormField(
                          initialValue: widget.name,
                          onTapOutside: (tap) {
                            widget.editable = false;
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.name = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "ex. FBLA",
                            labelText: "Name",
                          ),
                        )
                  : !widget.editable
                      ? Text(
                          "Location: ${widget.location}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : TextFormField(
                          initialValue: widget.location,
                          onTapOutside: (tap) {
                            widget.editable = false;
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.location = value;
                            });
                          },
                          decoration: const InputDecoration(
                            hintText: "ex. Hopelink",
                            labelText: "Location",
                          ),
                        ),
              !widget.editable
                  ? Text(
                      "Start Date: ${widget.date}",
                      style: Theme.of(context).textTheme.bodyMedium,
                    )
                  : InputDatePickerFormField(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2025),
                      errorInvalidText: "invalid date",
                      fieldLabelText: "start date",
                    ),
              !widget.editable
                  ? Text(
                      "End Date: ${widget.date}",
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
                !widget.editable
                    ? Text(
                        "Role: ${widget.role}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.role,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.role = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. President",
                          labelText: "Role",
                        ),
                      ),
              if (widget.title == "Awards")
                !widget.editable
                    ? Text(
                        "Award: ${widget.award}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.award,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.award = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. Woodinville High School",
                          labelText: "Issuer",
                        ),
                      ),
              if (widget.title != "Tests" && widget.title != "Honors Classes")
                !widget.editable
                    ? Text(
                        "Description: ${widget.description}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.description,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.description = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. In this I...",
                          labelText: "Description",
                        ),
                      ),
              if (widget.title == "Community Service")
                !widget.editable
                    ? Text(
                        "Hours: ${widget.hours}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.hours,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.hours = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. 10",
                          labelText: "Hours",
                        ),
                      ),
              if (widget.title == "Tests")
                !widget.editable
                    ? Text(
                        "Score: ${widget.score}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.score,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.score = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. In this I...",
                          labelText: "Description",
                        ),
                      ),
              if (widget.title == "Honors Classes")
                !widget.editable
                    ? Text(
                        "Grade: ${widget.grade}",
                        style: Theme.of(context).textTheme.bodyMedium,
                      )
                    : TextFormField(
                        initialValue: widget.grade,
                        onTapOutside: (tap) {
                          widget.editable = false;
                        },
                        onChanged: (value) {
                          setState(() {
                            widget.grade = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: "ex. A",
                          labelText: "Grade",
                        ),
                      ),
              !widget.editable
                  ? widget._image == null
                      ? Text("No files selected",
                          style: Theme.of(context).textTheme.bodyMedium)
                      : Image.file(widget._image!)
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
                    ),
            ],
          ),
          trailing: SizedBox(
            width: 120,
            height: 200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: Icon(
                    (!widget.editable) ? Icons.edit : Icons.check,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    !widget.editable
                        ? setState(() {
                            widget.editable = true;
                          })
                        : setState(() {
                            widget.editable = false;
                          });
                  },
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<MyExperiences>()
                        .remove(widget.xpID, widget.tileIndex);
                  },
                  child: const Icon(Icons.remove, size: 20),
                ),
              ],
            ),
          ),
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
    if (image == null) {
      return;
    }
    setState(() {
      widget._image = File(image.path);
    });
  }
}
