

import 'package:mapbox_gl/mapbox_gl.dart';

class RouteLinesAndBounds {
  List<LatLng> _geoJson = [];
  LatLng? _southwest;
  LatLng? _northeast;
  
  RouteLinesAndBounds();
  
  LatLng? getSouthwest() {
    return _southwest;
  }
  
  void setSouthwest(LatLng newSouthwest) {
    _southwest = newSouthwest;
  }
  
  LatLng? getNortheast() {
    return _northeast;
  }
  
  void setNortheast(LatLng newNortheast) {
    _northeast = newNortheast;
  }
  
  List<LatLng> getGeoJson() {
    return _geoJson;
  }
  
  void add(LatLng entry) {
    _geoJson.add(entry);
  }

}