import 'package:flutter/material.dart';
import 'package:godtur/Classes/LocationRouteForecast.dart';

class TemperatureText extends StatelessWidget {
  final LocationRouteForecast locationRouteForecast;
  final double? fontSize;
  
  TemperatureText({
    required this.locationRouteForecast,
    this.fontSize = 44,
    Key? key
  }) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return Text(
      locationRouteForecast.getCurrentAirTemperature().toString() + "°",
      style: TextStyle(
        fontSize: fontSize,
        color: locationRouteForecast.getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700]
      ),
    );
  }
}