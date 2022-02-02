
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Stateless/ForecastTimeline.dart';
import 'package:timelines/timelines.dart';

class LocationTimeline extends StatelessWidget {
  final List<LocationForecast> locations;
  
  LocationTimeline({
    required this.locations,
    Key? key
  }) : super(key: key);
  
  
  @override
  Widget build(BuildContext context) {
    return FixedTimeline.tileBuilder(
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Color(0xff989898),
        indicatorTheme: IndicatorThemeData(
          position: 0,
          size: 20.0,
        ),
        connectorTheme: ConnectorThemeData(
          thickness: 2.5,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: locations.length,
        contentsBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  locations[index].name,
                  style: DefaultTextStyle.of(context).style.copyWith(
                        fontSize: 18.0,
                      ),
                ),
                ForecastTimeline(forecast: locations[index].forecast)
              ],
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return OutlinedDotIndicator(
              borderWidth: 2.5,
              color: Colors.blueAccent,
            );
          /*
          if (processes[index].isCompleted) {
            return DotIndicator(
              color: Color(0xff66c97f),
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              ),
            );
          } else {
            
          }
          */
        },
        connectorBuilder: (_, index, ___) => SolidLineConnector(
          color: Colors.blueAccent,
        ),
      )
    );
  }
}