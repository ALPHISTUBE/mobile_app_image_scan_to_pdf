import 'package:flutter/material.dart';
import '../services/scanner_service.dart';

class ScanScreen extends StatelessWidget {
  const ScanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Pages')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await ScannerService.scanPages(context);
          },
          child: const Text('Start Scanning'),
        ),
      ),
    );
  }
}