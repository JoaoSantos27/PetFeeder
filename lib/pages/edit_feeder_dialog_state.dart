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
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _esp32Controller;
  late TextEditingController _maxFood;
  late TextEditingController _maxWater;
  late File? newImageFile;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.feeder.name);
    _descriptionController = TextEditingController(text: widget.feeder.description);
    _esp32Controller = TextEditingController(text: widget.feeder.esp32);
    _maxFood = TextEditingController(text: widget.feeder.maxFoodLevel.toString());
    _maxWater = TextEditingController(text: widget.feeder.maxWaterLevel.toString());
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
              controller: _nameController,
              onChanged: (value) {
                setState(() {
                  widget.feeder.name = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              controller: _descriptionController,
              onChanged: (value) {
                setState(() {
                  widget.feeder.description = value;
                });
              },
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'ESP32 atSign'),
              controller: _esp32Controller,
              onChanged: (value) {
                setState(() {
                  widget.feeder.esp32 = value;
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Food container max weight (in grams)'),
              controller: _maxFood,
              onChanged: (value) {
                setState(() {
                  widget.feeder.maxFoodLevel = int.parse(value);
                });
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Water container max volume (in mililiters)'),
              controller: _maxWater,
              onChanged: (value) {
                setState(() {
                  widget.feeder.maxWaterLevel = int.parse(value);
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
            widget.onEdit(Feeder(widget.feeder.name, widget.feeder.description, widget.feeder.esp32, newImageFile, widget.feeder.maxFoodLevel, widget.feeder.maxWaterLevel));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
