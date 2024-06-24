import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:pdfx/pdfx.dart' as pd;
import 'my_app_state.dart';
import 'profile/experience.dart';
import 'theme.dart';

// This is the home page of the app
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Experience? recent;

  // This method compares the times of experiences to get the most recent one
  void getRecent() {
    DateTime mostRecentUpdateTime = DateTime.utc(0);
    Experience? mostRecent;
    for (List<Experience> categoryList
        in context.read<MyAppState>().appUser.xpList) {
      for (Experience xp in categoryList) {
        if (mostRecentUpdateTime.isBefore(xp.updateTime) && !xp.editable) {
          mostRecentUpdateTime = xp.updateTime;
          mostRecent = xp;
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
  Widget build(BuildContext context) {
    getRecent();

    String name = context.watch<MyAppState>().appUser.name;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // The home page's welcome message
            Container(
              color: Theme.of(context).colorScheme.secondary,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      'Welcome',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 25, bottom: 20),
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: name.substring(
                                0,
                                (name.contains(" "))
                                    ? name.indexOf(" ")
                                    : name.length),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(color: Colors.white),
                          ),
                          TextSpan(
                            text: ".",
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                    color: Theme.of(context).primaryColor),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Here, to most recently updated experience is shown
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Highlights",
                  style: Theme.of(context).textTheme.headlineLarge),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: ElevatedButton(
                  onPressed: () {},
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: (recent != null)
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                items.keys.toList()[recent!.tileIndex],
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    recent!.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      "${recent!.startDate} - ${recent!.endDate}",
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : const Text(
                            "Add an experience in the profile page to get started.",
                            textAlign: TextAlign.left,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),

            // This section of the code uses the sharePlus and pdfx packages to save the profile as a pdf or share it to social media
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text("Share",
                      style: Theme.of(context).textTheme.headlineLarge),
                ),
                const Spacer(),
                FloatingActionButton.large(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => makePdf(context, true),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "PDF",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
                FloatingActionButton.large(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  onPressed: () => socialPdf(context),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Image",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

// This is the method that creates the look of a pdf page that is shared
  void addPage(
    pw.Document pdf,
    String name,
    String school,
    String year,
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
                      name,
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
                        items.keys.toList()[experience.tileIndex],
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
  Future<dynamic> makePdf(BuildContext context, bool returnPdf) async {
    String name = context.read<MyAppState>().appUser.name;
    String school = context.read<MyAppState>().appUser.school;
    String year = context.read<MyAppState>().appUser.year.toString();

    final pdf = pw.Document();

    for (int i = 0; i < 8; i++) {
      List<Experience> experiences =
          context.read<MyAppState>().appUser.xpList[i];

      if (experiences.isNotEmpty) {
        addPage(pdf, name, school, year, experiences, i);
      }
    }
    if (returnPdf) {
      await Printing.sharePdf(bytes: await pdf.save(), filename: 'MyRise.pdf');
    } else {
      final tempDir = await getTemporaryDirectory();
      final tempPath = tempDir.path;
      final tempFile = File('$tempPath/example.pdf');
      await tempFile.writeAsBytes(await pdf.save());
      return tempFile;
    }
  }

// This method is similar to makePdf(), but is catered towards sharing with social media apps
// It has a custom message and shares the pdf as jpeg images
  void socialPdf(BuildContext context) async {
    File pdf = await makePdf(context, false);
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
}
