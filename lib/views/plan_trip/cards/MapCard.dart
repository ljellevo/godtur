import 'package:flutter/material.dart';
import 'package:godtur/Classes/CalculatedRouteWithForecast.dart';
import 'package:godtur/assets/Secrets.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class MapCard extends StatelessWidget {
  final CalculatedRouteWithForecast route;
  final void Function(MapboxMapController) onMapLoaded;
  final void Function() onMapIdle;
  
  MapCard({
    required this.route,
    required this.onMapLoaded,
    required this.onMapIdle,
  });
  
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Container(
        height: 400,
        child: MapboxMap(
          accessToken: Secrets.MAPBOX_ACCESS_TOKEN,
          onMapCreated: onMapLoaded,
          initialCameraPosition: CameraPosition(target: LatLng(route.locations[route.locations.length - 1].geoJson.coordinates[0][1], route.locations[route.locations.length - 1].geoJson.coordinates[0][0]), zoom: 10),
          styleString: Secrets.MAPBOX_STYLE_URL_DETAILS,
          onCameraIdle: onMapIdle,
          compassEnabled: false,
          rotateGesturesEnabled: false,
          scrollGesturesEnabled: false,
          zoomGesturesEnabled: false,
          tiltGesturesEnabled: false,
        ),
      )
    );
  }
}