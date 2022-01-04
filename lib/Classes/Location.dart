

import 'package:mcappen/Classes/Coordinates.dart';

class Location {
  String name;
  List<String> alternativeNames;
  List<Coordinates> coordinates;
  int importance;
  String locationType;
  String municipality;
  String county;
  
  Location({
    required this.name,
    required this.alternativeNames,
    required this.coordinates,
    required this.importance,
    required this.locationType,
    required this.municipality,
    required this.county,
  });
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      alternativeNames: json["alternative_names"].cast<String>(),
      coordinates: new List<Coordinates>.from(json["coordinates"].map<Coordinates>((dynamic i) => Coordinates.fromJson(i as Map<String, dynamic>))),
      importance: json['importance'],
      locationType: json['location_type'],
      municipality: json['municipality'],
      county: json['county']
    );
  }
}