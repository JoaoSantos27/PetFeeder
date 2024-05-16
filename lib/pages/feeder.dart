import 'dart:io';

class Feeder {
  String name;
  String description;
  File? imageFile; // Optional image file
  int foodLevel; // Food level field
  int waterLevel; // Water level field
  double timeInterval;
  int foodAmount; // Amount of food in grams to drop each time
  // Maximum food and water levels (adjust as needed)
  int maxFoodLevel; //In grams
  int maxWaterLevel; //In mililiters

  Feeder(this.name, this.description, this.imageFile, this.maxFoodLevel, this.maxWaterLevel, {this.foodLevel = 251, this.waterLevel = 800, this.timeInterval = 4, this.foodAmount = 200});

}