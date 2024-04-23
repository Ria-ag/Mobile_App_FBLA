import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'experience.dart';
import 'main.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:pdfx/pdfx.dart' as pd;


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Experience? recent;
  String name = "";

  @override
  void initState() {
    super.initState();
    getRecent(prefs);
    String? tempName = prefs.getString('name');
    if (tempName != null) {
      setState(() {
        name = tempName;
      });
    }
  }

  Future<void> getRecent(prefs) async {
    DateTime mostRecentUpdateTime = DateTime.utc(0);
    Experience? mostRecent;
    for (int i = 0; i < 8; i++) {
      List<String>? xps = prefs.getStringList('$i');
      if (xps != null) {
        for (String xpString in xps) {
          Experience tempExperience = Experience.fromJsonString(xpString);
          if (mostRecentUpdateTime.isBefore(tempExperience.updateTime)) {
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
    getRecent(prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30, top: 30, right: 30),
                      child: Container(
                        alignment: Alignment.topLeft,
                        child: const Image(
                            image: AssetImage('assets/logo.png'), height: 100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: SizedBox(
                        width: 200,
                        child: Text(
                          'Welcome,\n${name.substring(0, (name.contains(" ")) ? name.indexOf(" ") : name.length)}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 200, bottom: 10),
                  child: Text(
                    "Share your profile with the world!",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white),
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: FloatingActionButton(
                    heroTag: "button 1",
                    onPressed: () => createPdf(context),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Create and share a pdf version of profile",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 200,
                  child: FloatingActionButton(
                    heroTag: "button 1",
                    onPressed: () => instaPdf(),
                    child: const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        "Share to instagram",
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 25, bottom: 10),
                  child: Text("Most recently updated:",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(color: Colors.white)),
                ),
                SizedBox(
                  width: 400,
                  child: FloatingActionButton(
                    heroTag: "button 2",
                    onPressed: () {},
                    child: (recent != null)
                        ? ListTile(
                            title: Text(recent!.title,
                                style: const TextStyle(color: Colors.white)),
                            subtitle: Text(recent!.name,
                                style: const TextStyle(color: Colors.white)),
                            trailing: Text(
                                "${recent!.startDate} - ${recent!.endDate}",
                                style: const TextStyle(color: Colors.white)),
                            tileColor: const Color.fromARGB(255, 218, 124, 96),
                          )
                        : const Text(
                            "Add an experience in the profile page to get started",
                            style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Future<File> makePdf() async{
    MyExperiences myExperiences =
        Provider.of<MyExperiences>(context, listen: false);
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
                pw.Text("Class of ${year!}",
                    style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(width: 100),
                if (experiences.isNotEmpty) pw.Text(experiences[0].title),
                for (var experience in experiences)
                  pw.Column(
                    children: [
                      pw.Text(experience.name),
                      pw.Text(
                          "${experience.startDate} - ${experience.endDate}"),
                      i != 7 && i != 4
                          ? pw.Text(experience.description)
                          : pw.SizedBox(),
                      i == 4 ? pw.Text(experience.grade) : pw.SizedBox(),
                      i == 5 ? pw.Text(experience.role) : pw.SizedBox(),
                      i == 2 ? pw.Text(experience.hours) : pw.SizedBox(),
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
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/example.pdf');
    await tempFile.writeAsBytes(await pdf.save());
    return tempFile;
  }

  void instaPdf() async {
    File pdf = await makePdf();
    debugPrint(pdf.path);
    List<XFile> tempFiles = [];

    final document = await pd.PdfDocument.openFile(pdf.path);
    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(width: page.width, height: page.height, format: pd.PdfPageImageFormat.jpeg);
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final tempFile = File('$tempPath/temp_$i.jpeg');
      await tempFile.writeAsBytes(pageImage!.bytes);
      await page.close();
      tempFiles.add(XFile(tempFile.path));
    }
    await Share.shareXFiles(tempFiles, text: 'Check out my Accomplishments!');
  }

  void createPdf(context) async {
    MyExperiences myExperiences =
        Provider.of<MyExperiences>(context, listen: false);
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
                pw.Text("Class of ${year!}",
                    style: const pw.TextStyle(fontSize: 20)),
                pw.SizedBox(width: 100),
                if (experiences.isNotEmpty) pw.Text(experiences[0].title),
                for (var experience in experiences)
                  pw.Column(
                    children: [
                      pw.Text(experience.name),
                      pw.Text(
                          "${experience.startDate} - ${experience.endDate}"),
                      i != 7 && i != 4
                          ? pw.Text(experience.description)
                          : pw.SizedBox(),
                      i == 4 ? pw.Text(experience.grade) : pw.SizedBox(),
                      i == 5 ? pw.Text(experience.role) : pw.SizedBox(),
                      i == 2 ? pw.Text(experience.hours) : pw.SizedBox(),
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
