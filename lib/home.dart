import 'package:flutter/material.dart';
import 'package:mobileapp/pdf.dart';
import 'package:printing/printing.dart';

class HomePage extends StatelessWidget{
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PdfPreview(
        build: (context) => makePdf(),
      ),
    );
  }
}