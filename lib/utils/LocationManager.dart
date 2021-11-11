import 'package:mapbox_gl/mapbox_gl.dart';

class LocationManager {
  
  
  Future<LatLng?> getLocation(MapboxMapController controller) async {
    try {
      var loc = await controller.requestMyLocationLatLng();
      //LocationData locationData = await new Location().getLocation();
      if(loc != null) {
        return loc;
      }
    } catch (e) {
      print("Could not get location");
      return null;
    }
  }
}


