

class DirectionsCoordinates {
  List<List<double>> coordinates;
  
  DirectionsCoordinates({
    required this.coordinates,
  });
  
  factory DirectionsCoordinates.fromJson(Map<String, dynamic> json){
    return DirectionsCoordinates (
      coordinates: json["coordinates"],
    );
  }
}