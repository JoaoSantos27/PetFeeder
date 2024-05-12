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
        return EditFeederDialog(
            feeder: feeder,
            onEdit: (editedFeeder) => _editFeeder(feeder, editedFeeder));
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
        itemBuilder: (BuildContext context, int index) {
          Feeder feeder = feeders[index];
          return Container(
              height: 100, // Set a fixed height for each ListTile
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                // Adjust the padding to increase the item size
                leading: Container(
                  width: 60, // Adjust the width of the image container
                  height: 60, // Adjust the height of the image container
                  child: feeder.imageFile != null
                      ? Image.file(feeder.imageFile!, fit: BoxFit.cover)
                      : null, // Display photo if available
                ),
                title: Text(
                  feeder.name,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold), // Increase font size of the title
                ),
                subtitle: Text(
                  feeder.description,
                  style: TextStyle(
                      fontSize: 16), // Increase font size of the subtitle
                ),
                onTap: () {
                  // Handle onTap event for editing the feeder
                  _navigateToFeederDetail(feeder);
                },
                trailing: PopupMenuButton(
                  itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit'),
                        onTap: () {
                          Navigator.pop(context);
                          _showEditFeederDialog(feeder);
                        },
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.delete),
                        title: const Text('Delete'),
                        onTap: () {
                          Navigator.pop(context);
                          _deleteFeeder(feeder);
                        },
                      ),
                    ),
                  ],
                ),
              ));
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
