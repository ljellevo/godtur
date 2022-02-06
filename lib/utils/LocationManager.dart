

import 'package:flutter/widgets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:mcappen/Classes/Location.dart';
import 'package:mcappen/Classes/LocationForecast.dart';
import 'package:mcappen/utils/Network.dart';

class LocationManager {
  Network network;
  
  LocationManager({
    required this.network
  });
  
  void getLocationsWithinViewportBounds(MapboxMapController? mapController) async {
    if(mapController != null) {
      List<Location> locations = await network.getLocationsWithinViewportBounds(await mapController.getVisibleRegion());
    }
  }
  
  Future<List<SymbolOptions>> getForecastsWithinViewportBounds(MapboxMapController? mapController) async {
    if(mapController != null) {
      List<LocationForecast> forecasts =  await network.getForecastsWithinViewportBounds(await mapController.getVisibleRegion());
      List<SymbolOptions> forecastMarkers = [];
      for(var i = 0; i < forecasts.length; i++) {
        forecastMarkers.add(SymbolOptions(
          iconImage: "assets/icons/" + forecasts[i].forecast.weather[0].symbolCode + ".png", 
          zIndex: 20 - forecasts[i].importance, 
          //zIndex: 3, 
          iconSize: 1, 
          iconOpacity: 1, 
          textField: forecasts[i].name, 
          textSize: 12,
          textOffset: Offset(0, 2.5), 
          geometry: LatLng(forecasts[i].geoJson.coordinates[0][1] , forecasts[i].geoJson.coordinates[0][0]),
        ));
      }
      return forecastMarkers;
    }
    return [];
  }
}