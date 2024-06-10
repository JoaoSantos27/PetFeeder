import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddFeederDialog extends StatefulWidget {
  final void Function(String name, String description, String esp32, File? image/*, int maxFood,
      int maxWater*/) onAdd;

  const AddFeederDialog({Key? key, required this.onAdd}) : super(key: key);

  @override
  _AddFeederDialogState createState() => _AddFeederDialogState();
}

class _AddFeederDialogState extends State<AddFeederDialog> {
  String feederName = '';
  String feederDescription = '';
  String feederESP32 = '';
  File? imageFile;
  //int feederMaxFood = 0;
  //int feederMaxWater = 0;

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
            TextField(
              decoration: const InputDecoration(labelText: 'ESP32 atSign'),
              onChanged: (value) {
                setState(() {
                  feederESP32 = value;
                });
              },
            ),
            /*
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Food container max weight (in grams)',
              ),
              onChanged: (value) {
                // Handle onChanged event to update time interval
                // Convert the string value to double and update the feeder
                setState(() {
                  feederMaxFood = int.parse(value);
                });
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Water container max volume (in mililiters)',
              ),
              onChanged: (value) {
                // Handle onChanged event to update time interval
                // Convert the string value to double and update the feeder
                setState(() {
                  feederMaxWater = int.parse(value);
                });
              },
            ),*/
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
                  const Text('Photo Uploaded',
                      style: TextStyle(color: Colors.green)),
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
            widget.onAdd(feederName, feederDescription, feederESP32, imageFile/*,
                feederMaxFood, feederMaxWater*/);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
