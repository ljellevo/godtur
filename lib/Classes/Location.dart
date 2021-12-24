

import 'package:mcappen/Classes/AlternativeName.dart';
import 'package:mcappen/Classes/Coordinates.dart';

class Location {
  String name;
  List<AlternativeName> alternativeNames;
  List<Coordinates> coordinates;
  int importance;
  String locationType;
  
  Location({
    required this.name,
    required this.alternativeNames,
    required this.coordinates,
    required this.importance,
    required this.locationType
  });
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      alternativeNames: new List<AlternativeName>.from(json["alternative_names"].map<AlternativeName>((dynamic i) => AlternativeName.fromJson(i as Map<String, dynamic>))),
      coordinates: new List<Coordinates>.from(json["coordinates"].map<Coordinates>((dynamic i) => Coordinates.fromJson(i as Map<String, dynamic>))),
      importance: json['importance'],
      locationType: json['location_type'],
    );
  }
}