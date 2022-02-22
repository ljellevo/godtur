import 'package:flutter/material.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';

class DistanceDurationCard extends StatelessWidget {
  final CalculatedRouteWithForecast route;
  
  DistanceDurationCard({
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      route.getTotalDistance().toString(),
                      style: TextStyle(
                        fontSize: 34
                      ),
                    )
                  ],
                ),
                //Icon(Icons.keyboard_arrow_up)
                Column(
                  children: [
                    Text(
                      route.getTotalDuration().toString(),
                      style: TextStyle(
                        fontSize: 34
                      ),
                    )
                  ],
                ),
                
              ],
            ),
            Text(
              "(Distanse og reisetid er kun estimater)",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey
              ),
            )
          ],
        ),
      )
    );
  }
}