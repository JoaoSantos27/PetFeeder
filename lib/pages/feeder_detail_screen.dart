import 'package:flutter/material.dart';
import 'feeder.dart';

class FeederDetailScreen extends StatelessWidget {
  final Feeder feeder;

  FeederDetailScreen({required this.feeder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feeder Details'),
      ),
      body: Center(
        child: Text(
          'Feeder Name: ${feeder.name}',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}