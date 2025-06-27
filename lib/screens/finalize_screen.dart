import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/pdf_generator.dart';
import '../services/scanner_service.dart';
import '../models/student_info.dart';

class FinalizeScreen extends StatefulWidget {
  const FinalizeScreen({super.key});

  @override
  State<FinalizeScreen> createState() => _FinalizeScreenState();
}

class _FinalizeScreenState extends State<FinalizeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final rollController = TextEditingController();
  final batchController = TextEditingController();
  final subjectController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  void _loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      rollController.text = prefs.getString('roll') ?? '';
      batchController.text = prefs.getString('batch') ?? '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    batchController.dispose();
    subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Finalize Assignment')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: ScannerService.scannedPaths.length,
                itemBuilder: (context, index) {
                  final path = ScannerService.scannedPaths[index];
                  return Image.file(File(path), width: 100, fit: BoxFit.cover);
                },
                separatorBuilder: (_, __) => const SizedBox(width: 8),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: rollController,
                      decoration: const InputDecoration(labelText: 'Roll Number'),
                    ),
                    TextFormField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: 'Batch'),
                    ),
                    TextFormField(
                      controller: subjectController,
                      decoration: const InputDecoration(labelText: 'Subject'),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                StudentInfo.current = StudentInfo(
                  name: nameController.text,
                  roll: rollController.text,
                  batch: batchController.text,
                  subject: subjectController.text,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Saved: ${nameController.text}, Roll: ${rollController.text}')),
                );

                await PdfGenerator.generateAndSavePdf(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Generate and Save PDF'),
            ),
          ],
        ),
      ),
    );
  }
}
