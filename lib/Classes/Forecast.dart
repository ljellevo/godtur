import 'package:godtur/Classes/Weather.dart';

class Forecast {
  int updatedAt;
  int createdAt;
  List<Weather> weather;
  
  Forecast({
    required this.updatedAt,
    required this.createdAt,
    required this.weather
  });
  
  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      weather: new List<Weather>.from(json["weather"].map<Weather>((dynamic i) => Weather.fromJson(i as Map<String, dynamic>))),
    );
  }
}