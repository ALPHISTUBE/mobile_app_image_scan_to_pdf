import 'package:flutter/material.dart';
import 'form_screen.dart';
import 'scan_screen.dart';
import 'preview_export_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Assignment Scanner')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormScreen())),
              child: const Text('Enter Student Info'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ScanScreen())),
              child: const Text('Scan Assignment Pages'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PreviewExportScreen())),
              child: const Text('Preview & Export PDF'),
            ),
          ],
        ),
      ),
    );
  }
}