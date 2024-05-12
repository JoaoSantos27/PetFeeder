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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image displayed to the left
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: feeder.imageFile != null ? DecorationImage(
                  image: FileImage(feeder.imageFile!),
                  fit: BoxFit.cover,
                ) : null, // Set image to null if feeder.imageFile is null
              ),
            ),
            SizedBox(width: 16), // Add some spacing between the image and text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name: ${feeder.name}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Description: ${feeder.description}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
