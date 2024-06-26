import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:flutter/material.dart';

import 'feeder.dart';

class FeederDetailScreen extends StatefulWidget {
  final Feeder feeder;

  const FeederDetailScreen({super.key, required this.feeder});

  @override
  _FeederDetailScreenState createState() => _FeederDetailScreenState();
}

class _FeederDetailScreenState extends State<FeederDetailScreen> {
  late Feeder feeder;
  late AtClientManager atClientManager;
  late AtClient atClient;
  late String esp32;
  late String flutter;

  late AtKey sharedWithESP32;
  late AtKey sharedWithUs;


  @override
  void initState() {
    super.initState();
    feeder = widget.feeder;
    atClientManager = AtClientManager.getInstance();
    atClient = atClientManager.atClient;
    esp32 = feeder.esp32;
    flutter = atClient.getCurrentAtSign()!;

    // put key
    // @esp32:num.soccer0@flutter
    sharedWithESP32 = AtKey()
      ..sharedWith = esp32
      ..key = 'num'
      ..namespace = 'soccer0'
      ..sharedBy = flutter
    ;

    // get key
    // @flutter:num.soccer0@esp32
    sharedWithUs = AtKey()
      ..sharedWith = flutter
      ..key = 'num'
      ..namespace = 'soccer0'
      ..sharedBy = esp32
    ;
    receiveESPData();
  }


  void receiveESPData() async {
    while (true) {
      try {
        String? token = (await atClient.get(sharedWithUs)).value;
        if (token != null) {
          List<String> data = token.split(":");
          if (data.length == 2) {
            setState(() {
              switch (data.first) {
                case "maxFoodLevel":
                  feeder.maxFoodLevel = int.parse(data.last);
                  break;
                case "foodLevel":
                  feeder.foodLevel = int.parse(data.last);
                  break;
                default:
                  break;
              }
            });
          }
        }
      } catch (e) {
        print("Error receiving data: $e");
      }
      await Future.delayed(const Duration(seconds: 5)); // Delay to prevent tight loop
    }
  }

  @override
  Widget build(BuildContext context) {

    // Calculate the percentage of food and water remaining
    double foodPercentage;
    if(feeder.maxFoodLevel == 0) {
      foodPercentage = feeder.foodLevel / 1;
    } else {
      foodPercentage = feeder.foodLevel / feeder.maxFoodLevel;
    }
    //double waterPercentage = feeder.waterLevel / feeder.maxWaterLevel;

    double newTimeInterval = feeder.timeInterval;
    int newFoodAmount = feeder.foodAmount;

    // Determine the color of the progress indicators based on the percentage
    Color foodColor = _getProgressColor(foodPercentage);
    //Color waterColor = _getProgressColor(waterPercentage);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text(
          'Feeder Details',
          style: TextStyle(
            color: Colors.white, // Set the text color to white
            // Set the text to be bold
          ),
        ),
        iconTheme:
            const IconThemeData(color: Colors.white), // Change the color to red
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
                const SizedBox(width: 16),
                // Add some spacing between the image and text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Name: ${feeder.name}',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
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
            const SizedBox(height: 20),
            // Add space between the text and the button
            // Food level indicator
            _buildLevelIndicator(
                'Food Container Level', foodPercentage, foodColor, feeder.maxFoodLevel, 'grams'),
            /*const SizedBox(height: 10),
            // Add some spacing between the indicators
            // Water level indicator
            _buildLevelIndicator(
                'Water Container Level', waterPercentage, waterColor, feeder.maxWaterLevel, 'mililiters'),*/
            const SizedBox(height: 20),
            // Add space between the indicators and the button
            // Button to dispense food
            const SizedBox(height: 20),
            // Add a text field for setting the time interval
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: feeder.timeInterval.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Feeding Time Interval (in hours)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle onChanged event to update time interval
                      // Convert the string value to double and update the feeder
                      newTimeInterval = double.parse(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Add a button to confirm and set the time interval
                ElevatedButton(
                  onPressed: () async {
                    // Update the feeder's time interval when the button is pressed
                    feeder.timeInterval = newTimeInterval;
                    bool success = await atClient.put(sharedWithESP32, ('timeInterval:%d', feeder.timeInterval));
                    if(success) {
                      // Show a confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Feeding time interval set to $newTimeInterval hours'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error occurred'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    // Set button background color
                    foregroundColor: MaterialStateProperty.all(
                        Colors.white), // Set button text color
                  ),
                  child: const Text('Set Time'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    initialValue: feeder.foodAmount.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount of food (in grams)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle onChanged event to update time interval
                      // Convert the string value to int and update the feeder
                      newFoodAmount = int.parse(value);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                // Add a button to confirm and set the time interval
                ElevatedButton(
                  onPressed: () async {
                    // Update the feeder's time interval when the button is pressed
                    feeder.foodAmount = newFoodAmount;
                    bool success = await atClient.put(sharedWithESP32, ('foodAmount:%d', feeder.foodAmount));
                    if(success) {
                      // Show a confirmation snackbar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                          Text('Food amount set to $newFoodAmount grams'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Error occurred'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.green),
                    // Set button background color
                    foregroundColor: MaterialStateProperty.all(
                        Colors.white), // Set button text color
                  ),
                  child: const Text('Set amount'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              // Set width to fill the available space horizontally
              child: ElevatedButton(
                onPressed: () async {
                  // Handle the dispense food action here
                  // Show a confirmation snackbar
                  bool success = await atClient.put(sharedWithESP32, 'dispense');
                  if(success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Food dispensed'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Error occurred'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }

                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                  // Set button background color
                  foregroundColor: MaterialStateProperty.all(
                      Colors.white), // Set button text color
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

  // Helper function to determine the color of the progress indicator based on the percentage
  Color _getProgressColor(double percentage) {
    if (percentage >= 0.7) {
      return Colors.green; // Red if percentage is 70% or more
    } else if (percentage >= 0.3) {
      return Colors.yellow; // Yellow if percentage is between 40% and 69%
    } else {
      return Colors.red; // Green if percentage is less than 40%
    }
  }

  // Helper function to build a level indicator
  Widget _buildLevelIndicator(String label, double percentage, Color color, int maxLevel, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 5),
            Text(
              '(Max: $maxLevel $unit)',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          minHeight: 10,
          // Adjust the height as needed
          value: percentage,
          backgroundColor: Colors.grey[300],
          // Set background color
          valueColor: AlwaysStoppedAnimation<Color>(color), // Set value color
        ),
      ],
    );
  }
}
