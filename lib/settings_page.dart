import 'package:flutter/material.dart';
import 'package:mobileapp/main.dart';
import 'package:provider/provider.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({
    super.key,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: context.read<MyAppState>().nameController,
            ),
          ],
        ),
      ),
    );
  }
}
