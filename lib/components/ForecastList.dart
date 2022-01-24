

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/Weather.dart';
import 'package:mcappen/components/OverlayStickyListItem.dart';
import 'package:mcappen/utils/Styles.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';

class ForecastList extends StatefulWidget {
  final Location? selectedLocation;
  final LocationForecast? locationForecast;
  
  ForecastList({
    required this.locationForecast,
    required this.selectedLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ForecastListState();
  }
}

class _ForecastListState extends State<ForecastList> {
  Widget listCell(int i, int j, List<List<Weather>> dates) {
    return ConstrainedBox(
      constraints: BoxConstraints(
       minWidth: 120,
      ),
      child: Container(
        padding: Utils().isWithinCurrentHour(dates[i][j]) ? EdgeInsets.fromLTRB(10, 20, 20, 0) : EdgeInsets.fromLTRB(10, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [              
                // Hour label
                Text(
                  Utils().getFormattedTimeRangefromDate(DateTime.fromMillisecondsSinceEpoch(dates[i][j].time * 1000)),
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey
                  ),
                ), 
                Text(
                  Utils().isWithinCurrentHour(dates[i][j]) ? "•" : "",
                  style: TextStyle(
                    fontSize: 24,
                    height: 1,
                    color: Colors.green
                  ),
                ),
                // Spacer 
                Container(
                  width: 10,
                ),   
                //Weather icon 
                dates[i][j].symbolCode != "" ? 
                Image.asset(
                  "assets/icons/" + dates[i][j].symbolCode + ".png",
                  width: 35,
                  height: 35,
                ) : Container(),
              ],
            ),
            // Temperature
            Text(
              dates[i][j].airTemperature.toString() + "°",
              //"-40.0°",
              style: TextStyle(
                fontSize: 44,
                color: dates[i][j].airTemperature >= 0 ? Colors.red[700] : Colors.blue[700]
              ),
            ),
            // Wind speed
            Text(
              dates[i][j].windSpeed.toString() + " m/s",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey
              ),
            ),
          ],
        )
      ),
    );
  }
  
  
  @override
  Widget build(BuildContext context) {
    if(widget.selectedLocation != null) {
      List<Weather> weather =  widget.locationForecast!.getCurrentAndFutureWeatherForecasts();
      List<List<Weather>> dates = Utils().getFormattedDateArrayfromDate(weather);
      
      return SizedBox(
        height: 150,
        child:  Container(
          padding: EdgeInsets.only(top: 20),
          child: InfiniteList(
            posChildCount: dates.length,
            negChildCount: 0,
            scrollDirection: Axis.horizontal,
            builder: (BuildContext context, int i) {
              return OverlayStickyListItem(
                padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                mainAxisAlignment: HeaderMainAxisAlignment.start,
                crossAxisAlignment: HeaderCrossAxisAlignment.start,
                headerBuilder: (BuildContext context) {
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Date label
                        Text(
                          Utils().getFormattedDatefromDate(DateTime.fromMillisecondsSinceEpoch(dates[i][0].time * 1000)),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    )
                  );
                },
                contentBuilder: (BuildContext context) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: dates[i].length,
                    physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                    itemBuilder: (BuildContext context, int j) {
                      return listCell(i, j, dates);
                    }
                  );
                },
              );
            }
          )
        )
      );
    } else {
      return Container();
    }
  }
}