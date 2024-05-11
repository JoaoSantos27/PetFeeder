import 'dart:io';

class Feeder {
  String name;
  String description;
  File? imageFile; // Optional image file

  Feeder(this.name, this.description, this.imageFile);
}