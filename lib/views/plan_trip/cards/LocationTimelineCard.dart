import 'package:flutter/material.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';
import 'package:godtur/utils/Statics.dart';
import 'package:godtur/views/plan_trip/cards/ForecastTimeline.dart';
import 'package:godtur/components/TemperatureText.dart';
import 'package:godtur/utils/Utils.dart';
import 'package:timelines/timelines.dart';

class LocationTimelineCard extends StatelessWidget {
  final CalculatedRouteWithForecast route;
  
  LocationTimelineCard({
    required this.route,
    Key? key
  }) : super(key: key);
  
  
  List<Widget> getListContent(BuildContext context, int index) {
    return [
      Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                Utils().getFormattedTimefromDate(
                  DateTime.fromMillisecondsSinceEpoch(
                    DateTime.now().millisecondsSinceEpoch + (route.locations[index == 0 ? index : (route.locations.length - 1)].duration.toInt()*1000)
                  )
                ),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey
                ),
              ),
              Container(
                width: 10,
              ),
              Text(
                route.locations[index].name,
                style: DefaultTextStyle.of(context).style.copyWith(
                  fontSize: 18.0,
                ),
              ),
            ],
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
              Container(
                width: 10,
              ),
              TemperatureText(
                locationRouteForecast: route.locations[index],
              )
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
    
    return Card(
      elevation: 4,
      child: Container(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
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
                return Container(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: getListContent(context, index == 0 ? 0 : route.locations.length -1),
                  ),
                );
              },
              
              indicatorBuilder: (_, index) {
                return OutlinedDotIndicator(
                    borderWidth: 2.5,
                    color: Styles.blue,
                  );
              },
              connectorBuilder: (_, index, ___) => SolidLineConnector(
                color: Styles.blue,
              ),
            )
          ),
        )
      )
    );
  }
}