import 'package:flutter/material.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class WeatherComponent extends StatefulWidget {
  final MapboxMapController mapController;
  WeatherComponent({required this.mapController, Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _WeatherComponentState();
  }
}

class _WeatherComponentState extends State<WeatherComponent> {
  
  @override
  void initState() {
    super.initState();
    widget.mapController.addListener(getBounds);
  }
  
  void getBounds() async {
    LatLngBounds visibleLocation = await widget.mapController.getVisibleRegion();
    print(visibleLocation.northeast.toString() + " - " + visibleLocation.southwest.toString());
  }
  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        //color: const Color(0xFFFFE306).withOpacity(0.3)
      )
    );
  }
}