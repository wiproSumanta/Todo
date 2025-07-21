import 'package:flutter/material.dart';

class TodoSettings extends StatelessWidget {
  final String title;
  const TodoSettings({super.key,  required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onSecondary,
      ),
      body: Center(
        child: const Text("Nothing To Modify.."),
      ),
    );
  }
}
