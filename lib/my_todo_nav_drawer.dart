
import 'package:flutter/material.dart';

import 'my_todo_about.dart';
import 'my_todo_settings.dart';

class NavDrawer extends StatefulWidget {
  final Function addCallBack;
  const NavDrawer({super.key, required this.addCallBack});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: const Text(
              "Welcome in ToDo's",
              style: TextStyle(
                  color: Colors.orange,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            decoration: BoxDecoration(
                color: Colors.greenAccent[200],
                image: const DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        "https://img.freepik.com/free-photo/colorful-abstract-textured-background-design_53876-108265.jpg"))),
          ),
          ListTile(
            leading: const Icon(Icons.task),
            title: const Text("ToDo's"),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_task_sharp),
            title: const Text("Add ToDo"),
            onTap: () {
              Navigator.of(context).pop();
              widget.addCallBack();
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                      const TodoSettings(title: "Setting")));
            },
          ),
          ListTile(
            leading: const Icon(Icons.article),
            title: const Text("About"),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const TodoAbout(title: "About")));
            },
          )
        ],
      ),
    );
  }
}
