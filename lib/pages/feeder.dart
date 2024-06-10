import 'dart:io';

class Feeder {
  String name;
  String description;
  String esp32;
  File? imageFile; // Optional image file
  int foodLevel; // Food level field
  //int waterLevel; // Water level field
  double timeInterval;
  int foodAmount; // Amount of food in grams to drop each time
  // Maximum food and water levels (adjust as needed)
  int maxFoodLevel; //In grams
  //int maxWaterLevel; //In mililiters

  Feeder(this.name, this.description, this.esp32,  this.imageFile, /*this.maxWaterLevel,*/ {this.foodLevel = 0, this.maxFoodLevel = 0, /*this.waterLevel = 800,*/ this.timeInterval = 4, this.foodAmount = 200});

}