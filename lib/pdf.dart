import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> makePdf() async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (pw.Context context) {
        return pw.Column(
          children: [
            pw.Text("Ria", style: const pw.TextStyle(fontSize: 24)),
            pw.Text("Woodinville High School", style: const pw.TextStyle(fontSize: 20)),
            pw.Text("Class of 2025", style: const pw.TextStyle(fontSize: 20)),
          ]
        );
      }
    ),
  );
  return pdf.save();
}