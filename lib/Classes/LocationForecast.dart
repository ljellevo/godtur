import 'package:godtur/Classes/Forecast.dart';
import 'package:godtur/Classes/GeoJson.dart';
import 'package:godtur/Classes/Weather.dart';

class LocationForecast {
  String name;
  List<String> alternativeNames;
  GeoJson geoJson;
  Forecast forecast;
  int importance;
  String locationType;
  String municipality;
  String county;
  
  LocationForecast({
    required this.name,
    required this.alternativeNames,
    required this.geoJson,
    required this.forecast,
    required this.importance,
    required this.locationType,
    required this.municipality,
    required this.county,
  });
  
  num getCurrentAirTemperature() {
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    for(var i = 0; i < forecast.weather.length; i++) {
      if(forecast.weather[i].time > timestamp - 3600 && forecast.weather[i].time <= timestamp) {
        return forecast.weather[i].airTemperature;
      }
    }
    return -1;
  }
  
  num getCurrentWindSpeed() {
    double timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    for(var i = 0; i < forecast.weather.length; i++) {
      if(forecast.weather[i].time > timestamp - 3600 && forecast.weather[i].time <= timestamp) {
        return forecast.weather[i].windSpeed;
      }
    }
    return -1;
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
  
  
  factory LocationForecast.fromJson(Map<String, dynamic> json) {
    return LocationForecast(
      name: json['name'],
      alternativeNames: json["alternative_names"].cast<String>(),
      geoJson: new GeoJson.fromJson(json["geo_json"]),
      forecast: Forecast.fromJson(json["forecast"]),
      importance: json['importance'],
      locationType: json['location_type'],
      municipality: json['municipality'],
      county: json['county']
    );
  }
}