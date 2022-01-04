import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/assets/Secrets.dart';
import 'package:mcappen/utils/CameraManager.dart';
import 'package:mcappen/utils/LocationManager.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:navigation_dot_bar/navigation_dot_bar.dart';
import '../components/SearchComponent.dart';

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
  TextEditingController searchController = TextEditingController();
  
  void changeTrackingMode() async {  
    if(trackingMode == MyLocationTrackingMode.Tracking) {
      setState(() {
        trackingMode = MyLocationTrackingMode.None;
      });
    } else {
      setState(() {
        trackingMode = MyLocationTrackingMode.Tracking;
      });
    }
  }
  
  void onMapLoaded(MapboxMapController controller) async {
    setState(() {
      mapController = controller;
      mapReady = true;
      trackingMode = MyLocationTrackingMode.Tracking;
    });
  }
  
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
  
  void onMapIdle() async {
    if(mapController != null) {
      List<SymbolOptions> forecastSymbols = await new LocationManager(network: network).getForecastsWithinViewportBounds(mapController);
      mapController!.removeSymbols(markers);
      markers = await mapController!.addSymbols(forecastSymbols);
    }
  }
  
  void moveCameraToLocation(Location location) {
    if(mapController != null) {
      CameraManager().moveCamera(controller: mapController!, location: LatLng(location.coordinates[0].latitude, location.coordinates[0].longitude));
    }
  }
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body: Stack(
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
          SearchComponent(network: network, searchController: searchController, moveCameraToLocation: moveCameraToLocation),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.location_searching,
          color: Colors.white,
        ),
        onPressed: changeTrackingMode,
      ),
      
      bottomNavigationBar: SafeArea(
        child: BottomNavigationDotBar (
          initialPosition: 1,
          items: <BottomNavigationDotBarItem>[
            BottomNavigationDotBarItem(icon: Icons.favorite, onTap: () { }),
            BottomNavigationDotBarItem(icon: Icons.map, onTap: () {  }),
            BottomNavigationDotBarItem(icon: Icons.settings, onTap: () {  }),
          ]
        ),   
      )
    );
  }
}