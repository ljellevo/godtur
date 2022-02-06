

import 'dart:convert';

import 'package:mcappen/Classes/Coordinates.dart';

class GeoJson {
  List<List<double>> coordinates;
  String type;
  
  GeoJson({
    required this.coordinates,
    required this.type
  });
  
  factory GeoJson.fromJson(Map<String, dynamic> jsonMap){
    
    
    List<List<double>> coordinates = [];
    for (List<dynamic> row in jsonMap['coordinates']) {
      List<double> pair = [];
      for (double coord in row) {
        pair.add(coord);
      }
      coordinates.add(pair);
    }
    //var coordinates = jsonMap['coordinates'];
    return GeoJson (
      coordinates: coordinates,
      type: jsonMap["type"]
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'coordinates': coordinates,
    };
  }
  
}