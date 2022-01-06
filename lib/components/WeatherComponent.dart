/*

Used to create the overlay, intended to use instead of markers when mas is zoomed in beyond a given zoom.

*/


import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:http/http.dart' as http;
import 'package:mcappen/utils/Network.dart';

class WeatherComponent extends StatefulWidget {
  final MapboxMapController mapController;
  WeatherComponent({required this.mapController, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeatherComponentState();
  }
}


// Oslo: 59.9138 10.7387
// Sandvika: 59.89 10.526389
// Drammen: 59.74536 10.20597
class _WeatherComponentState extends State<WeatherComponent> {
  double zoom = 0;
  //Color mapColor = Color(0xFFFFE306).withOpacity(0.3);
  Color mapColor = Colors.transparent;
  Future<List<Symbol>>? markers;
  bool mapHasMarker = false;
  List<SymbolOptions> weatherMarkers = [
    SymbolOptions(iconImage: "assets/icons/clearsky_day.png", zIndex: 3, iconSize: 1, iconOpacity: 1, textField: "Oslo", textOffset: Offset(0, 2.5), geometry: LatLng(59.9138 , 10.7387)),
    SymbolOptions(iconImage: "assets/icons/lightrain.png", zIndex: 2, iconSize: 1, iconOpacity: 1, textField: "Sandvika", textOffset: Offset(0, 2.5), geometry: LatLng(59.89 , 10.526389)),
    SymbolOptions(iconImage: "assets/icons/heavyrainshowersandthunder_night.png", zIndex: 1, iconSize: 1, iconOpacity: 1, textField: "Drammen", textOffset: Offset(0, 2.5), geometry: LatLng(59.74536 , 10.20597)),
  ];
  
  @override
  void initState() {
    super.initState();
    widget.mapController.addListener(getBounds);
    markers = widget.mapController.addSymbols(weatherMarkers);
    mapHasMarker = true;
    //fetchAlbum();
    
  }

  
  void getBounds() async {
    LatLngBounds visibleLocation = await widget.mapController.getVisibleRegion();
    //print(visibleLocation.northeast.toString() + " - " + visibleLocation.southwest.toString());
    zoom = widget.mapController.cameraPosition!.zoom;
    List<Symbol>? mark = await markers;
    determineBackground(mark, zoom);
    //new Network().getLocationsWithinViewportBounds(await widget.mapController.getVisibleRegion());
  }
  
  void determineBackground(List<Symbol>? mark, double zoom) {
    if(zoom < 11) {
      setState(() {
        //mapColor = Color(0xFFFFE306).withOpacity(0.3);
        mapColor = Colors.transparent;
        if(mark != null && !mapHasMarker) {
          markers = widget.mapController.addSymbols(weatherMarkers);
          mapHasMarker = true;
        }
      });
    } else {
      setState(() {
        mapColor = Colors.blue.withOpacity(0.3);
        if(mark != null && mapHasMarker) {
          widget.mapController.removeSymbols(mark);
          mapHasMarker = false;
        }
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        color: mapColor
      )
    );
  }
}