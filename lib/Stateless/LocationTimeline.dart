
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Stateless/ForecastTimeline.dart';
import 'package:timelines/timelines.dart';

class LocationTimeline extends StatelessWidget {
  final List<Location> locations;
  final CalculatedRouteWithForecast route;
  
  LocationTimeline({
    required this.route,
    required this.locations,
    Key? key
  }) : super(key: key);
  
  
  List<Widget> getListContent(BuildContext context, int index) {
    return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            route.locations[index].name,
            style: DefaultTextStyle.of(context).style.copyWith(
              fontSize: 18.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              route.locations[index].forecast.weather[0].symbolCode != "" ? 
              Image.asset(
                "assets/icons/" +  route.locations[index].forecast.weather[0].symbolCode + ".png",
                width: 44,
                height: 44,
              ) : Container(),
              Text(
                route.locations[index].getCurrentAirTemperature().toString() + "°",
                style: TextStyle(
                  fontSize: 44,
                  color: route.locations[index].getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700]
                ),
              ),
            ],
          )
        ],
      ),
      index == 0 ? 
        ForecastTimeline(
        route: route
      ): Container()
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: FixedTimeline.tileBuilder(
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
        itemCount: 2,
        contentsBuilder: (_, index) {
          return Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: getListContent(context, index == 0 ? 0 : route.locations.length -1),
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return OutlinedDotIndicator(
              borderWidth: 2.5,
              color: Colors.blueAccent,
            );
        },
        connectorBuilder: (_, index, ___) => SolidLineConnector(
          color: Colors.blueAccent,
        ),
      )
    ),
    );
  }
}