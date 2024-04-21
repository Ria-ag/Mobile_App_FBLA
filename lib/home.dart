import 'package:flutter/material.dart';
import 'package:mobileapp/experience.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Experience? recent;
  String name = "name";

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
    getName();
  }

  Future<void> _initSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    getRecent(prefs);
  }

  Future<void> getRecent(prefs) async {
    DateTime mostRecentUpdateTime = DateTime.utc(0);
    Experience? mostRecent;
    for (int i = 0; i < 8; i++){
      List<String>? xps = prefs.getStringList('$i');
      if (xps != null) {
        for (String xpString in xps) {
          Experience tempExperience = Experience.fromJsonString(xpString);
          if (mostRecentUpdateTime.isBefore(tempExperience.updateTime))
          {
            mostRecentUpdateTime = tempExperience.updateTime;
            mostRecent = tempExperience;
          }
        }
      }
    }
    if (mostRecent != null) {
      setState(() {
         recent = mostRecent!;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initSharedPreferences();
  }

  Future<void> getName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? tempName = prefs.getString('name');
    if (tempName != null) {
      setState(() {
        name = tempName;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    debugPrint("main build called");

    return Scaffold(
        body:
          Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/background.png'), fit: BoxFit.cover,),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 30, right: 30),
                          child: Container(
                            alignment: Alignment.topLeft,
                            child: const Image(image: AssetImage('assets/logo.png'), height: 100)
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 30),
                          child: Center(child: Text('Welcome,\n $name', style: const TextStyle(fontSize: 40))),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 130, bottom: 10),
                      child: Text("Share your profile with the world", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      width: 200,
                      child: FloatingActionButton(
                        onPressed: () => createPdf(context),
                        child: const Text("Create and share pdf"),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 25, bottom: 10),
                      child: Text("Most recently added experience:", style: TextStyle(color: Colors.white)),
                    ),
                    recent != null
                      ? ListTile(
                          title: Text(recent!.title, style: const TextStyle(color: Colors.white)),
                          subtitle: Text(recent!.name, style: const TextStyle(color: Colors.white)),
                          trailing: Text(recent!.date, style: const TextStyle(color: Colors.white)),
                          tileColor: const Color.fromARGB(255, 218, 124, 96),
                      )
                    : const Text("Add an experience in the profile page to get started", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
    );
  }

void createPdf(context) async{
    MyExperiences myExperiences = Provider.of<MyExperiences>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? school = prefs.getString('school');
    String? year = prefs.getString('year');
    
    final pdf = pw.Document();

    for (int i = 0; i < 8; i++) {
      List<Experience> experiences = myExperiences.xpList[i];

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              children: [
                pw.Text(name!, style: const pw.TextStyle(fontSize: 24)),
                pw.Text(school!, style: const pw.TextStyle(fontSize: 20)),
                pw.Text("Class of ${year!}", style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(width: 100),
                if (experiences.isNotEmpty)pw.Text(experiences[0].title),
                for (var experience in experiences)
                  pw.Column(
                    children: [
                      pw.Text(experience.name),
                      pw.Text(experience.date),
                      i != 7 && i != 4 ? pw.Text(experience.description) : pw.SizedBox(),
                      i == 4 ? pw.Text(experience.grade) : pw.SizedBox(),
                      i == 5 ? pw.Text(experience.role) : pw.SizedBox(),
                      i ==2 ? pw.Text(experience.hours) : pw.SizedBox(),
                      i == 7 ? pw.Text(experience.score) : pw.SizedBox(),
                      i == 3 ? pw.Text(experience.award) : pw.SizedBox(),
                      i == 2 ? pw.Text(experience.location) : pw.SizedBox(),
                    ],
                  ),
              ],
            );
          },
        ),
      );
    }

    await Printing.sharePdf(bytes: await pdf.save(), filename: 'MyRise.pdf');
  }
}