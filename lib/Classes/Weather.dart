

class Weather {
  int time;
  num airTemperature;
  num windFromDirection;
  num windSpeed;
  String symbolCode;
  
  Weather({
    required this.time,
    required this.airTemperature,
    required this.windFromDirection,
    required this.windSpeed,
    required this.symbolCode
  });
  
  String getSymbolCode() {
    return symbolCode != "" ? symbolCode : "unknown";
  }
  
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      time: json['time'],
      airTemperature: json['air_temperature'],
      windFromDirection: json['wind_from_direction'],
      windSpeed: json['wind_speed'],
      symbolCode: json['symbol_code'],
    );
  }
}