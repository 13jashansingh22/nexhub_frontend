import 'package:flutter/material.dart';

class ComingSoonGameScreen extends StatelessWidget {
  final String title;
  const ComingSoonGameScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('Game Coming Soon!')),
    );
  }
}
