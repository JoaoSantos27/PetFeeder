import 'package:flutter/material.dart';
import 'package:untitled/pages/feeder.dart';
import 'package:untitled/pages/feeder_detail_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FeederListScreen(),
    );
  }
}

class FeederListScreen extends StatefulWidget {
  @override
  _FeederListScreenState createState() => _FeederListScreenState();
}

class _FeederListScreenState extends State<FeederListScreen> {
  List<Feeder> feeders = [
    Feeder('Feeder 1', 'Main Feeder in the Living Room'),
    Feeder('Feeder 2', 'Secondary Feeder in the Kitchen'),
  ];

  void _addFeeder() {
    setState(() {
      feeders.add(Feeder('Feeder ${feeders.length + 1}', 'Newly Added Feeder'));
    });
  }

  void _navigateToFeederDetail(Feeder feeder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FeederDetailScreen(feeder: feeder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pet Feeders'),
      ),
      body: ListView.builder(
        itemCount: feeders.length,
        itemBuilder: (context, index) {
          final feeder = feeders[index];
          return ListTile(
            title: Text(feeder.name),
            subtitle: Text(feeder.description),
            onTap: () => _navigateToFeederDetail(feeder),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addFeeder,
        child: Icon(Icons.add),
        tooltip: 'Add a new feeder',
      ),
    );
  }
}