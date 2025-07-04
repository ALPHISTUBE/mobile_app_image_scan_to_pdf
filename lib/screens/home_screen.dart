import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/scanner_service.dart';
import 'finalize_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<File> _pdfFiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSavedPdfFiles();
  }

  Future<void> _loadSavedPdfFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final paths = prefs.getStringList('pdf_paths') ?? [];
    final files = paths.map((path) => File(path)).where((file) => file.existsSync()).toList();

    setState(() {
      _pdfFiles = files;
      _isLoading = false;
    });
  }

  void _startScanningFlow() async {
    await ScannerService.scanPages(context);
    if (mounted && ScannerService.scannedPaths.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const FinalizeScreen(),
        ),
      ).then((_) => _loadSavedPdfFiles());
    }
  }

  void _editDefaultStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();

    final controllerName = TextEditingController(text: prefs.getString('name') ?? '');
    final controllerRegId = TextEditingController(text: prefs.getString('registrationId') ?? '');
    final controllerProgram = TextEditingController(text: prefs.getString('program') ?? '');
    final controllerBatch = TextEditingController(text: prefs.getString('batch') ?? '');
    final controllerRoll = TextEditingController(text: prefs.getString('roll') ?? '');

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Default Student Info'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controllerName, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: controllerRegId, decoration: const InputDecoration(labelText: 'Registration ID')),
              TextField(controller: controllerProgram, decoration: const InputDecoration(labelText: 'Program')),
              TextField(controller: controllerBatch, decoration: const InputDecoration(labelText: 'Batch')),
              TextField(controller: controllerRoll, decoration: const InputDecoration(labelText: 'Roll Number')),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              await prefs.setString('name', controllerName.text);
              await prefs.setString('registrationId', controllerRegId.text);
              await prefs.setString('program', controllerProgram.text);
              await prefs.setString('batch', controllerBatch.text);
              await prefs.setString('roll', controllerRoll.text);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }



  void _openPdf(File file) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Open PDF: ${file.path}')),
    );
    // Add logic to open file if needed
  }

  String formatBytes(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '$bytes B';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PaperSnap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editDefaultStudentInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _pdfFiles.isEmpty
                ? const Center(child: Text('No exported PDFs yet.'))
                : ListView.builder(
              itemCount: _pdfFiles.length,
              itemBuilder: (context, index) {
                final file = _pdfFiles[index];
                final fileName = file.path.split('/').last;
                final fileSize = file.lengthSync();

                return ListTile(
                  leading: const Icon(Icons.picture_as_pdf),
                  title: Text(fileName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Size: ${formatBytes(fileSize)}'),
                      Text('Path: ${file.path}', style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () => _openPdf(file),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Created by WUB Alphi 70B 4688',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startScanningFlow,
        child: const Icon(Icons.add),
      ),
    );
  }
}
