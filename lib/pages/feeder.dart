import 'dart:io';

class Feeder {
  String name;
  String description;
  File? imageFile; // Optional image file
  double foodLevel; // Food level field
  double waterLevel; // Water level field
  double timeInterval;
  int foodAmount;

  // Maximum food and water levels (adjust as needed)
  static const double maxFoodLevel = 100.0;
  static const double maxWaterLevel = 100.0;

  Feeder(this.name, this.description, this.imageFile, {this.foodLevel = 25.0, this.waterLevel = 65.0, this.timeInterval = 4, this.foodAmount = 200});

}