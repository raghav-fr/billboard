import 'dart:convert';

class Locationmodel {
  double? latitude;
  double? longitude;
  Locationmodel({
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(latitude != null){
      result.addAll({'latitude': latitude});
    }
    if(longitude != null){
      result.addAll({'longitude': longitude});
    }
  
    return result;
  }

  factory Locationmodel.fromMap(Map<String, dynamic> map) {
    return Locationmodel(
      latitude: map['latitude']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Locationmodel.fromJson(String source) => Locationmodel.fromMap(json.decode(source));
}
