import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/pages/add_feeder_dialog_state.dart';
import 'package:untitled/pages/edit_feeder_dialog_state.dart';
import 'package:untitled/pages/feeder.dart';
import 'package:untitled/pages/feeder_detail_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FeederListScreen(),
    );
  }
}

class FeederListScreen extends StatefulWidget {
  const FeederListScreen({super.key});

  @override
  _FeederListScreenState createState() => _FeederListScreenState();
}

class _FeederListScreenState extends State<FeederListScreen> {
  List<Feeder> feeders = [
    Feeder('Feeder 1', 'Main Feeder in the Living Room', null),
    Feeder('Feeder 2', 'Secondary Feeder in the Kitchen', null),
  ];

  void _addFeeder(String name, String description, File? image) {
    setState(() {
      feeders.add(Feeder(name, description, image));
    });
  }

  void _showAddFeederDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AddFeederDialog(onAdd: _addFeeder);
      },
    );
  }

  void _editFeeder(Feeder oldFeeder, Feeder editedFeeder) {
    setState(() {
      // Find and update the edited feeder in the list
      final index = feeders.indexOf(oldFeeder);
      if (index != -1) {
        feeders[index] = editedFeeder;
      }
    });
  }

  void _showEditFeederDialog(Feeder feeder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditFeederDialog(feeder: feeder, onEdit: (editedFeeder) => _editFeeder(feeder, editedFeeder));
      },
    );
  }

  void _deleteFeeder(Feeder feeder) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this feeder?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                setState(() {
                  feeders.remove(feeder); // Delete the feeder
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
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
        backgroundColor: Colors.green, // Set the background color to green
        title: Text(
          'Pet Feeders',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            fontWeight: FontWeight.bold, // Set the text to be bold
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: feeders.length,
        itemBuilder: (context, index) {
          final feeder = feeders[index];
          return ListTile(
            title: Text(feeder.name),
            subtitle: Text(feeder.description),
            onTap: () => _navigateToFeederDetail(feeder),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _showEditFeederDialog(feeder),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteFeeder(feeder),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddFeederDialog,
        child: Icon(Icons.add),
        tooltip: 'Add a new feeder',
      ),
    );
  }
}
