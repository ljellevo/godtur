import 'package:flutter/material.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/Classes/LocationForecast.dart';
import 'package:godtur/views/Home/ForecastList.dart';
import 'package:godtur/utils/Statics.dart';

class FloatingPanel extends StatefulWidget {
  final Location? selectedLocation;
  final LocationForecast? locationForecast;
  final Function planTrip;
  final Function addToFavorites;
  
  FloatingPanel({
    required this.locationForecast,
    required this.selectedLocation,
    required this.planTrip,
    required this.addToFavorites,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _FloatingPanelState();
  }
}

class _FloatingPanelState extends State<FloatingPanel> {
  
  @override
  Widget build(BuildContext context) {
    if(widget.selectedLocation != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0, 3),
            )
          ]
        ),
        margin: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 0),
                  )
                ]
              ), // Color.fromRGBO(204, 213, 174, 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey[300]!,
                        ),
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.selectedLocation!.name,
                          style: TextStyle(
                            fontSize: 28,
                            color: Styles.primary
                          ),
                        ),
                        Text(
                          widget.selectedLocation!.locationType,
                          style: TextStyle(
                            fontSize: 18,
                            color: Styles.primary
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      widget.selectedLocation!.municipality + " • " + widget.selectedLocation!.county,
                      style: TextStyle(
                        fontSize: 14,
                            color: Styles.primary
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.locationForecast != null ? widget.locationForecast!.getCurrentAirTemperature().toString() + "°" : "Ikke funnet",
                          style: TextStyle(
                            fontSize: 44,
                            color: widget.locationForecast != null && widget.locationForecast!.getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700]
                          ),
                        ),
                        Text(
                          widget.locationForecast != null ? widget.locationForecast!.getCurrentWindSpeed().toString() + "m/s" : "Ikke funnet",
                          style: TextStyle(
                            fontSize: 44,
                            color: Colors.grey
                          ),
                        ),
                      ],
                    )
                  ),
                ],
              ),
            ),
            ForecastList(
              selectedLocation: widget.selectedLocation!,
              locationForecast: widget.locationForecast,
            ),
            Container(
              padding: EdgeInsets.only(left: 20, top: 50, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: Styles().roundButton(Colors.white, Styles.secondary),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.map,
                          size: 17,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text("Planlegg tur", style: TextStyle(color: Colors.white, fontSize: 13)),
                      ],
                    ),
                    onPressed: (){
                      widget.planTrip();
                    },
                  ),
                  /*
                  TextButton(
                    style: Styles().roundButton(Colors.white, Colors.orange),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 17,
                        ),
                        Container(
                          width: 10,
                        ),
                        Text("Legg til favoritter", style: TextStyle(color: Colors.white, fontSize: 13))
                      ],
                    ),
                    onPressed: (){
                      widget.addToFavorites();
                    },
                  ),
                  */
                ],
              )
            )
          ],
        )
      );
    } else {
      return Container();
    }
  }
}