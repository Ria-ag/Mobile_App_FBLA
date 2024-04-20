import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import "main.dart";
import 'dart:convert';
import 'package:intl/intl.dart';

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
  String startDate = "";
  String endDate = "";
  String description = "";
  String score = "";
  String grade = "";
  String role = "";
  String hours = "";
  String award = "";
  String location = "";
  bool editable = true;
  File? _image;
  final _formKey = GlobalKey<FormState>();

// Convert an Experience object into a JSON string
  String toJsonString() {
    final Map<String, dynamic> data = {
      'title': title,
      'tileIndex': tileIndex,
      'xpID': xpID,
      'name': name,
      'startDate': startDate,
      'endDate': endDate,
      'description': description,
      'score': score,
      'grade': grade,
      'role': role,
      'hours': hours,
      'award': award,
      'location': location,
      'editable': editable,
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
    exp.startDate = json['startDate'];
    exp.endDate = json['endDate'];
    exp.description = json['description'];
    exp.score = json['score'];
    exp.grade = json['grade'];
    exp.role = json['role'];
    exp.hours = json['hours'];
    exp.award = json['award'];
    exp.location = json['location'];
    exp.editable = json['editable'] as bool;
    return exp;
  }

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  //TODO: Change tips
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
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
        child: Form(
          key: widget._formKey,
          child: ListTile(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.title != "Community Service")
                  (!widget.editable)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        )
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          initialValue: widget.name,
                          onChanged: (value) {
                            setState(() {
                              widget.name = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. FBLA", "Name"),
                        )
                else
                  (!widget.editable)
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Community Service at ${widget.location}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15),
                            ),
                            Divider(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ],
                        )
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          initialValue: widget.location,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.location = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. Hopelink", "Location"),
                        ),
                (!widget.editable)
                    ? buildRichText(context, "Start Date: ", widget.startDate,
                        Theme.of(context).textTheme.bodyMedium)
                    : TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Field cannot be empty";
                          } else if (widget.endDate.isNotEmpty) {
                            DateTime endDate =
                                DateFormat("MM/dd/yyyy").parse(widget.endDate);
                            DateTime startDate =
                                DateFormat("MM/dd/yyyy").parse(value);
                            if (startDate.compareTo(endDate) > 0) {
                              return "Start date should be before end date";
                            }
                          }
                          return null;
                        },
                        style: Theme.of(context).textTheme.bodyMedium,
                        controller:
                            TextEditingController(text: widget.startDate),
                        readOnly: true, // Prevents manual editing
                        decoration: underlineInputDecoration(
                            context, "ex. 4/24/2024", "Start Date"),
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365 * 25)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              widget.startDate = formatDate(
                                  pickedDate.toString().substring(0, 10));
                            });
                          }
                        },
                      ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 7.5),
                  child: (!widget.editable)
                      ? buildRichText(context, "End Date: ", widget.endDate,
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          style: Theme.of(context).textTheme.bodyMedium,
                          controller:
                              TextEditingController(text: widget.endDate),
                          readOnly: true,
                          decoration: underlineInputDecoration(
                              context, "ex. 4/27/2024", "End Date"),
                          onTap: () async {
                            final pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now()
                                  .subtract(const Duration(days: 365 * 25)),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                            );
                            if (pickedDate != null) {
                              setState(() {
                                widget.endDate = formatDate(
                                    pickedDate.toString().substring(0, 10));
                              });
                            }
                          },
                        ),
                ),
                const SizedBox(width: 10),
                if (widget.title == "Clubs/Organizations")
                  (!widget.editable)
                      ? buildRichText(context, "Role: ", widget.role,
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          initialValue: widget.role,
                          onChanged: (value) {
                            setState(() {
                              widget.role = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. President", "Role"),
                        ),
                if (widget.title == "Awards")
                  (!widget.editable)
                      ? (widget.award.isEmpty)
                          ? Text("No issuer",
                              style: Theme.of(context).textTheme.bodyMedium)
                          : buildRichText(context, "Issuer: ", widget.award,
                              Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          initialValue: widget.award,
                          onChanged: (value) {
                            setState(() {
                              widget.award = value;
                            });
                          },
                          decoration: underlineInputDecoration(context,
                              "ex. Woodinville High School", "Issuer")),
                if (widget.title == "Community Service")
                  (!widget.editable)
                      ? buildRichText(context, "Hours: ", widget.hours,
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          initialValue: widget.hours,
                          onChanged: (value) {
                            setState(() {
                              widget.hours = value;
                              widget._formKey.currentState!.validate();
                            });
                          },
                          decoration: underlineInputDecoration(
                            context,
                            "ex. 10",
                            "Hours",
                          ),
                          validator: (value) {
                            if (value != null) {
                              final double? numVal = double.tryParse(value);
                              if (numVal == null || numVal <= 0) {
                                return "Enter a positive number";
                              }
                            } else if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                        ),
                if (widget.title == "Tests")
                  (!widget.editable)
                      ? buildRichText(context, "Score: ", widget.score,
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value != null) {
                              final double? numVal = double.tryParse(value);
                              if (numVal == null || numVal < 0) {
                                return "Enter a non-negative number";
                              }
                            } else if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          initialValue: widget.score,
                          onChanged: (value) {
                            setState(() {
                              widget.score = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. 1320", "Score"),
                        ),
                if (widget.title == "Honors Classes")
                  (!widget.editable)
                      ? buildRichText(context, "Grade: ", widget.grade,
                          Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field cannot be empty";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            setState(() {
                              widget.grade = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. A", "Grade"),
                        ),
                if (widget.title != "Tests" && widget.title != "Honors Classes")
                  (!widget.editable)
                      ? (widget.description.isEmpty)
                          ? Text("No description",
                              style: Theme.of(context).textTheme.bodyMedium)
                          : buildRichText(
                              context,
                              "Description:\n",
                              widget.description,
                              Theme.of(context).textTheme.bodyMedium)
                      : TextFormField(
                          style: Theme.of(context).textTheme.bodyMedium,
                          minLines: 1,
                          maxLines: 4,
                          initialValue: widget.description,
                          onChanged: (value) {
                            setState(() {
                              widget.description = value;
                            });
                          },
                          decoration: underlineInputDecoration(
                              context, "ex. In this I...", "Description"),
                        ),
                (!widget.editable)
                    ? widget._image == null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 7.5),
                            child: Text("No images selected",
                                style: Theme.of(context).textTheme.bodyMedium),
                          )
                        : Image.file(widget._image!)
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            const Text("Add image:"),
                            const SizedBox(width: 10),
                            SizedBox(
                              width: 50,
                              child: FloatingActionButton(
                                onPressed: () => getImage(ImageSource.gallery),
                                tooltip: 'Pick Image',
                                child: const Icon(Icons.add_a_photo),
                              ),
                            ),
                            const SizedBox(width: 10),
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
                      ),
              ],
            ),
            trailing: SizedBox(
              width: 175,
              height: 175,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: (!widget.editable)
                        ? () => setState(() {
                              widget.editable = true;
                            })
                        : () {
                            final formState = widget._formKey.currentState;
                            if (formState == null) return;

                            bool hasErrors = false;
                            formState.save();

                            setState(() {
                              hasErrors = !formState.validate();
                              if (!hasErrors) {
                                widget.editable = false;
                                context
                                    .read<MyExperiences>()
                                    .saveXP(widget.tileIndex);
                              }
                            });
                          },
                    child: Icon(
                      (!widget.editable) ? Icons.edit : Icons.check,
                      size: 20,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context
                          .read<MyExperiences>()
                          .remove(widget.xpID, widget.tileIndex);
                      context.read<MyExperiences>().saveXP(widget.tileIndex);
                    },
                    child: const Icon(Icons.remove, size: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration underlineInputDecoration(
      BuildContext context, String hint, String label,
      {String? errorText}) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
      // enabledBorder: const UnderlineInputBorder(
      //     borderSide: BorderSide(color: Colors.blueGrey)),
      //labelStyle: TextStyle(color: Colors.blueGrey, fontSize: 13),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
      floatingLabelStyle:
          MaterialStateTextStyle.resolveWith((Set<MaterialState> states) {
        final Color color = states.contains(MaterialState.focused)
            ? (states.contains(MaterialState.error)
                ? Colors.red
                : Theme.of(context).colorScheme.secondary)
            : Colors.black;
        return TextStyle(color: color);
      }),
    );
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

  Widget buildRichText(
      BuildContext context, String label, String value, TextStyle? style) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: style?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: style,
          ),
        ],
      ),
    );
  }

  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }
}
