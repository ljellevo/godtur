

import 'package:mcappen/Classes/AlternativeName.dart';
import 'package:mcappen/Classes/Coordinates.dart';
import 'package:mcappen/Classes/Forecast.dart';

class LocationForecast {
  String name;
  List<String> alternativeNames;
  List<Coordinates> coordinates;
  Forecast forecast;
  int importance;
  String locationType;
  String municipality;
  String county;
  
  LocationForecast({
    required this.name,
    required this.alternativeNames,
    required this.coordinates,
    required this.forecast,
    required this.importance,
    required this.locationType,
    required this.municipality,
    required this.county,
  });
  
  factory LocationForecast.fromJson(Map<String, dynamic> json) {
    return LocationForecast(
      name: json['name'],
      alternativeNames: json["alternative_names"].cast<String>(),
      coordinates: new List<Coordinates>.from(json["coordinates"].map<Coordinates>((dynamic i) => Coordinates.fromJson(i as Map<String, dynamic>))),
      forecast: Forecast.fromJson(json["forecast"]),
      importance: json['importance'],
      locationType: json['location_type'],
      municipality: json['municipality'],
      county: json['county']
    );
  }
}