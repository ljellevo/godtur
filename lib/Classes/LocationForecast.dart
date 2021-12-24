

import 'package:mcappen/Classes/AlternativeName.dart';
import 'package:mcappen/Classes/Coordinates.dart';
import 'package:mcappen/Classes/Forecast.dart';

class LocationForecast {
  String name;
  List<AlternativeName> alternativeNames;
  List<Coordinates> coordinates;
  Forecast forecast;
  int importance;
  String locationType;
  
  LocationForecast({
    required this.name,
    required this.alternativeNames,
    required this.coordinates,
    required this.forecast,
    required this.importance,
    required this.locationType
  });
  
  factory LocationForecast.fromJson(Map<String, dynamic> json) {
    return LocationForecast(
      name: json['name'],
      alternativeNames: new List<AlternativeName>.from(json["alternative_names"].map<AlternativeName>((dynamic i) => AlternativeName.fromJson(i as Map<String, dynamic>))),
      coordinates: new List<Coordinates>.from(json["coordinates"].map<Coordinates>((dynamic i) => Coordinates.fromJson(i as Map<String, dynamic>))),
      forecast: Forecast.fromJson(json["forecast"]),
      importance: json['importance'],
      locationType: json['location_type'],
    );
  }
}