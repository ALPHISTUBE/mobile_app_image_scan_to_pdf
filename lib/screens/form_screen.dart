import 'package:flutter/material.dart';
import '../widgets/student_info_form.dart';

class FormScreen extends StatelessWidget {
  const FormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Information')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: StudentInfoForm(),
      ),
    );
  }
}