import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'scanner_service.dart';
import '../models/student_info.dart';

import 'package:file_picker/file_picker.dart'; // add this

class PdfGenerator {
  static Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();
    final info = StudentInfo.current;

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Center(
          child: pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text('Assignment', style: pw.TextStyle(fontSize: 24)),
              pw.SizedBox(height: 20),
              pw.Text('Name: ${info.name}'),
              pw.Text('Roll: ${info.roll}'),
              pw.Text('Batch: ${info.batch}'),
              pw.Text('Subject: ${info.subject}'),
            ],
          ),
        ),
      ),
    );

    for (var path in ScannerService.scannedPaths) {
      final image = pw.MemoryImage(File(path).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          build: (context) => pw.Center(child: pw.Image(image)),
        ),
      );
    }

    // 📂 Let user choose where to save
    String? outputPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save your assignment PDF',
      fileName: 'assignment.pdf',
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (outputPath != null) {
      final file = File(outputPath);
      await file.writeAsBytes(await pdf.save());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF saved at ${file.path}')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Save cancelled')),
      );
    }
  }
}
