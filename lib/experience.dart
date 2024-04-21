import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "main.dart";
import 'dart:convert';

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

  void saveXP(int tileIndex) {
    List<String> xps = [];
    for (Experience xp in xpList[tileIndex]) {
      xps.add(xp.toJsonString());
    }
    prefs.setStringList('$tileIndex', xps);
  }
}

//ignore: must_be_immutable
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
  DateTime updateTime = DateTime.now();

// Convert an Experience object into a JSON string
  String toJsonString() {
    String? base64String;
    late Uint8List bytes;

    if (_image != null) {
      _image!.readAsBytes().then((value) => bytes = value);
      base64String = base64.encode(bytes);
    }

    final Map<String, dynamic> data = {
      'title': title,
      'tileIndex': tileIndex,
      'xpID': xpID,
      'name': name,
      'date': date,
      'description': description,
      'score': score,
      'grade': grade,
      'role': role,
      'hours': hours,
      'award': award,
      'location': location,
      'editable': editable,
      'image': base64String,
      'updateTime' : updateTime.toIso8601String(),
    };
    return jsonEncode(data);
  }

  // Create an Experience object from a JSON string
  static Experience fromJsonString(String jsonString) {
    Map<String, dynamic> json = jsonDecode(jsonString);
    Experience exp = Experience(
      title: json['title'],
      xpID: json['xpID'],
      tileIndex: json['tileIndex'],
    );
    exp.name = json['name'];
    exp.date = json['date'];
    exp.description = json['description'];
    exp.score = json['score'];
    exp.grade = json['grade'];
    exp.role = json['role'];
    exp.hours = json['hours'];
    exp.award = json['award'];
    exp.location = json['location'];
    exp.editable = json['editable'] as bool;
    exp.updateTime = DateTime.parse(json['updateTime']);

    if (json['image'] != null) {
      Uint8List bytes = base64.decode(json['image']);
      exp._image = File.fromRawPath(bytes);
    }

    exp._image = json['image'];
    return exp;
  }

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
                            widget.updateTime = DateTime.now();
                            context
                                .read<MyExperiences>()
                                .saveXP(widget.tileIndex);
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
