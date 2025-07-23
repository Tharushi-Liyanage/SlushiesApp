import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "Slushies Juice Maker\n\nCreated for the RAD project.\nThis app allows remote juice ordering, customization, and cashless payments via a smart machine.",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
