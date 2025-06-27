import 'package:flutter/material.dart';
import 'package:cunning_document_scanner/cunning_document_scanner.dart';

class ScannerService {
  static List<String> scannedPaths = [];

  static Future<void> scanPages(BuildContext context) async {
    final images = await CunningDocumentScanner.getPictures();
    if (images != null) {
      scannedPaths = images;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Scanned ${images.length} pages')),
      );
    }
  }
}