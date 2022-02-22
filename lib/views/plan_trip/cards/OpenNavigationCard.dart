import 'package:flutter/material.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';

class OpenNavigationCard extends StatelessWidget {
  final CalculatedRouteWithForecast route;
  
  OpenNavigationCard({
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
            //Text("Oppsummering"),
            Text(
              "Navigasjon N/A",
              style: TextStyle(
                fontSize: 32,
                color: Colors.grey
              ),
            ),
            Text(
              "Åpner google maps",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            ),
          ],
        ),
      )
    );
  }
}