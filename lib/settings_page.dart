import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/my_app_state.dart';
import 'package:provider/provider.dart';
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
      body: Stack(
        children: [
          Container(
            color: Theme.of(context).colorScheme.secondary,
            height: MediaQuery.of(context).size.height / 3.5 + 45,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25, bottom: 85),
                  child: Text("Settings",
                      style: Theme.of(context)
                          .textTheme
                          .displayMedium!
                          .copyWith(color: Colors.white)),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3.5,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      SettingsElevatedButton(
                        text: "Account and Security",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Security()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      SettingsElevatedButton(
                        text: "Terms and Conditions",
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Terms()),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      // This is the sign out button
                      Center(
                          child: SettingsElevatedButton(
                        text: "Sign Out",
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                        },
                      )),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
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
  bool nameEditable = false, schoolEditable = false, yearEditable = false;
  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  String name = "", school = "", year = "";
  final _formKey = GlobalKey<FormState>();

  // This method retrieves user data when the class is initialized
  @override
  void initState() {
    super.initState();
    name = context.read<MyAppState>().appUser.name;
    school = context.read<MyAppState>().appUser.school;
    year = context.read<MyAppState>().appUser.year.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This button takes the user back to the main settings page and saves the new data to Firestore if changed
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final formState = _formKey.currentState;
            if (formState != null && formState.validate()) {
              context.read<MyAppState>().saveUserInfoLocalandDB(
                    name,
                    school,
                    int.parse(year),
                  );
              Navigator.pop(context);
            } else {
              // Users cannot leave till all errors on the page are fixed
              showTextSnackBar('Please fix the errors before leaving the page');
            }
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Text("Settings", style: Theme.of(context).textTheme.displayMedium),
            const SizedBox(height: 50),
            Text("Edit Account Information",
                style: Theme.of(context).textTheme.headlineLarge,
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
                            validator: (value) => noEmptyField(value),
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
                            validator: (value) => noEmptyField(value),
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
                    title: const Text('Year of Graduation: '),
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

// This class builds the terms page to review the terms the user accepted
class Terms extends StatelessWidget {
  const Terms({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // This button takes the user back to the main settings page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Settings",
              style: Theme.of(context).textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  Text("Review Terms and Conditions",
                      style: Theme.of(context).textTheme.headlineLarge,
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

class SettingsElevatedButton extends StatelessWidget {
  const SettingsElevatedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });
  final String text;
  final dynamic Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return CustomElevatedButton(
      onPressed: onPressed,
      stadiumBorder: true,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 160,
              child:
                  Text(text, style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(
              width: 95,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.circle,
                    size: 80,
                    color: Colors.white,
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
