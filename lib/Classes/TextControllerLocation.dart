
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';

class TextControllerLocation {
  
  TextEditingController _controller;
  Location? _location;
  
  TextControllerLocation({
    required controller
  }) : _controller = controller;
  
  TextEditingController getController() {
    return _controller;
  }
  
  Location? getLocation() {
    return _location;
  }
  
  void setLocation(Location? location) {
    _location = location;
  }
}