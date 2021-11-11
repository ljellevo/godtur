


import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/assets/Secrets.dart';

import 'package:navigation_dot_bar/navigation_dot_bar.dart';

import 'components/SearchComponent.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LatLng _initialPosition = LatLng(0.0, 0.0);
  MyLocationTrackingMode trackingMode = MyLocationTrackingMode.None;
  int currentPage = 1;
  
  
  void onMapLoaded(MapboxMapController controller) async {
    setState(() {
      trackingMode = MyLocationTrackingMode.Tracking;
    });
  }
  
  void cameraTrackingMode(MyLocationTrackingMode newTrackingMode) {
    setState(() {
      trackingMode = newTrackingMode;
    });
  }
  
  void changeTrackingMode() {
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
  
  void mapClick(Point<double> point, LatLng coordinates) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
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
          ),
          SearchComponent(),
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