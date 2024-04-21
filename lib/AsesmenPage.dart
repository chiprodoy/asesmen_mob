import 'package:flutter/material.dart';

class AsesmenPage extends StatelessWidget {
  final String studentName;

  const AsesmenPage(this.studentName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Asesmen $studentName'),
      ),
      body: Center(
        child: Text('This is the Asesmen Page for $studentName'),
      ),
    );
  }
}