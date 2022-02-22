class Coordinates {
  List<double> coordinates;
  
  Coordinates({
    required this.coordinates
  });
  
  factory Coordinates.fromJson(Map<String, dynamic> json){
    return Coordinates (
      coordinates: json["coordinates"],
    );
  }
}