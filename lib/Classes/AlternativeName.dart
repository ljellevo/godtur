class AlternativeName {
  String name;
  
  AlternativeName({
    required this.name
  });
  
  factory AlternativeName.fromJson(Map<String, dynamic> json) {
    return AlternativeName(
      name: json['name'],
    );
  }
}