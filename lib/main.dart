import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
    Feeder('Feeder 1', 'Main Feeder in the Living Room', null),
    Feeder('Feeder 2', 'Secondary Feeder in the Kitchen', null),
  ];

  File? _imageFile;

  void _addFeeder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String feederName = '';
        String feederDescription = '';
        return AlertDialog(
          title: Text('Add Feeder'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Feeder Name'),
                  onChanged: (value) {
                    feederName = value;
                  },
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    feederDescription = value;
                  },
                ),
                SizedBox(height: 20),
                _imageFile == null
                    ? ElevatedButton(
                        onPressed: _pickImage,
                        child: Text('Select Pet Photo'),
                      )
                    : Image.file(_imageFile!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _imageFile = null; // Reset image file after adding the feeder
                });
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                setState(() {
                  feeders
                      .add(Feeder(feederName, feederDescription, _imageFile));
                  _imageFile = null; // Reset image file after adding the feeder
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _editFeeder(Feeder feeder) {
    String newName = feeder.name;
    String newDescription = feeder.description;
    File? newImageFile = feeder.imageFile;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Feeder'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(labelText: 'Feeder Name'),
                  onChanged: (value) {
                    newName = value;
                  },
                  controller: TextEditingController(text: feeder.name),
                ),
                TextField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (value) {
                    newDescription = value;
                  },
                  controller: TextEditingController(text: feeder.description),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Select Photo'),
                ),
                if (newImageFile != null) Image.file(newImageFile),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _imageFile = null; // Reset image file after adding the feeder
                });
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                setState(() {
                  feeder.name = newName;
                  feeder.description = newDescription;
                  feeder.imageFile = _imageFile;
                  _imageFile = null; // Reset image file after adding the feeder
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
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
                  onPressed: () => _editFeeder(feeder),
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
        onPressed: _addFeeder,
        child: Icon(Icons.add),
        tooltip: 'Add a new feeder',
      ),
    );
  }
}
