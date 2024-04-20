import 'package:flutter/material.dart';
import 'package:mobileapp/experience.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatelessWidget{
  const HomePage({super.key});

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Row(
                children: [
                  Icon(Icons.star),
                  Text("Welcome, name", style: TextStyle(fontSize: 40)),
                ],
              ),
              SizedBox(
                width: 200,
                child: FloatingActionButton(
                  onPressed: () => createPdf(context),
                  child: const Text("Create and share pdf"),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Most recently added experience:"),
              ),
            ],
          ),
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

    for (int i = 0; i < myExperiences.xpList.length; i++) {
      List<Experience> experiences = myExperiences.xpList[i];
      var xp = experiences[i];

      pdf.addPage(
        pw.Page(
          build: (context) {
            return pw.Column(
              children: [
                pw.Text(name!, style: const pw.TextStyle(fontSize: 24)),
                pw.Text(school!, style: const pw.TextStyle(fontSize: 20)),
                pw.Text("Class of ${year!}", style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(width: 100),
                if (experiences.isNotEmpty)pw.Text(xp.title),
                for (var experience in experiences)
                  pw.Column(
                    children: [
                      pw.Text(experience.name),
                      pw.Text(experience.date),
                      pw.Text(experience.description),
                      pw.Text(experience.grade),
                      pw.Text(experience.role),
                      pw.Text(experience.score),
                      pw.Text(experience.hours),
                      pw.Text(experience.score),
                      pw.Text(experience.award),
                      pw.Text(experience.location),
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