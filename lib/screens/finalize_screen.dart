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
  final regIdController = TextEditingController();
  final programController = TextEditingController();
  final batchController = TextEditingController();
  final rollController = TextEditingController();
  final courseNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadStudentInfo();
  }

  void _loadStudentInfo() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      regIdController.text = prefs.getString('registrationId') ?? '';
      programController.text = prefs.getString('program') ?? '';
      batchController.text = prefs.getString('batch') ?? '';
      rollController.text = prefs.getString('roll') ?? '';
      courseNameController.text = prefs.getString('courseName') ?? '';
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    regIdController.dispose();
    programController.dispose();
    batchController.dispose();
    rollController.dispose();
    courseNameController.dispose();
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
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                    ),
                    TextFormField(
                      controller: regIdController,
                      decoration: const InputDecoration(labelText: 'Registration ID'),
                    ),
                    TextFormField(
                      controller: programController,
                      decoration: const InputDecoration(labelText: 'Program'),
                    ),
                    TextFormField(
                      controller: batchController,
                      decoration: const InputDecoration(labelText: 'Batch'),
                    ),
                    TextFormField(
                      controller: rollController,
                      decoration: const InputDecoration(labelText: 'Roll Number'),
                    ),
                    TextFormField(
                      controller: courseNameController,
                      decoration: const InputDecoration(labelText: 'Course Name'),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Save input data to model
                StudentInfo.current = StudentInfo(
                  name: nameController.text,
                  registrationId: regIdController.text,
                  program: programController.text,
                  batch: batchController.text,
                  roll: rollController.text,
                  courseName: courseNameController.text,
                );

                // Persist data for next time
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('name', nameController.text);
                await prefs.setString('registrationId', regIdController.text);
                await prefs.setString('program', programController.text);
                await prefs.setString('batch', batchController.text);
                await prefs.setString('roll', rollController.text);
                await prefs.setString('courseName', courseNameController.text);

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
