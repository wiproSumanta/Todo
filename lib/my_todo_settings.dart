import 'package:flutter/material.dart';

class TodoSettings extends StatelessWidget {
  final String title;
  const TodoSettings({super.key,  required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),

      ),
      body: Center(
        child: const Text("Nothing To Modify.."),
      ),
    );
  }
}
