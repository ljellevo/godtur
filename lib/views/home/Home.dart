import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:godtur/Classes/Location.dart';
import 'package:godtur/Classes/LocationForecast.dart';
import 'package:godtur/assets/Secrets.dart';
import 'package:godtur/views/Home/FloatingPanel.dart';
import 'package:godtur/utils/CameraManager.dart';
import 'package:godtur/utils/LocationManager.dart';
import 'package:godtur/utils/Network.dart';
import 'package:godtur/views/Home/Finder.dart';
import 'package:godtur/views/plan_trip/PlanTrip.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';


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
  UserLocation? userLocation;
  
  
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
      CameraManager().moveCamera(controller: mapController!, location: LatLng(location.geoJson.coordinates[0][1], location.geoJson.coordinates[0][0]));
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
  
  void planTrip() {
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => PlanTrip(
          network: network,
          selectedLocation: selectedLocation,
          userLocation: userLocation,
        )
      ),
    );
  }
  
  void addToFavorites() {
    print("Favorites");
  }
  
  void userLocationUpdated(UserLocation newUserLocation) {
    setState(() {
      userLocation = newUserLocation;
    });
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
          onUserLocationUpdated: userLocationUpdated,
        ),
        Finder(
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
        panel: selectedLocation != null ? FloatingPanel(
          locationForecast: locationForecast, 
          selectedLocation: selectedLocation,
          planTrip: planTrip,
          addToFavorites: addToFavorites,
        ) : Container(),
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