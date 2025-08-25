import 'dart:convert';

import 'package:technova_billboard/models/locationModel.dart';

class Reportmodel {
  String? reportId;
  String? userid;
  String? aiResponse;
  Locationmodel? location;
  String? address;
  String? description;
  List<String> bannerImages;
  String? datetime;
  String? locationresponse;
  Reportmodel({
    this.reportId,
    this.userid,
    this.aiResponse,
    this.location,
    this.address,
    this.description,
    required this.bannerImages,
    this.datetime,
    this.locationresponse,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    if(reportId != null){
      result.addAll({'reportId': reportId});
    }
    if(userid != null){
      result.addAll({'userid': userid});
    }
    if(aiResponse != null){
      result.addAll({'aiResponse': aiResponse});
    }
    if(location != null){
      result.addAll({'location': location!.toMap()});
    }
    if(address != null){
      result.addAll({'address': address});
    }
    if(description != null){
      result.addAll({'description': description});
    }
    result.addAll({'bannerImages': bannerImages});
    if(datetime != null){
      result.addAll({'datetime': datetime});
    }
    if(locationresponse != null){
      result.addAll({'locationresponse': locationresponse});
    }
  
    return result;
  }

  factory Reportmodel.fromMap(Map<String, dynamic> map) {
    return Reportmodel(
      reportId: map['reportId'],
      userid: map['userid'],
      aiResponse: map['aiResponse'],
      location: map['location'] != null ? Locationmodel.fromMap(map['location']) : null,
      address: map['address'],
      description: map['description'],
      bannerImages: List<String>.from(map['bannerImages']),
      datetime: map['datetime'],
      locationresponse: map['locationresponse'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Reportmodel.fromJson(String source) => Reportmodel.fromMap(json.decode(source));
}
