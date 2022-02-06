

class DirectionsCoordinates {
  List<List<double>> coordinates;
  
  DirectionsCoordinates({
    required this.coordinates,
  });
  
  factory DirectionsCoordinates.fromJson(Map<String, dynamic> json){
    List<List<double>> coordinates = [];
    for (List<dynamic> row in json['coordinates']) {
      List<double> pair = [];
      for (double coord in row) {
        pair.add(coord);
      }
      coordinates.add(pair);
    }
    return DirectionsCoordinates (
      coordinates: coordinates,
    );
  }
}