import 'package:godtur/Classes/Forecast.dart';
import 'package:godtur/Classes/GeoJson.dart';
import 'package:godtur/Classes/Weather.dart';

class LocationRouteForecast {
  String name;
  List<String> alternativeNames;
  GeoJson geoJson;
  Forecast forecast;
  int importance;
  String locationType;
  String municipality;
  String county;
  num distance;
  num duration;
  
  LocationRouteForecast({
    required this.name,
    required this.alternativeNames,
    required this.geoJson,
    required this.forecast,
    required this.importance,
    required this.locationType,
    required this.municipality,
    required this.county,
    required this.distance,
    required this.duration
  });
  
  num getCurrentAirTemperature() {
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    if(forecast.weather.length == 1) {
      return forecast.weather[0].airTemperature;
    }
    for(var i = 0; i < forecast.weather.length; i++) {
      if(forecast.weather[i].time > timestamp - 3600 && forecast.weather[i].time <= timestamp) {
        return forecast.weather[i].airTemperature;
      }
    }
    return -1000;
  }
  

  
  num getCurrentWindSpeed() {
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    if(forecast.weather.length == 1) {
      return forecast.weather[0].windSpeed;
    }
    for(var i = 0; i < forecast.weather.length; i++) {
      if(forecast.weather[i].time > timestamp - 3600 && forecast.weather[i].time <= timestamp) {
        return forecast.weather[i].windSpeed;
      }
    }
    return -1000;
  }
  
  List<Weather> getCurrentAndFutureWeatherForecasts() {
    List<Weather> weather = [];
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    for(var i = 0; i < forecast.weather.length; i++) {
      if(forecast.weather[i].time < timestamp - 3600) {
        continue;
      }
      weather.add(forecast.weather[i]);
    }
    return weather;
  }
  
  
  factory LocationRouteForecast.fromJson(Map<String, dynamic> json) {
    return LocationRouteForecast(
      name: json['name'],
      alternativeNames: json["alternative_names"].cast<String>(),
      geoJson: new GeoJson.fromJson(json["geo_json"]),
      forecast: Forecast.fromJson(json["forecast"]),
      importance: json['importance'],
      locationType: json['location_type'],
      municipality: json['municipality'],
      county: json['county'],
      distance: json['distance'],
      duration: json['duration'],
    );
  }
}