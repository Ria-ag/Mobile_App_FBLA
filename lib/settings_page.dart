import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'theme.dart';

// This class is the settings page
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
      body: Column(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            height: MediaQuery.of(context).size.height/3,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(left:20, top: 150),
              child: Text(
                "Settings", 
                style: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 50, color: Colors.white)
              ),
            )
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 15),
                 SizedBox(
              width: MediaQuery.of(context).size.width,
              //this button opens an account and security page
              child: CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Security()),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Account and Security",
                      style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 15)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 175),
                      child: Icon(Icons.circle, size: 45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              // This button opens a terms and conditions page
              child: CustomElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Terms()),
                  );
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text("Terms and Conditions",
                       style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 15)),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 171),
                      child: Icon(Icons.circle, size: 45),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // This is where the reset button is
            const Center(child: ResetButton()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// This class builds a security page where users can change their name, school and grade
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

  // This method retrieves user data when the class is initialized
  @override
  void initState() {
    super.initState();
    getData();
  }

  // This method gets the stored data from shared preferences
  void getData() async {
    prefs = await SharedPreferences.getInstance();

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
        // This button takes the user back to the main settings page and saves the new data to shared preferences if changed
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
              // Users cannot leave till all errors on the page are fixed
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
                  // Name data
                  ListTile(
                    title: const Text('Name: '),
                    subtitle: !widget.nameEditable
                        ? Text(name)
                        : TextFormField(
                            // A value must be entered in the field
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
                                context, "ex. Alexander T. Graham", null),
                            initialValue: name,
                          ),
                    // This button is used to toggle whether the field is editable
                    trailing: IconButton(
                      icon: Icon(
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
                  // School data
                  ListTile(
                    title: const Text('School: '),
                    subtitle: !widget.schoolEditable
                        ? Text(school)
                        : TextFormField(
                            // A value must be entered in the field
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
                                context, "ex. Woodinville High School", null),
                          ),
                    // This button is used to toggle whether the field is editable
                    trailing: IconButton(
                      icon: Icon(
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
                  // Year data
                  ListTile(
                    title: const Text('Year: '),
                    subtitle: !widget.yearEditable
                        ? Text(year)
                        : TextFormField(
                            // A value must be entered in the field
                            // This value must be a year greater than 1900 and before 50 years ahead of the current year
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
                            decoration: underlineInputDecoration(
                                context, "ex. 2025", null),
                          ),
                    // This button is used to toggle whether the field is editable
                    trailing: IconButton(
                      icon: Icon(
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
}

//this class builds the terms page to review the terms the user accepted
class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //this button takes the user back to the main settings page
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

//this class builds a reset button to clear all data from shared preferences
class ResetButton extends StatelessWidget {
  const ResetButton({super.key});

  Future<void> _clearSharedPreferences(BuildContext context) async {
    prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    // ignore: use_build_context_synchronously
    RestartWidget.restartApp(context);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: CustomElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Warning'),
                content: const Text('Are you sure you want to clear all data?'),
                actions: <Widget>[
                  // This button closes the dialong without clearing data
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Cancel'),
                  ),

                  // This button clears all data
                  TextButton(
                    onPressed: () {
                      _clearSharedPreferences(context);
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            },
          );
        },
        child:Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Reset Profile',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(fontSize: 15)),
            ),
            const Padding(
                      padding: EdgeInsets.only(left: 246),
                      child: Icon(Icons.circle, size: 45),
                    ),
          ],
        ),
      ),
    );
  }
}
