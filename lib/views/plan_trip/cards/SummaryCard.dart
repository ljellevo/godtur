import 'package:flutter/material.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';
import 'package:godtur/components/TemperatureText.dart';

class SummaryCard extends StatelessWidget {
  final CalculatedRouteWithForecast route;
  
  SummaryCard({
    required this.route,
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [ 
                        Icon(Icons.keyboard_arrow_down, size: 24, color: route.getLowestAirTemperature().getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700],),
                        TemperatureText(locationRouteForecast: route.getLowestAirTemperature()),
                      ],
                    ),
                    Text(route.getLowestAirTemperature().name)
                  ],
                ),
                Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TemperatureText(locationRouteForecast: route.getHighestAirTemperature()),
                        Icon(Icons.keyboard_arrow_up, size: 24, color: route.getHighestAirTemperature().getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700],),
                      ],
                    ),
                      Text(route.getHighestAirTemperature().name)
                  ],
                )
              ],
            )
          ],
        ),
      )
    );
  }
}