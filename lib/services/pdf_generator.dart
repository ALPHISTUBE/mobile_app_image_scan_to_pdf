import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'scanner_service.dart';
import '../models/student_info.dart';

class PdfGenerator {
  static Future<void> generateAndSavePdf(BuildContext context) async {
    final pdf = pw.Document();
    final info = StudentInfo.current;

    print('Generating PDF for: ${info.name}, ${info.roll}, ${info.batch}, ${info.subject}');
    print('Scanned pages: ${ScannerService.scannedPaths.length}');

    // Cover Page
    pdf.addPage(
      pw.Page(
        margin: const pw.EdgeInsets.all(40), // optional: you can reduce or remove this
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, // ✅ Align text to the left
          mainAxisAlignment: pw.MainAxisAlignment.center,
          children: [
            pw.Text('Name: ${info.name}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 12),
            pw.Text('Roll: ${info.roll}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 12),
            pw.Text('Batch: ${info.batch}', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 12),
            pw.Text('Subject: ${info.subject}', style: pw.TextStyle(fontSize: 24)),
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
          margin: pw.EdgeInsets.zero, // ✅ Remove all page margins
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
      final safeSubject = info.subject.replaceAll(' ', '_');
      outputPath = '${dir.path}/${safeName}_${info.roll}_${safeSubject}_${DateTime.now().millisecondsSinceEpoch}.pdf';

      await File(outputPath).writeAsBytes(bytes);
    }

    // Save path to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    List<String> paths = prefs.getStringList('pdf_paths') ?? [];
    paths.add(outputPath);
    await prefs.setStringList('pdf_paths', paths);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('PDF saved at: $outputPath')));
    print('PDF saved successfully at: $outputPath');
  }
}
