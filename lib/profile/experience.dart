import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart';
import '../my_app_state.dart';
import '../theme.dart';

// This class defines an experience and requires a title, id, and type of tile
// ignore: must_be_immutable
class Experience extends StatefulWidget {
  Experience({
    super.key,
    required this.xpID,
    required this.tileIndex,
  });
  // The index of an experience's category
  final int tileIndex;
  // A unique identification number for each integer
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
  Map<String, dynamic> toMap() {
    return {
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
      'updateTime': updateTime.toIso8601String(),
      'image': imagePath,
      'editable': editable,
    };
  }

  // Creates an Experience object from a map
  factory Experience.fromMap(Map<String, dynamic> xpMap) {
    final Map<String, dynamic> map = Map<String, dynamic>.from(xpMap);

    Experience exp = Experience(
      xpID: map['xpID'],
      tileIndex: map['tileIndex'],
    );
    exp.name = map['name'];
    exp.startDate = map['startDate'];
    exp.endDate = map['endDate'];
    exp.description = map['description'];
    exp.score = map['score'];
    exp.grade = map['grade'];
    exp.role = map['role'];
    exp.hours = map['hours'];
    exp.award = map['award'];
    exp.location = map['location'];
    exp.imagePath = map['image'] ?? "";
    exp.editable = map['editable'];
    exp.updateTime = DateTime.tryParse(map['updateTime']) ?? DateTime.now();
    exp._image = (exp.imagePath.isEmpty) ? null : File(exp.imagePath);

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
          borderRadius: BorderRadius.circular(15),
          boxShadow: [shadow],
        ),
        // This form is used for validation of experiences
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
                            width: 35,
                            height: 35,
                            child: FloatingActionButton(
                              onPressed: () => getImage(ImageSource.gallery),
                              tooltip: 'Pick Image',
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: const Icon(
                                  Icons.add_photo_alternate_rounded,
                                  size: 20),
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 35,
                            height: 35,
                            child: FloatingActionButton(
                              onPressed: () => getImage(ImageSource.camera),
                              tooltip: 'Capture Image',
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              child: const Icon(Icons.add_a_photo, size: 20),
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

// This creates a list tile of each experience and has an edit mode
  ListTile xpListTile(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //name of experience
          if (widget.tileIndex != 2)
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
                        endIndent: MediaQuery.of(context).size.width / 8,
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
              ? buildRichText(context, "Start Date: ", widget.startDate)
              : TextFormField(
                  // The value is necessary and the start date should be before the end date to continue
                  validator: (value) =>
                      validateStartDate(value, widget.endDate),
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
                        widget.startDate = formatDate(pickedDate);
                      });
                    }
                  },
                ),
          // End date with a date picker
          Padding(
            padding: const EdgeInsets.only(bottom: 7.5),
            child: (!widget.editable)
                ? buildRichText(context, "End Date: ", widget.endDate)
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
                        lastDate:
                            DateTime.now().add(const Duration(days: 365 * 25)),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          widget.endDate = formatDate(pickedDate);
                        });
                      }
                    },
                  ),
          ),
          const SizedBox(width: 10),
          // Role in experience
          if (widget.tileIndex == 5)
            (!widget.editable)
                ? buildRichText(context, "Role: ", widget.role)
                : TextFormField(
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
          if (widget.tileIndex == 3)
            (!widget.editable)
                ? (widget.award.isEmpty)
                    ? const Text("No issuer")
                    : buildRichText(context, "Issuer: ", widget.award)
                : TextFormField(
                    initialValue: widget.award,
                    onChanged: (value) {
                      setState(() {
                        widget.award = value;
                      });
                    },
                    decoration: underlineInputDecoration(
                        context, "ex. Woodinville High School", "Issuer")),
          // Service hours
          if (widget.tileIndex == 2)
            (!widget.editable)
                ? buildRichText(context, "Hours: ", widget.hours)
                : TextFormField(
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
                    // Must contain a non-negative a value to continue
                    validator: (value) => nonNegativeValue(value),
                  ),
          // Score on test
          if (widget.tileIndex == 7)
            (!widget.editable)
                ? buildRichText(context, "Score: ", widget.score)
                : TextFormField(
                    // Must contain a non-negative a value to continue
                    validator: (value) => nonNegativeValue(value),
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
          if (widget.tileIndex == 4)
            (!widget.editable)
                ? buildRichText(context, "Grade: ", widget.grade)
                : TextFormField(
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
          if (widget.tileIndex != 7 && widget.tileIndex != 5)
            (!widget.editable)
                ? (widget.description.isEmpty)
                    ? const Text("No description")
                    : buildRichText(
                        context, "Description:\n", widget.description)
                : TextFormField(
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
        width: 100,
        height: 175,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // This button puts all the values in edit mode, where you can change and update them
            IconButton(
              onPressed: (!widget.editable)
                  ? () => setState(() {
                        widget.editable = true;
                      })
                  : () {
                      final formState = widget._formKey.currentState;
                      if (formState == null) return;
                      formState.save();

                      setState(() {
                        // Will not save edit if validation is not true
                        if (formState.validate()) {
                          widget.editable = false;
                          widget.updateTime = DateTime.now();
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
              onPressed: () {
                context
                    .read<MyAppState>()
                    .removeXp(widget.xpID, widget.tileIndex);
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

  Widget buildRichText(BuildContext context, String label, String value) {
    final TextStyle style = Theme.of(context).textTheme.bodyMedium!;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: label,
            style: style.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: value,
            style: style,
          ),
        ],
      ),
    );
  }
}
