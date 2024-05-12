import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFeederDialog extends StatefulWidget {
  final void Function(String name, String description, File? image) onAdd;

  const AddFeederDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddFeederDialogState createState() => _AddFeederDialogState();
}

class _AddFeederDialogState extends State<AddFeederDialog> {
  String feederName = '';
  String feederDescription = '';
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Feeder'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Feeder Name'),
              onChanged: (value) {
                setState(() {
                  feederName = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  feederDescription = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    imageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Text('Select Pet Photo'),
            ),
            if (imageFile != null) // Display the selected image
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Photo Uploaded', style: TextStyle(color: Colors.green)),
                  Image.file(imageFile!),
                ],
              )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Add'),
          onPressed: () {
            widget.onAdd(feederName, feederDescription, imageFile);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
