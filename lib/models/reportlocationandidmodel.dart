import 'dart:convert';

class Reportlocationandidmodel {
  String? id;
  String? latitude;
  String? longitude;
  Reportlocationandidmodel({
    this.id,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(id != null){
      result.addAll({'id': id});
    }
    if(latitude != null){
      result.addAll({'latitude': latitude});
    }
    if(longitude != null){
      result.addAll({'longitude': longitude});
    }
  
    return result;
  }

  factory Reportlocationandidmodel.fromMap(Map<String, dynamic> map) {
    return Reportlocationandidmodel(
      id: map['id'],
      latitude: map['latitude'],
      longitude: map['longitude'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reportlocationandidmodel.fromJson(String source) => Reportlocationandidmodel.fromMap(json.decode(source));
}
