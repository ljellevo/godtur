import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/CalculatedRouteWithForecast.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/Classes/RouteLinesAndBounds.dart';
import 'package:mcappen/Classes/TextControllerLocation.dart';
import 'package:mcappen/utils/CameraManager.dart';
import 'package:mcappen/utils/Network.dart';
import 'package:mcappen/utils/Utils.dart';
import 'package:mcappen/widgets/PlanTripUI.dart';
import 'package:mcappen/widgets/Search.dart';



class PlanTrip extends StatefulWidget {
  final Network network;
  final Location? selectedLocation;
  final UserLocation? userLocation;

  PlanTrip({
    required this.network,
    required this.selectedLocation,
    required this.userLocation,
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PlanTripState();
  }
}

enum TraficType {  
   Driving,
   Walking,
   Cycling,
}

extension ParseToString on TraficType {
  String toShortString() {
    return this.toString().split('.').last;
  }
}

class _PlanTripState extends State<PlanTrip> {
  List<TextControllerLocation> locationControllers = [];
  CalculatedRouteWithForecast? route;
  TraficType traficType = TraficType.Driving;
  MapboxMapController? mapController;
  RouteLinesAndBounds routeLinesAndBounds = RouteLinesAndBounds();
  StreamSubscription? RESTAsyncHandler;
  
  @override
  void initState() {
    super.initState();
    TextEditingController myLocation = new TextEditingController();
    // find my location, and add to locations array
    myLocation.text = "Min lokasjon";
    locationControllers.add(TextControllerLocation(controller: myLocation));
    
    TextEditingController destination = new TextEditingController();
    if(widget.selectedLocation != null) {
      destination.text = widget.selectedLocation!.name;
      //getLocationForecast(widget.selectedLocation!);
    }
    locationControllers.add(TextControllerLocation(controller: destination));
    getInitalRoute();
  }
  
  @override
  void dispose() {
    super.dispose();
    if(RESTAsyncHandler != null) {
      RESTAsyncHandler!.cancel();
    }
  }
  
  void onFieldTap(int i) {    
    Navigator.push(
      context, 
      MaterialPageRoute(
        builder: (context) => Search(
          network: widget.network,
          setSearchResult: (Location? location) {
            setSearchResult(location, i);
          },
          selectedLocationSearchController: locationControllers[i].getController(),
          textChanged: textChanged,
        )
      ),
    );
  }
  
  void navigateBack() {
    Navigator.pop(context);
  }
  
  void textChanged() {
    setState(() {});
  }
  
  void clearField(int i) {
    setState(() {
      locationControllers[i].getController().clear();
      locationControllers[i].setLocation(null);
    });
    _getRoute(locationControllers, traficType);
  }
  
  void addDestination() {
    if(locationControllers[locationControllers.length - 1].getController().value.text != "") {
      setState(() {
        locationControllers.add(TextControllerLocation(controller: TextEditingController()));
      });
    }
  }
  
  void removeDestination(int i) {
    setState(() {
      locationControllers.removeAt(i);
    });
    _getRoute(locationControllers, traficType);
  }
  
  void reorderControllers(int oldIndex, int newIndex) {
    final TextControllerLocation item = locationControllers.removeAt(oldIndex);
    setState(() {
      locationControllers.insert(newIndex, item);
    });
    _getRoute(locationControllers, traficType);
  }
  
  bool _listsAreEqual(list1, list2) {
    var i=-1;
    return list1.every((val) {
      i++;
      if(val is List && list2[i] is List) return _listsAreEqual(val,list2[i]);
      else return list2[i] == val;
    });
  }


