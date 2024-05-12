import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:untitled/pages/feeder.dart';

class EditFeederDialog extends StatefulWidget {
  final Feeder feeder;
  final void Function(Feeder editedFeeder) onEdit;

  const EditFeederDialog({Key? key, required this.feeder, required this.onEdit}) : super(key: key);

  @override
  _EditFeederDialogState createState() => _EditFeederDialogState();
}

class _EditFeederDialogState extends State<EditFeederDialog> {
  late String newName;
  late String newDescription;
  File? newImageFile;

  @override
  void initState() {
    super.initState();
    newName = widget.feeder.name;
    newDescription = widget.feeder.description;
    newImageFile = widget.feeder.imageFile;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Feeder'),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: 'Feeder Name'),
              onChanged: (value) {
                setState(() {
                  newName = value;
                });
              },
              controller: TextEditingController(text: widget.feeder.name),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                setState(() {
                  newDescription = value;
                });
              },
              controller: TextEditingController(text: widget.feeder.description),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final pickedFile =
                await ImagePicker().pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  setState(() {
                    newImageFile = File(pickedFile.path);
                  });
                }
              },
              child: const Text('Select Pet Photo'),
            ),
            if (newImageFile != null) // Display the selected image
              Column(
                children: [
                  const SizedBox(height: 10),
                  const Text('Photo Uploaded', style: TextStyle(color: Colors.green)),
                  Image.file(newImageFile!),
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
          child: const Text('Save'),
          onPressed: () {
            widget.onEdit(Feeder(newName, newDescription, newImageFile));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}