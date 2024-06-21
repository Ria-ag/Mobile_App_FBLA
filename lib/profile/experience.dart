import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:mobileapp/profile/my_profile_xps.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import "../main.dart";
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';

// This class defines an experience and requires a title, id, and type of tile
// ignore: must_be_immutable
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

  // Converts an Experience object into a JSON string
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

  // Creates an Experience object from a JSON string
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
        child: Column(
          children: [
            xpListTile(context),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
              //can add an image to the experience by camera or gallery
              child: (!widget.editable)
                  ? widget._image == null
                      ? const Text("No images selected")
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
    );
  }

// This creates a list tile of each experience and has an edit mode
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
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                      Divider(
                        color: Theme.of(context).colorScheme.secondary,
                        thickness: 2,
                        endIndent: MediaQuery.of(context).size.width / 4,
                      ),
                      const SizedBox(height: 10),
                    ],
                  )
                : TextFormField(
                    // Must contain a value to continue
                    validator: (value) => noEmptyField(value),
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
            // Location of experience if it's community service
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
                    // Must contain a value to continue
                    validator: (value) => noEmptyField(value),
                    onChanged: (value) {
                      setState(() {
                        widget.location = value;
                      });
                    },
                    decoration: underlineInputDecoration(
                        context, "ex. Hopelink", "Location"),
                  ),
          // Start date with a date picker
          (!widget.editable)
              ? buildRichText(context, "Start Date: ", widget.startDate,
                  Theme.of(context).textTheme.bodyMedium)
              : TextFormField(
                  // Value necessary and the start date should be before the end date to continue
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
          // End date with a date picker
          Padding(
            padding: const EdgeInsets.only(bottom: 7.5),
            child: (!widget.editable)
                ? buildRichText(context, "End Date: ", widget.endDate,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    //Must contain a value to continue
                    validator: (value) => noEmptyField(value),
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
          // Role in experience
          if (widget.title == "Clubs/Organizations")
            (!widget.editable)
                ? buildRichText(context, "Role: ", widget.role,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    // Must contain a value to continue
                    validator: (value) => noEmptyField(value),
                    initialValue: widget.role,
                    onChanged: (value) {
                      setState(() {
                        widget.role = value;
                      });
                    },
                    decoration: underlineInputDecoration(
                        context, "ex. President", "Role"),
                  ),
          // Issuer of award
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
          // Service hours
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
                    // Must contain a postive number to continue
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
          // Score on test
          if (widget.title == "Tests")
            (!widget.editable)
                ? buildRichText(context, "Score: ", widget.score,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    // MUst contain a non-negative a value to continue
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
          // Grade in class
          if (widget.title == "Honors Classes")
            (!widget.editable)
                ? buildRichText(context, "Grade: ", widget.grade,
                    Theme.of(context).textTheme.bodyMedium)
                : TextFormField(
                    style: Theme.of(context).textTheme.bodyMedium,
                    // Must contain a value to continue
                    validator: (value) => noEmptyField(value),
                    initialValue: widget.grade,
                    onChanged: (value) {
                      setState(() {
                        widget.grade = value;
                      });
                    },
                    decoration:
                        underlineInputDecoration(context, "ex. A", "Grade"),
                  ),
          // Description of experience
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
            
          IconButton(
            icon: Image.asset('en_US.png'),
              onPressed: () => shareToLinkedIn(widget.name, widget.award),
          )
        ],
      ),
      trailing: SizedBox(
        width: 85,
        height: 175,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // This button puts all the values in edit mode where you can change and update them
            IconButton(
              style: theme.iconButtonTheme.style,
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
                          context.read<MyProfileXPs>().saveXP(widget.tileIndex);
                        }
                      });
                    },
              // Changes to check icon when you want to end edit mode
              icon: Icon(
                (!widget.editable) ? Icons.edit : Icons.check,
                size: 20,
              ),
            ),
            // This button lets you remove the experience
            IconButton(
              style: theme.iconButtonTheme.style,
              onPressed: () {
                context
                    .read<MyProfileXPs>()
                    .remove(widget.xpID, widget.tileIndex);
                context.read<MyProfileXPs>().saveXP(widget.tileIndex);
              },
              icon: const Icon(Icons.remove, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  // This method takes the image source(camera or gallery) and gets an image using uses image picker package
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

  // This method takes a date and formates it into month, day, and year
  String formatDate(String date) {
    List<String> parts = date.split('-');
    return '${parts[1]}/${parts[2]}/${parts[0]}';
  }
  
  shareToLinkedIn(String name, String award) async {
    String url = "https://www.linkedin.com/profile/add?startTask=CERTIFICATION_NAME&name=$name&organizationName=$award";
    final Uri parsed = Uri.parse(url);
   if (!await launchUrl(parsed)) {
        throw Exception('Could not launch $parsed');
    }
  }
}
