import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import 'scanner_service.dart';
import '../models/student_info.dart';

class PdfGenerator {
  static Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();
    final info = StudentInfo.current;

    print('Generating PDF for: ${info.name}, ${info.registrationId}, ${info.program}, ${info.batch}, ${info.roll}, ${info.courseName}');
    print('Scanned pages: ${ScannerService.scannedPaths.length}');

    // Cover Page
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Name: ${info.name}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text('Registration ID: ${info.registrationId}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text('Program: ${info.program}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text('Batch: ${info.batch}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text('Roll Number: ${info.roll}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 10),
            pw.Text('Course Name: ${info.courseName}', style: pw.TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );

    // Scanned Pages
    for (var path in ScannerService.scannedPaths) {
      final image = pw.MemoryImage(File(path).readAsBytesSync());
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: pw.EdgeInsets.zero,
          build: (_) => pw.Image(
            image,
            fit: pw.BoxFit.fill,
            width: PdfPageFormat.a4.width,
            height: PdfPageFormat.a4.height,
          ),
        ),
      );
    }

    final bytes = await pdf.save();

    String outputPath;

    if (kIsWeb || Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      print('Using File Picker for desktop...');
      outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save your assignment PDF',
        fileName: 'assignment_${DateTime.now().millisecondsSinceEpoch}.pdf',
        allowedExtensions: ['pdf'],
        type: FileType.custom,
      ) ?? '';

      if (outputPath.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save cancelled')));
        return;
      }

      await File(outputPath).writeAsBytes(bytes);
    } else {
      print('Using Downloads folder for Android/iOS...');
      final dir = Directory('/storage/emulated/0/Download');
      if (!await dir.exists()) await dir.create(recursive: true);

      final safeName = info.name.replaceAll(' ', '_');
      final safeCourse = info.courseName.replaceAll(' ', '_');
      final safeRegId = info.registrationId.replaceAll(RegExp(r'[^\w\d]+'), '_');

      outputPath = '${dir.path}/${safeName}_${safeRegId}_${safeCourse}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await File(outputPath).writeAsBytes(bytes);
    }

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    List<String> paths = prefs.getStringList('pdf_paths') ?? [];
    paths.add(outputPath);
    await prefs.setStringList('pdf_paths', paths);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved at: $outputPath')));
    print('PDF saved successfully at: $outputPath');
  }
}
