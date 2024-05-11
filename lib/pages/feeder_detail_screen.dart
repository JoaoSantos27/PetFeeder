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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
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
                if (feeder.imageFile != null) // Display image if available
                  Container(
                    height: 500, // Set the maximum height
                    width: double.infinity, // Set the maximum width
                    child: Image.file(
                      feeder.imageFile!,
                      fit: BoxFit.cover, // Adjusts the size of the image to cover the entire container
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
