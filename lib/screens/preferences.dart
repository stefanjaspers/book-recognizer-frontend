import 'package:flutter/material.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PreferencesScreen();
  }
}

class _PreferencesScreen extends State<PreferencesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: Text("Preferences")),
    );
  }
}
