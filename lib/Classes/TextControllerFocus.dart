
import 'package:flutter/material.dart';
import 'package:mcappen/Classes/Location.dart';

class TextControllerFocus {
  
  TextEditingController _controller;
  FocusNode _focus;
  Location? _location;
  
  TextControllerFocus({required controller, required focus}) : _controller = controller, _focus = focus;
  
  TextEditingController getController() {
    return _controller;
  }
  
  FocusNode getFocus() {
    return _focus;
  }
  
  Location? getLocation() {
    return _location;
  }
  
  void setLocation(Location? location) {
    _location = location;
  }
  
}