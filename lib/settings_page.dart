import 'package:flutter/material.dart';
import 'main.dart';
import 'theme.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Settings", style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton(
                heroTag: "button 1",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Security()),
                  );
                },
                child: const Text("Account and Security"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton(
                heroTag: "button 2",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Terms()),
                  );
                },
                child: const Text("Terms and Conditions"),
              ),
            ),
            const SizedBox(height: 20),
            const Center(child: ResetButton()),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class Security extends StatefulWidget {
  Security({super.key});
  bool nameEditable = false;
  bool schoolEditable = false;
  bool yearEditable = false;
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  String name = "";
  String school = "";
  String year = "";
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() {
    String? tempName = prefs.getString('name');
    String? tempSchool = prefs.getString('school');
    String? tempYear = prefs.getString('year');

    if (tempName != null && tempSchool != null && tempYear != null) {
      setState(() {
        name = tempName;
        school = tempSchool;
        year = tempYear;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final formState = _formKey.currentState;
            if (formState != null && formState.validate()) {
              formState.save();
              prefs.setString("name", name);
              prefs.setString("school", school);
              prefs.setString("year", year);
              Navigator.pop(context);
            } else {
              // Show an error message
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content:
                      Text('Please fix the errors before leaving the page')));
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Settings", style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 50),
            Text("Edit Account Information",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Name: '),
                    subtitle: !widget.nameEditable
                        ? Text(name)
                        : TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (value) => setState(() {
                              name = value;
                            }),
                            decoration: underlineInputDecoration(
                                context, "ex. Alexander T. Graham"),
                            initialValue: name,
                          ),
                    trailing: TextButton(
                      child: Icon(
                        (!widget.nameEditable) ? Icons.edit : Icons.check,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        !widget.nameEditable
                            ? setState(() {
                                widget.nameEditable = true;
                              })
                            : setState(
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.nameEditable = false;
                                  }
                                },
                              );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('School: '),
                    subtitle: !widget.schoolEditable
                        ? Text(school)
                        : TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (value) =>
                                setState(() => school = value),
                            initialValue: school,
                            decoration: underlineInputDecoration(
                                context, "ex. Woodinville High School"),
                          ),
                    trailing: TextButton(
                      child: Icon(
                        (!widget.schoolEditable) ? Icons.edit : Icons.check,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        !widget.schoolEditable
                            ? setState(() {
                                widget.schoolEditable = true;
                              })
                            : setState(
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.schoolEditable = false;
                                  }
                                },
                              );
                      },
                    ),
                  ),
                  ListTile(
                    title: const Text('Year: '),
                    subtitle: !widget.yearEditable
                        ? Text(year)
                        : TextFormField(
                            validator: (value) {
                              if (value != null) {
                                final int? numVal = int.tryParse(value);
                                if (numVal == null ||
                                    numVal <= 1900 ||
                                    numVal >= DateTime.now().year + 50) {
                                  return "Enter a valid year";
                                }
                              } else if (value == null || value.isEmpty) {
                                return "Field cannot be empty";
                              }
                              return null;
                            },
                            onChanged: (value) => setState(() => year = value),
                            initialValue: year,
                            decoration:
                                underlineInputDecoration(context, "ex. 2025"),
                          ),
                    trailing: TextButton(
                      child: Icon(
                        (!widget.yearEditable) ? Icons.edit : Icons.check,
                        color: Colors.black,
                        size: 20,
                      ),
                      onPressed: () {
                        !widget.yearEditable
                            ? setState(() {
                                widget.yearEditable = true;
                              })
                            : setState(
                                () {
                                  if (_formKey.currentState!.validate()) {
                                    widget.yearEditable = false;
                                  }
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration underlineInputDecoration(BuildContext context, String hint) {
    return InputDecoration(
      hintText: hint,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
      focusedErrorBorder:
          const UnderlineInputBorder(borderSide: BorderSide(color: Colors.red)),
    );
  }
}

class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Settings",
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text("Review Terms and Conditions",
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  termsConditions,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FloatingActionButton(
        heroTag: "button 3",
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Warning'),
                content: const Text('Are you sure you want to clear all data?'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      prefs.clear();
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data cleared'),
                        ),
                      );
                      Navigator.pushNamedAndRemoveUntil(
                          context, "/splash", (_) => false);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Reset Profile'),
      ),
    );
  }
}
