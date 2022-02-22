import 'package:godtur/Classes/DirectionsCoordinates.dart';
import 'package:godtur/Classes/LocationRouteForecast.dart';

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
  
  LocationRouteForecast getLowestAirTemperature(){
    LocationRouteForecast lowestAirTemperature = locations[0];
    for (var i = 1; i < locations.length; i++) {
      if(lowestAirTemperature.forecast.weather[0].airTemperature > locations[i].forecast.weather[0].airTemperature) {
        lowestAirTemperature = locations[i];
      }
    }
    return lowestAirTemperature;
  }
  
  LocationRouteForecast getHighestAirTemperature(){
    LocationRouteForecast highestAirTemperature = locations[0];
    for (var i = 1; i < locations.length; i++) {
      if(highestAirTemperature.forecast.weather[0].airTemperature < locations[i].forecast.weather[0].airTemperature) {
        highestAirTemperature = locations[i];
      }
    }
    return highestAirTemperature;
  }
  
  String getTotalDistance() {
    num distance = locations[locations.length - 1].distance;
    if(distance < 1000) {
      return distance.round().toString() + " m";
    }
    if(distance >= 1000) {
      return (distance * 0.001).round().toString() + " km";
    }    
    return "n/a";
  }
  
  String getTotalDuration() {
    num minutes = (locations[locations.length - 1].duration/60).round();
    num hours = (minutes / 60);
    minutes = minutes % 60;
    
    if(hours >= 1) {
      return hours.round().toString() + " h " +  minutes.toString() + " min";
    } else {
      return minutes.toString() + " min";
    }    
  }
}