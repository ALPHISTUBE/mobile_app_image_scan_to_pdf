import 'package:flutter/material.dart';
import 'dart:io';

class ScannedPageTile extends StatelessWidget {
  final String path;
  const ScannedPageTile({required this.path, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.file(File(path), width: 50),
      title: Text(path.split('/').last),
    );
  }
}