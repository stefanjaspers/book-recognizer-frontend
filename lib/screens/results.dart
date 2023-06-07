import 'package:flutter/material.dart';

class ResultsScreen extends StatefulWidget {
  final String responseBody;

  const ResultsScreen({required this.responseBody, super.key});

  @override
  State<StatefulWidget> createState() {
    return _ResultsScreenState();
  }
}

class _ResultsScreenState extends State<ResultsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Results Screen"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text("Response body: ${widget.responseBody}"),
      ),
    );
  }
}