  ///Feiler dersom bruker setter fra og til lokasjon til steder som ikke har noen waypoints.
  ///f.eks oslo-oslo  
  void setSearchResult(Location? location, int i) {
    setState(() {
      if(location != null){   
        if(locationControllers[i].getLocation() != null) {
          if(!_listsAreEqual(locationControllers[i].getLocation()!.geoJson.coordinates[0], location.geoJson.coordinates[0])){
            locationControllers[i].getController().text = location.name;
            locationControllers[i].setLocation(location);
            _getRoute(locationControllers, traficType);
          }
        } else {
          locationControllers[i].getController().text = location.name;
          locationControllers[i].setLocation(location);
          _getRoute(locationControllers, traficType);
        }
      } else {
        locationControllers[i].getController().text = "";
      }
    });
  }
  
  void getInitalRoute() async {
    if(widget.userLocation != null) {
      Location? userLocation = await widget.network.getLocationByCoordinate(widget.userLocation!);
      if(userLocation != null && widget.selectedLocation != null){
        locationControllers[0].setLocation(userLocation);
        locationControllers[1].setLocation(widget.selectedLocation!);
        _getRoute(locationControllers, traficType);
      } else {
        // Fant ikke bruker lokasjon, dette må håndteres
      }
    }
  }
  
  void changeTraficType(TraficType newType) async {
    setState(() {
      traficType = newType;
      //route = null;
    });
    await _getRoute(locationControllers, traficType);
    updateMapRoute();
  }
  
  
  // Anonomus functions
  Future<bool> _getRoute(List<TextControllerLocation> locationControllers, TraficType traficType) async {
    List<Location> locations = [];
    for(var loc in locationControllers){
      if(loc.getLocation() != null){
        locations.add(loc.getLocation()!);
      }
    }
    
    RESTAsyncHandler = widget.network.getRouteBetweenLocations(locations, traficType).asStream().listen((CalculatedRouteWithForecast? route) { 
      print("Response gotten");
      setState(() {
        if(route != null){
          routeLinesAndBounds = Utils().getBounds(route);
        }
        this.route = route;
      });
    });
    
    /*
    route = await widget.network.getRouteBetweenLocations(locations, traficType);
    setState(() {
      if(route != null){
        print("got route");
      }
      route = route;
    });
    */
    return true;
  }
  
  void onMapLoaded(MapboxMapController controller) async {
    setState(() {
      mapController = controller;
      updateMapRoute();
    });
  }
  
  void updateMapRoute() async {
    await mapController!.clearLines();
    mapController!.addLine(
        LineOptions(
          geometry: routeLinesAndBounds.getGeoJson(),
          lineColor: "#ff0000",
          lineWidth: 5.0,
          lineOpacity: 0.5,
          draggable: false
        ),
      );
    mapController!.moveCamera(CameraUpdate.newLatLngBounds(LatLngBounds(southwest: routeLinesAndBounds.getSouthwest()!, northeast: routeLinesAndBounds.getNortheast()!), left: 50, top: 50, bottom: 50, right: 50));
  }
  
  void onMapIdle() {
    mapController!.moveCamera(CameraUpdate.newLatLngBounds(LatLngBounds(southwest: routeLinesAndBounds.getSouthwest()!, northeast: routeLinesAndBounds.getNortheast()!), left: 50, top: 50, bottom: 50, right: 50));
  }
  
  @override
  Widget build(BuildContext context) {
    List<Location> locations = [];
    List<TextEditingController> searchControllers =  [];
    for(var loc in locationControllers){
      if(loc.getLocation() != null){
        locations.add(loc.getLocation()!);
      }
      searchControllers.add(loc.getController());
    }
    return Material(
      child: PlanTripUI(
        searchControllers: searchControllers,
        route: route,
        locations: locations,
        network: widget.network,
        addDestination: addDestination,
        removeDestination: removeDestination,
        onFieldTap: onFieldTap,
        clearField: clearField,
        navigateBack: navigateBack,
        reorderControllers: reorderControllers,
        traficType: traficType,
        changeTraficType: changeTraficType,
        onMapLoaded: onMapLoaded,
        routeLinesAndBounds: routeLinesAndBounds,
        onMapIdle: onMapIdle
      ),
    );
  }
}





