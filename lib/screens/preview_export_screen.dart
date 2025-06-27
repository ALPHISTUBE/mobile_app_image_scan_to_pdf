import 'package:flutter/material.dart';
import '../services/pdf_generator.dart';

class PreviewExportScreen extends StatelessWidget {
  const PreviewExportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preview & Export')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await PdfGenerator.generateAndSavePdf(context);
          },
          child: const Text('Generate & Save PDF'),
        ),
      ),
    );
  }
}