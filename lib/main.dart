import 'dart:io';

import 'package:flutter/material.dart';
import 'package:untitled/pages/add_feeder_dialog_state.dart';
import 'package:untitled/pages/edit_feeder_dialog_state.dart';
import 'package:untitled/pages/feeder.dart';
import 'package:untitled/pages/feeder_detail_screen.dart';
import 'package:at_app_flutter/at_app_flutter.dart' show AtEnv;
import 'package:at_client_mobile/at_client_mobile.dart';
import 'package:at_onboarding_flutter/at_onboarding_flutter.dart';
import 'package:at_utils/at_logger.dart' show AtSignLogger;
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;

final AtSignLogger _logger = AtSignLogger(AtEnv.appNamespace);

Future<void> main() async {
  try {
    await AtEnv.load();
  } catch (e) {
    _logger.finer('Environment failed to load from .env: ', e);
  }
  runApp(const MyApp());
}

Future<AtClientPreference> loadAtClientPreference() async {
  var dir = await getApplicationSupportDirectory();

  return AtClientPreference()
    ..rootDomain = AtEnv.rootDomain
    ..namespace = 'soccer0'
    ..hiveStoragePath = dir.path
    ..commitLogPath = dir.path
    ..isLocalStoreRequired = true;
  // * By default, this configuration is suitable for most applications
  // * In advanced cases you may need to modify [AtClientPreference]
  // * Read more here: https://pub.dev/documentation/at_client/latest/at_client/AtClientPreference-class.html
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
  // * load the AtClientPreference in the background
  Future<AtClientPreference> futurePreference = loadAtClientPreference();

  List<Feeder> feeders = [
    Feeder('Feeder 1', 'Main Feeder in the Living Room', '@39fairtala', null, 1000, 1000),
    Feeder('Feeder 2', 'Secondary Feeder in the Kitchen', '',null, 1000, 1000),
  ];

  void _addFeeder(String name, String description, String esp32,File? image, int maxFood, int maxWater) {
    setState(() {
      feeders.add(Feeder(name, description, esp32, image, maxFood, maxWater));
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
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this feeder?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
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

  Future<void> _navigateToFeederDetail(Feeder feeder) async {
    AtOnboardingResult onboardingResult = await AtOnboarding.onboard(
      context: context,
      config: AtOnboardingConfig(
        atClientPreference: await futurePreference,
        rootEnvironment: AtEnv.rootEnvironment,
        domain: AtEnv.rootDomain,
        appAPIKey: AtEnv.appApiKey,
      ),
    );
    switch (onboardingResult.status) {
      case AtOnboardingResultStatus.success:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FeederDetailScreen(feeder: feeder),
          ),
        );
      case AtOnboardingResultStatus.error:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('An error has occurred'),
          ),
        );
        break;
      case AtOnboardingResultStatus.cancel:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Set the background color to green
        title: const Text(
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
          return SizedBox(
              height: 100, // Set a fixed height for each ListTile
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                // Adjust the padding to increase the item size
                leading: SizedBox(
                  width: 60, // Adjust the width of the image container
                  height: 80, // Adjust the height of the image container
                  child: feeder.imageFile != null
                      ? Image.file(feeder.imageFile!, fit: BoxFit.cover)
                      : Image.asset(
                          'assets/images/placeholder.jpg'), // Display photo if available
                ),
                title: Text(
                  feeder.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold), // Increase font size of the title
                ),
                subtitle: Text(
                  feeder.description,
                  style: const TextStyle(
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
        tooltip: 'Add a new feeder',
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
