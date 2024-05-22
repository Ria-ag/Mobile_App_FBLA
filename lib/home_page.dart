import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'profile/experience.dart';
import 'main.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:pdfx/pdfx.dart' as pd;

// This is the home page of the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Experience? recent;
  String name = "";

  @override
  // When the home page is initialized, and initial methods are called
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

  // This method compares the times of experiences to get the most recent one
  void getRecent(prefs) {
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

  // A method called when a dependency of this [State] object changes
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getRecent(prefs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // The home page's welcome message
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

              // This section of the code uses the sharePlus and pdfx packages to save the profile as a pdf or share it to social media
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
                child: ElevatedButton(
                  onPressed: () => createPdf(context),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Create and share a .pdf version of the profile",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => socialPdf(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Share profile to social media as images",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),

              // Here, to most recently updated experience is shown
              Padding(
                padding: const EdgeInsets.all(20),
                child: Text("Most recently updated:",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium!
                        .copyWith(color: Colors.white)),
              ),
              SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: (recent != null)
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(recent!.title),
                                    Text(recent!.name),
                                  ],
                                ),
                                Text(
                                    "${recent!.startDate} - ${recent!.endDate}"),
                              ])
                        : const Text(
                            "Add an experience in the profile page to get started.",
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

// This is the method that creates the look of a pdf page that is shared
  void addPage(
    pw.Document pdf,
    String? name,
    String? school,
    String? year,
    List<Experience> experiences,
    int i,
  ) {
    return pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // This is the header section of the pdf resume
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10.0),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      name!,
                      style: pw.TextStyle(
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.Text(
                      '$school - Class of $year',
                      style: const pw.TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),

              // Here is where all the experiences are displayed
              for (var experience in experiences) ...[
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 10.0),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        experience.title,
                        style: pw.TextStyle(
                          fontSize: 18,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                      pw.Text(
                        '${experience.startDate} - ${experience.endDate}',
                        style: const pw.TextStyle(fontSize: 16),
                      ),
                      pw.SizedBox(height: 5),
                      if (i != 7 && i != 4) pw.Text(experience.description),
                      if (i == 4) pw.Text("Grade: ${experience.grade}"),
                      if (i == 5) pw.Text("Role: ${experience.role}"),
                      if (i == 2) pw.Text("Hours: ${experience.hours}"),
                      if (i == 7) pw.Text("Score: ${experience.score}"),
                      if (i == 3) pw.Text("Issuer: ${experience.award}"),
                      if (i == 2) pw.Text("Location: ${experience.location}"),
                    ],
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

// Here, the pdf is actually made and saved to the device's directory
  Future<File> makePdf() async {
    String? name = prefs.getString('name');
    String? school = prefs.getString('school');
    String? year = prefs.getString('year');

    final pdf = pw.Document();

    for (int i = 0; i < 8; i++) {
      List<Experience> experiences = context.read<MyExperiences>().xpList[i];

      addPage(pdf, name, school, year, experiences, i);
    }
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/example.pdf');
    await tempFile.writeAsBytes(await pdf.save());
    return tempFile;
  }

// This method is similar to makePdf(), but is catered towards sharing with social media apps
// It has a custom message and shares the pdf as jpeg images
  void socialPdf() async {
    File pdf = await makePdf();
    debugPrint(pdf.path);
    List<XFile> tempFiles = [];

    final document = await pd.PdfDocument.openFile(pdf.path);
    for (int i = 1; i <= document.pagesCount; i++) {
      final page = await document.getPage(i);
      final pageImage = await page.render(
          width: page.width,
          height: page.height,
          format: pd.PdfPageImageFormat.jpeg);
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final tempFile = File('$tempPath/temp_$i.jpeg');
      await tempFile.writeAsBytes(pageImage!.bytes);
      await page.close();
      tempFiles.add(XFile(tempFile.path));
    }
    // This is the custom message that is sent to the chosen social media app
    await Share.shareXFiles(tempFiles, text: 'Check out my Accomplishments!');
  }

// Here, the pdf is created to be shared by Bluetooth or printed
  void createPdf(context) async {
    String? name = prefs.getString('name');
    String? school = prefs.getString('school');
    String? year = prefs.getString('year');

    final pdf = pw.Document();

    for (int i = 0; i < 8; i++) {
      List<Experience> experiences = context.read<MyExperiences>().xpList[i];

      addPage(pdf, name, school, year, experiences, i);
    }
    await Printing.sharePdf(bytes: await pdf.save(), filename: 'MyRise.pdf');
  }
}
