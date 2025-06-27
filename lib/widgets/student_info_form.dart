import 'package:flutter/material.dart';
import '../models/student_info.dart';

class StudentInfoForm extends StatefulWidget {
  const StudentInfoForm({super.key});

  @override
  State<StudentInfoForm> createState() => _StudentInfoFormState();
}

class _StudentInfoFormState extends State<StudentInfoForm> {
  final _formKey = GlobalKey<FormState>();
  final info = StudentInfo.empty();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Name'),
            onSaved: (value) => info.name = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Roll Number'),
            onSaved: (value) => info.roll = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Batch'),
            onSaved: (value) => info.batch = value ?? '',
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Subject'),
            onSaved: (value) => info.subject = value ?? '',
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _formKey.currentState?.save();
              StudentInfo.current = info;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Info Saved')));
            },
            child: const Text('Save Info'),
          ),
        ],
      ),
    );
  }
}