import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/Weather.dart';
import 'package:mcappen/assets/Secrets.dart';
import 'package:mcappen/components/StickyListItem.dart';
import 'package:mcappen/utils/CameraManager.dart';
import 'package:mcappen/utils/LocationManager.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/widgets/Layover.dart';
import 'package:mcappen/widgets/Search.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
//import 'package:sticky_headers/sticky_headers.dart';
import 'package:sticky_infinite_list/sticky_infinite_list.dart';
import 'package:sliver_tools/sliver_tools.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MyLocationTrackingMode trackingMode = MyLocationTrackingMode.None;
  MapboxMapController? mapController;
  Network network = new Network();
  LatLng _initialPosition = LatLng(0.0, 0.0);
  bool mapReady = false;
  int currentPage = 1;
  List<Symbol> markers = [];
  Location? selectedLocation;
  LocationForecast? locationForecast;
  
  
  void changeTrackingMode(MyLocationTrackingMode newMode) {  
    setState(() {
      trackingMode = newMode;
    });
  }
  
  void onMapLoaded(MapboxMapController controller) {
    setState(() {
      mapController = controller;
      mapReady = true;
      trackingMode = MyLocationTrackingMode.Tracking;
    });
  }
  /// Changes the camera tracking mode
  void cameraTrackingMode(MyLocationTrackingMode newTrackingMode) {
    setState(() {
      trackingMode = newTrackingMode;
    });
  }
  
  void mapClick(Point<double> point, LatLng coordinates) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }
  
  /// Loads forecasts when the user stops "scrolling" on the map
  void onMapIdle() async {
    if(mapController != null) {
      List<SymbolOptions> forecastSymbols = await new LocationManager(network: network).getForecastsWithinViewportBounds(mapController);
      mapController!.removeSymbols(markers);
      markers = await mapController!.addSymbols(forecastSymbols);
    }
  }
  
  /// Moves the camera to a given location, and disables tracking.
  void moveCameraToLocation(Location location) {
    if(mapController != null) {
      changeTrackingMode(MyLocationTrackingMode.None);
      CameraManager().moveCamera(controller: mapController!, location: LatLng(location.coordinates[0].latitude, location.coordinates[0].longitude));
    }
  }
  
  void setSelectedLocation(Location? location) async {
    LocationForecast? temp;
    if(location != null) {
      temp = await network.getAllForecastForSpecificLocation(location);
    }
    
    setState(() {
      locationForecast = temp;
      selectedLocation = location;
    });
  }
  
  
  
  Widget forecastWidget() {
    
    
    if(selectedLocation != null) {
      List<Weather> weather =  locationForecast!.getCurrentAndFutureWeatherForecasts();
      List<List<Weather>> dates = Utils().getFormattedDateArrayfromDate(weather);
      Widget listCell(int i, int j) {
        return Container(
          width: 150,
          padding: EdgeInsets.fromLTRB(10, 20, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    Utils().getFormattedTimefromDate(DateTime.fromMillisecondsSinceEpoch(dates[i][j].time * 1000)),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey
                    ),
                  ),  
                  Container(
                    width: 10,
                  ),    
                  dates[i][j].symbolCode != "" ? 
                  Image.asset(
                    "assets/icons/" + dates[i][j].symbolCode + ".png",
                    width: 35,
                    height: 35,
                  ) : Container(),
                ],
              ),
              Text(
                dates[i][j].airTemperature.toString() + "°",
                style: TextStyle(
                  fontSize: 44,
                  color: dates[i][j].airTemperature >= 0 ? Colors.red[700] : Colors.blue[700]
                ),
              ),
              Text(
                dates[i][j].windSpeed.toString() + " m/s",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey
                ),
              ),
            ],
          )
        );
      }
      return Expanded(
        child:  Container(
          padding: EdgeInsets.only(top: 20),
          child: InfiniteList(
            posChildCount: dates.length,
            negChildCount: 0,
            scrollDirection: Axis.horizontal,
            builder: (BuildContext context, int i) {
              return OverlayStickyListItem(
                padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                mainAxisAlignment: HeaderMainAxisAlignment.start,
                crossAxisAlignment: HeaderCrossAxisAlignment.start,
                headerBuilder: (BuildContext context) {
                  // margin: EdgeInsets.only(left: 10),
                  return Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Utils().getFormattedDatefromDate(DateTime.fromMillisecondsSinceEpoch(dates[i][0].time * 1000)),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey
                          ),
                        ),
                        /*
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.grey,
                                Colors.white,
                              ],
                            ),
                          ),
                          height: 2,
                          width: 150,
                        )
                        */
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
                      return listCell(i, j);
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
  
  
  Widget _floatingPanel(){
    if(selectedLocation != null) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(24.0)),
          boxShadow: [
            BoxShadow(
              blurRadius: 20.0,
              color: Colors.grey,
            ),
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
              ),
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
            //
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedLocation!.name,
                    style: TextStyle(
                      fontSize: 28
                    ),
                  ),
                  Text(
                    selectedLocation!.locationType,
                    style: TextStyle(
                      fontSize: 18
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Text(
                selectedLocation!.municipality + " • " + selectedLocation!.county,
                style: TextStyle(
                  fontSize: 14
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                locationForecast != null ? locationForecast!.getCurrentAirTemperature().toString() + "°" : "Ikke funnet",
                style: TextStyle(
                  fontSize: 44,
                  color: locationForecast!.getCurrentAirTemperature() >= 0 ? Colors.red[700] : Colors.blue[700]
                ),
              ),
              Text(
                locationForecast != null ? locationForecast!.getCurrentWindSpeed().toString() + "m/s" : "Ikke funnet",
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
            
            forecastWidget()
          ],
        )
      );
    } else {
      return Container();
    }
  }

  Widget _floatingBody() {
    return Stack(
      children: [
        MapboxMap(
          accessToken: Secrets.MAPBOX_ACCESS_TOKEN,
          onMapCreated: onMapLoaded,
          initialCameraPosition: CameraPosition(target: _initialPosition),
          styleString: Secrets.MAPBOX_STYLE_URL,
          myLocationEnabled: true,
          myLocationTrackingMode: trackingMode,
          onCameraTrackingChanged: cameraTrackingMode,
          onMapClick: mapClick,
          trackCameraPosition: true,
          onCameraIdle: onMapIdle,
        ),
        Search(
          network: network, 
          moveCameraToLocation: moveCameraToLocation,
          setSelectedLocation: setSelectedLocation,
          selectedLocation: selectedLocation,
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
  
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: SlidingUpPanel(
        renderPanelSheet: false,
        backdropEnabled: true,
        borderRadius: radius,
        minHeight: 200,
        parallaxOffset: 0.4,
        panel: selectedLocation != null ? _floatingPanel() : Container(),
        body: _floatingBody(),
      ),  
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.location_searching,
          color: Colors.white,
        ),
        onPressed: () {
          if(trackingMode == MyLocationTrackingMode.Tracking) {
              changeTrackingMode(MyLocationTrackingMode.None);
          } else {
            changeTrackingMode(MyLocationTrackingMode.Tracking);
          }
        }
      ),
    );
  }
}