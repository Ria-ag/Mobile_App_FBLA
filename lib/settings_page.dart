import 'package:flutter/material.dart';
import 'package:mobileapp/main.dart';
import 'package:provider/provider.dart';
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
          ],
        ),
      ),
    );
  }
}

class Security extends StatefulWidget {
  @override
  Security({super.key});
  bool editable = false;
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

  Future<void> getData() async{
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
                setState(() {save(context, name, school, year);});
                Navigator.pop(context);
              },
        ),
      ),
      body: Column(
          children: [
            const Text("Settings", style: TextStyle(fontSize: 40)),
            const Text("Name:"),
            !widget.editable ?
              Text(name)
            : TextFormField(
                onChanged: (value) => setState(() => name = value),
                decoration: const InputDecoration(
                  hintText: ("First, Last"),
                )
              ),
            const Text("School:"),
            !widget.editable ?
              Text(school)
            : TextFormField(
                onChanged: (value) => setState(() => school = value),
                decoration: const InputDecoration(
                  hintText: ("ex. Woodinville High School"),
                )
              ),
            const Text("Year:"),
            !widget.editable ?
              Text(year)
            : TextFormField(
                onChanged: (value) => setState(() => year = value),
                decoration: const InputDecoration(
                  hintText: ("ex. 2025"),
                )
              ),
          ],
      ),
    );
  }

  void save(BuildContext context, String name, String school, String year) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("name", name);
    await prefs.setString("school", school);
    await prefs.setString("year", year);
  }
}
