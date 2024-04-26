import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import "package:mobileapp/main.dart";
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

//this is a provider class to manage changes in experiences
class MyExperiences extends ChangeNotifier {
  //experiences are stored in a list which is stored in a list of each list of experiences per tile type
  List<List<Experience>> xpList = [[], [], [], [], [], [], [], []];
  double serviceHrs = 0;

  //this method adds an experience to the list and takes the title and type of tile
  void add(String title, int tileIndex) {
    xpList[tileIndex].add(Experience(
        title: title,
        xpID: DateTime.now().microsecondsSinceEpoch,
        tileIndex: tileIndex));
    notifyListeners();
  }

  //this method removes experiences from the list and takes the id and type of tile
  void remove(int id, int tileIndex) {
    xpList[tileIndex]
        .remove(xpList[tileIndex].firstWhere((xp) => xp.xpID == id));
    notifyListeners();
  }

  //this method saves every experience in the list to the shared preferences as a json string
  void saveXP(int tileIndex) async {
    List<String> xps = [];
    for (Experience xp in xpList[tileIndex]) {
      xps.add(xp.toJsonString());
    }
    if (tileIndex == 2) {
      addHrs();
    }
    notifyListeners();
    await prefs.setStringList('$tileIndex', xps);
  }

  //this method adds up all the hours of each experience in the community service tile
  void addHrs() {
    double totalHrs = 0;
    for (Experience xp in xpList[2]) {
      totalHrs += double.parse(xp.hours);
    }
    serviceHrs = totalHrs;
  }
}

//this class defines an experience and requires a title, id, and type of tile
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
  String imagePath = "";
  bool editable = true;
  File? _image;
  DateTime updateTime = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  //convert an Experience object into a JSON string
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
      'updateTime': updateTime.toIso8601String(),
      'image': imagePath,
    };
    return jsonEncode(data);
  }

  ///create an Experience object from a JSON string
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
    exp.imagePath = json['image'] ?? "";
    exp.editable = json['editable'] as bool;
    exp.updateTime = DateTime.tryParse(json['updateTime']) ?? DateTime.now();

    exp._image =
        (exp.imagePath.isEmpty) ? null : File(prefs.getString('image')!);
    return exp;
  }

  @override
  State<Experience> createState() => _ExperienceState();
}

class _ExperienceState extends State<Experience> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.5),
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
          child: Column(
            children: [
              xpListTile(context),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                //can add an image to the experience by camera or gallery
                child: (!widget.editable)
                    ? widget._image == null
                        ? Text("No images selected",
                            style: Theme.of(context).textTheme.bodyMedium)
                        : Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(widget._image!)),
                          )
                    : Row(
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
        ),
      ),
    );
  }

//this create a list tile of each experience and has an edit mode
  ListTile xpListTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //name of experience
          if (widget.title != "Community Service")
            (!widget.editable)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 2,
                      ),
                    ],
                  )
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    //has to have a value to continue
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
                    decoration:
                        underlineInputDecoration(context, "ex. FBLA", "Name"),
                  )
          else
            //location of experience if it's community service
            (!widget.editable)
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Community Service at ${widget.location}",
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ],
                  )
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    initialValue: widget.location,
                    //has to have a value to continue
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
          //start date with a date picker
          (!widget.editable)
              ? buildRichText(context, "Start Date: ", widget.startDate,
                  Theme.of(context).textTheme.bodyMedium)
              : TextFormField(
                  //has to have a value and the start date should be before the end date to continue
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
                  controller: TextEditingController(text: widget.startDate),
                  readOnly: true, // Prevents manual editing
                  decoration: underlineInputDecoration(
                      context, "ex. 4/24/2024", "Start Date"),
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 365 * 25)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        widget.startDate =
                            formatDate(pickedDate.toString().substring(0, 10));
                      });
                    }
                  },
                ),
          //end date with a date picker
          Padding(
            padding: const EdgeInsets.only(bottom: 7.5),
            child: (!widget.editable)
                ? buildRichText(context, "End Date: ", widget.endDate,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    //has to have a value to continue
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodyMedium,
                    controller: TextEditingController(text: widget.endDate),
                    readOnly: true,
                    decoration: underlineInputDecoration(
                        context, "ex. 4/27/2024", "End Date"),
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now()
                            .subtract(const Duration(days: 365 * 25)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
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
          //role in experience
          if (widget.title == "Clubs/Organizations")
            (!widget.editable)
                ? buildRichText(context, "Role: ", widget.role,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    //has to have a value to continue
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
          //issuer of award
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
                    decoration: underlineInputDecoration(
                        context, "ex. Woodinville High School", "Issuer")),
          //service hours
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
                      });
                    },
                    decoration: underlineInputDecoration(
                      context,
                      "ex. 10",
                      "Hours",
                    ),
                    //has to be a postive number and has to have a value to continue
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
          //score on test
          if (widget.title == "Tests")
            (!widget.editable)
                ? buildRichText(context, "Score: ", widget.score,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    //has to be non-negative and has to have a value to continue
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
                    decoration:
                        underlineInputDecoration(context, "ex. 1320", "Score"),
                  ),
          //grade in class
          if (widget.title == "Honors Classes")
            (!widget.editable)
                ? buildRichText(context, "Grade: ", widget.grade,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    //has to have a value to continue
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    },
                    initialValue: widget.grade,
                    onChanged: (value) {
                      setState(() {
                        widget.grade = value;
                      });
                    },
                    decoration:
                        underlineInputDecoration(context, "ex. A", "Grade"),
                  ),
          //description of experience
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
        ],
      ),
      trailing: SizedBox(
        width: 145,
        height: 175,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            //this button puts all the values in edit mode where you can change and update them
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
                        //will not save edit if validation is not true
                        hasErrors = !formState.validate();
                        if (!hasErrors) {
                          widget.editable = false;
                          widget.updateTime = DateTime.now();
                          context
                              .read<MyExperiences>()
                              .saveXP(widget.tileIndex);
                        }
                      });
                    },
              //changes to check icon when you want to end edit mode
              child: Icon(
                (!widget.editable) ? Icons.edit : Icons.check,
                size: 20,
              ),
            ),
            //this button lets you remove the experience
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
    );
  }

  // The widget decoration for all text fields in this class
  InputDecoration underlineInputDecoration(
      BuildContext context, String hint, String label) {
    return InputDecoration(
      hintText: hint,
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.always,
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

  //this method takes the image source(camera or gallery) and gets an image using uses image picker package
  Future getImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      maxHeight: 150,
      maxWidth: 150,
    );
    if (pickedImage == null) {
      return;
    }

    setState(() {
      widget._image = File(pickedImage.path);
      widget.imagePath = widget._image!.path;
    });

    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;

    await widget._image!.copy('$path/${basename(pickedImage.path)}');
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

  //this method takes a date and formates it into month day and year
  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }
}
