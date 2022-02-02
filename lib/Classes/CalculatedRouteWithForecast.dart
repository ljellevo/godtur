

import 'package:mcappen/Classes/DirectionsCoordinates.dart';
import 'package:mcappen/Classes/LocationRouteForecast.dart';

class CalculatedRouteWithForecast {
  DirectionsCoordinates directions;
  List<LocationRouteForecast> locations;
  
  CalculatedRouteWithForecast({
    required this.directions,
    required this.locations
  });
  
  factory CalculatedRouteWithForecast.fromJson(Map<String, dynamic> json){
    return CalculatedRouteWithForecast (
      directions: DirectionsCoordinates.fromJson(json["directions"]),
      locations: new List<LocationRouteForecast>.from(json["locations"].map<LocationRouteForecast>((dynamic i) => LocationRouteForecast.fromJson(i as Map<String, dynamic>)))
      
    );
  }
}