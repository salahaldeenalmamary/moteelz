class FilterCountry {
  final int id;
  
  final String name;


  FilterCountry({
    required this.id,
   
    required this.name,
  
  });

  factory FilterCountry.fromJson(Map<String, dynamic> json) {
    return FilterCountry(
      id: json['id'] as int,
     
      name: json['name'] as String,
     
    );
  } 
}
