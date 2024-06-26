// This is the method that creates the look of a pdf page that is shared
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import 'package:pdfx/pdfx.dart' as pd;
import 'my_app_state.dart';
import 'profile/experience.dart';
import 'theme.dart';

// Here, the pdf is actually made and saved to the device's directory
final PdfColor secondaryColor =
    PdfColor.fromInt(const Color.fromARGB(255, 20, 49, 92).value);
final PdfColor primaryColor =
    PdfColor.fromInt(const Color.fromARGB(255, 218, 124, 96).value);

// This is the method that creates a pdf resume
Future<dynamic> makePdf(BuildContext context, bool returnPdf) async {
  final pdf = pw.Document();

  final appState = context.read<MyAppState>();
  final user = appState.appUser;

  // These are the fonts used in the resume
  final font = await PdfGoogleFonts.montserratRegular();
  final boldFont = await PdfGoogleFonts.montserratSemiBold();

  // By using MultiPage, space is automatically optimized and new pages are created as necessary
  pdf.addPage(pw.MultiPage(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(32),
    build: (context) => [
      buildHeader(user.name, user.school, user.year.toString(), font, boldFont,
          appState.appUser.pfp),
      buildExperienceSection(appState, font, boldFont),
    ],
  ));

  // The pdf is either sent to be shared or returned as a file
  if (returnPdf) {
    await Printing.sharePdf(
        bytes: await pdf.save(), filename: 'MyRise_Resume.pdf');
  } else {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    final tempFile = File('$tempPath/MyRise_Resume.pdf');
    await tempFile.writeAsBytes(await pdf.save());
    return tempFile;
  }
}

// This is the method that builds the pdf header
pw.Widget buildHeader(
  String name,
  String school,
  String year,
  pw.Font font,
  pw.Font boldFont,
  File? profileImageFile,
) {
  // If provided, the profile picture is used in the header
  Uint8List? profileImage;
  if (profileImageFile != null && profileImageFile.existsSync()) {
    profileImage = profileImageFile.readAsBytesSync();
  }

  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      if (profileImage != null)
        pw.Container(
          width: 80,
          height: 80,
          margin: const pw.EdgeInsets.only(right: 16),
          child: pw.ClipOval(
            child: pw.Image(pw.MemoryImage(profileImage), fit: pw.BoxFit.cover),
          ),
        ),
      pw.Expanded(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              name,
              style: pw.TextStyle(
                  font: boldFont, fontSize: 24, color: secondaryColor),
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              school,
              style:
                  pw.TextStyle(font: font, fontSize: 16, color: primaryColor),
            ),
            pw.Text(
              'Class of $year',
              style:
                  pw.TextStyle(font: font, fontSize: 16, color: primaryColor),
            ),
          ],
        ),
      ),
    ],
  );
}

// This is the method to create an entire experience section
pw.Widget buildExperienceSection(
    MyAppState appState, pw.Font font, pw.Font boldFont) {
  final widgets = <pw.Widget>[];

  for (int i = 0; i < 8; i++) {
    final experiences = appState.appUser.xpList[i];
    if (experiences.isNotEmpty) {
      widgets.add(
        pw.Header(
          level: 1,
          text: items.keys.toList()[i],
          textStyle:
              pw.TextStyle(font: boldFont, fontSize: 18, color: secondaryColor),
        ),
      );
      widgets.add(pw.SizedBox(height: 8));

      for (var experience in experiences) {
        if (!experience.editable) {
          widgets.add(buildExperienceItem(experience, i, font, boldFont));
          widgets.add(pw.SizedBox(height: 12));
        }
      }
    }
  }

  return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start, children: widgets);
}

// This is the method to create a single experience item
pw.Widget buildExperienceItem(
    Experience experience, int categoryIndex, pw.Font font, pw.Font boldFont) {
  return pw.Padding(
      padding: const pw.EdgeInsets.only(left: 5),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            (categoryIndex == 2)
                ? "Community Service at ${experience.location}"
                : experience.name,
            style:
                pw.TextStyle(font: boldFont, fontSize: 14, color: primaryColor),
          ),
          pw.Text(
            '${experience.startDate} - ${experience.endDate}',
            style:
                pw.TextStyle(font: font, fontSize: 12, color: secondaryColor),
          ),
          pw.SizedBox(height: 4),
          if (categoryIndex != 7 &&
              categoryIndex != 4 &&
              experience.description.isNotEmpty)
            pw.Text(experience.description,
                style: pw.TextStyle(font: font, fontSize: 12)),
          if (categoryIndex == 4)
            pw.Text("Grade: ${experience.grade}",
                style: pw.TextStyle(font: font, fontSize: 12)),
          if (categoryIndex == 5)
            pw.Text("Role: ${experience.role}",
                style: pw.TextStyle(font: font, fontSize: 12)),
          if (categoryIndex == 2)
            pw.Text("Hours: ${experience.hours}",
                style: pw.TextStyle(font: font, fontSize: 12)),
          if (categoryIndex == 7)
            pw.Text("Score: ${experience.score}",
                style: pw.TextStyle(font: font, fontSize: 12)),
          if (categoryIndex == 3 && experience.award.isNotEmpty)
            pw.Text("Issuer: ${experience.award}",
                style: pw.TextStyle(font: font, fontSize: 12)),
        ],
      ));
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
  await Share.shareXFiles(tempFiles, text: 'Check out my Resume!');
}
