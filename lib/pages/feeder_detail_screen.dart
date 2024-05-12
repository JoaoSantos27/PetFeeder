import 'package:flutter/material.dart';
import 'feeder.dart';

class FeederDetailScreen extends StatelessWidget {
  final Feeder feeder;

  const FeederDetailScreen({super.key, required this.feeder});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feeder Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Image displayed to the left
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: feeder.imageFile != null
                        ? DecorationImage(
                      image: FileImage(feeder.imageFile!),
                      fit: BoxFit.cover,
                    )
                        : const DecorationImage(
                      image: AssetImage('assets/images/placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16), // Add some spacing between the image and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name: ${feeder.name}',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Description: ${feeder.description}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // Add space between the text and the button
            // Button to dispense food
            SizedBox(
              width: double.infinity, // Set width to fill the available space horizontally
              child: ElevatedButton(
                onPressed: () {
                  // Handle the dispense food action here
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green), // Set button background color
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Set button text color
                ),
                child: const Text(
                  'Dispense Food Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
