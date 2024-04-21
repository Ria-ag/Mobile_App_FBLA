import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            const Text("Settings", style: TextStyle(fontSize: 40)),
            const SizedBox(height: 50),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Security()),
                  );
                },
                child: const Text("Privacy & Security"),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: FloatingActionButton(
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
            Center(child: ResetButton()),
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
  String name = "name";
  String school = "school";
  String year = "year";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
            setState(() {
              save(context, name, school, year);
            });
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          const Text("Settings", style: TextStyle(fontSize: 40)),
          ListTile(
            title: const Text('Name: '),
            subtitle: !widget.nameEditable
                ? Text(name)
                : TextFormField(
                    onChanged: (value) => setState(() => name = value),
                    decoration: const InputDecoration(
                      hintText: ("First, Last"),
                    )),
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
                    : setState(() {
                        widget.nameEditable = false;
                      });
              },
            ),
          ),
          ListTile(
            title: const Text('School: '),
            subtitle: !widget.schoolEditable
                ? Text(school)
                : TextFormField(
                    onChanged: (value) => setState(() => year = value),
                    decoration: const InputDecoration(
                      hintText: ("ex. Woodinville High School"),
                    )),
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
                    : setState(() {
                        widget.schoolEditable = false;
                      });
              },
            ),
          ),
          ListTile(
            title: const Text('Year: '),
            subtitle: !widget.yearEditable
                ? Text(year)
                : TextFormField(
                    onChanged: (value) => setState(() => year = value),
                    decoration: const InputDecoration(
                      hintText: ("ex. 2025"),
                    )),
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
                    : setState(() {
                        widget.yearEditable = false;
                      });
              },
            ),
          ),
        ],
      ),
    );
  }

  void save(
      BuildContext context, String name, String school, String year) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("school", school);
    await prefs.setString("year", year);
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
      body: const Column(
        children: [
          Text("Review Terms & Conditions", style: TextStyle(fontSize: 20)),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text("This app is only to be used for the purpose of FBLA"),
          ),
        ],
      ),
    );
  }
}

class ResetButton extends StatelessWidget {
  Future<void> _clearSharedPreferences(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: FloatingActionButton(
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
                      _clearSharedPreferences(context);
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('SharedPreferences data cleared'),
                        ),
                      );
                    },
                    child: const Text('Reset'),
                  ),
                ],
              );
            },
          );
        },
        child: const Text('Reset'),
      ),
    );
  }
}
