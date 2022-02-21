import 'package:flutter/material.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/Forecast.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/components/TemperatureText.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:timelines/timelines.dart';

class ForecastTimeline extends StatelessWidget {
  final CalculatedRouteWithForecast route;
    
  ForecastTimeline({
    required this.route,
  });



  @override
  Widget build(BuildContext context) {
    bool isEdgeIndex(int index) {
      return index == 0 || index == route.locations.length -1;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: FixedTimeline.tileBuilder(
        theme: TimelineTheme.of(context).copyWith(
          nodePosition: 0,
          connectorTheme: TimelineTheme.of(context).connectorTheme.copyWith(
            thickness: 2.0,
          ),
          indicatorTheme: TimelineTheme.of(context).indicatorTheme.copyWith(
            size: 10.0,
            position: 0.5,
          ),
        ),
        
        builder: TimelineTileBuilder.connected(
          indicatorBuilder: (_, index) => !isEdgeIndex(index) ? Indicator.outlined(borderWidth: 2.0, color: Styles.error,) : null,
          itemCount: route.locations.length,
          contentsAlign: ContentsAlign.basic,
          connectorBuilder: (_, index, type) {
            return SolidLineConnector(
              color: Styles.error,
            );
          },
          contentsBuilder: (_, index) {
            if (isEdgeIndex(index)) {
              return null;
            }

            return Container(
              padding: EdgeInsets.only(left: 8.0),
              //margin: EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        Utils().getFormattedTimeRangefromDate(DateTime.fromMillisecondsSinceEpoch(route.locations[index].getCurrentAndFutureWeatherForecasts()[0].time*1000)),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey
                        ),
                      ), 
                      Container(
                        width: 10,
                      ),
                      Text(route.locations[index].name),
                    ]
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      route.locations[index].forecast.weather[0].symbolCode != "" ? 
                      Image.asset(
                        "assets/icons/" +  route.locations[index].forecast.weather[0].symbolCode + ".png",
                        width: 40,
                        height: 40,
                      ) : Container(),
                      Container(
                        width: 10,
                      ),
                      TemperatureText(
                        locationRouteForecast: route.locations[index],
                        fontSize: 24,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          itemExtentBuilder: (_, index) => isEdgeIndex(index) ? 10.0 : 75.0,
          //nodeItemOverlapBuilder: (_, index) => isEdgeIndex(index) ? true : null,
          
        ),
      ),
    );
  }
}