import 'package:technova_billboard/models/locationModel.dart';

class PublicReviewModel {
  final String reportId;
  final String userid;
  final List<String> bannerImages;
  final String description;
  final String aiResponse;
  final String address;
  final Locationmodel location;
  final String datetime;
  final String locationresponse;
  final String status; // pending, reviewing, completed

  PublicReviewModel({
    required this.reportId,
    required this.userid,
    required this.bannerImages,
    required this.description,
    required this.aiResponse,
    required this.address,
    required this.location,
    required this.datetime,
    required this.locationresponse,
    this.status = "pending",
  });

  Map<String, dynamic> toMap() {
    return {
      "reportId": reportId,
      "userid": userid,
      "bannerImages": bannerImages,
      "description": description,
      "aiResponse": aiResponse,
      "address": address,
      "location": location.toMap(),
      "datetime": datetime,
      "locationresponse":locationresponse,
      "status": status,
    };
  }
}

class PublicVoteModel {
  final String voterId;
  final bool isValid;
  final String comment;

  PublicVoteModel({
    required this.voterId,
    required this.isValid,
    required this.comment,
  });

  Map<String, dynamic> toMap() {
    return {
      "voterId": voterId,
      "isValid": isValid,
      "comment": comment,
    };
  }
}
