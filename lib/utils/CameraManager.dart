import 'package:mapbox_gl/mapbox_gl.dart';

class CameraManager {
  
  
  
  /*
  Moves camera to desired position with optional zoom. Default zoom is 13.
  Example of usage:
  
  new CameraManager().moveCamera(
    controller: controller, 
    location: loc
  );
  */
  void moveCamera({required MapboxMapController controller, required LatLng location, double zoom = 13}) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: location,
          zoom: zoom
        ),
      ),
    );  
  }
}