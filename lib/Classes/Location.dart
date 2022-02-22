
import 'package:godtur/Classes/GeoJson.dart';

class Location {
  String name;
  List<String> alternativeNames;
  GeoJson geoJson;
  int importance;
  String locationType;
  String municipality;
  String county;
  
  Location({
    required this.name,
    required this.alternativeNames,
    required this.geoJson,
    required this.importance,
    required this.locationType,
    required this.municipality,
    required this.county,
  });
  
  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      name: json['name'],
      alternativeNames: json["alternative_names"].cast<String>(),
      geoJson: new GeoJson.fromJson(json["geo_json"]),
      importance: json['importance'],
      locationType: json['location_type'],
      municipality: json['municipality'],
      county: json['county']
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'alternative_names': alternativeNames,
      'geo_json': geoJson.toJson(),
      'importance': importance,
      'location_type': locationType,
      'municipality': municipality,
      'county': county
    };
  }
}