import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/locationModel.dart';
import 'package:technova_billboard/models/previewReportModel.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/screens/homeScreen/bottomNavigation.dart';

class PublicReviewServices {
  static Future<void> createDraft(PublicReviewModel data,BuildContext context) async {
    await firestore.collection("PublicReviews").doc(data.reportId).set(data.toMap()).whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: Bottomnavigation(),
              ),
              (route) => false,
            );
          });
  }

  static Future<void> addVote(String reportId, PublicVoteModel vote) async {
    await firestore
        .collection("PublicReviews")
        .doc(reportId)
        .collection("Votes")
        .doc(vote.voterId)
        .set(vote.toMap());
  }

  static Future<void> finalizeReview(String reportId, Reportmodel finalReport) async {
    // move to Reports
    await firestore
        .collection("AllReports")
        .doc(finalReport.userid)
        .collection("Reports")
        .doc(reportId)
        .set(finalReport.toMap());

    // delete from PublicReviews
    await firestore.collection("PublicReviews").doc(reportId).delete();
  }

  static Future<List<PublicReviewModel>> getAllPublicReviews() async {
    QuerySnapshot snapshot = await firestore.collection("PublicReviews").get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return PublicReviewModel(
        reportId: data["reportId"],
        userid: data["userid"],
        bannerImages: List<String>.from(data["bannerImages"] ?? []),
        description: data["description"],
        aiResponse: data['aiResponse'],
        locationresponse: data["locationresponse"],
        address: data["address"],
        location: Locationmodel.fromMap(data["location"]),
        datetime: data["datetime"],
        status: data["status"] ?? "pending",
      );
    }).toList();
  }

  static Future<List<PublicVoteModel>> getVotesForReport(String reportId) async {
    QuerySnapshot snapshot = await firestore
        .collection("PublicReviews")
        .doc(reportId)
        .collection("Votes")
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return PublicVoteModel(
        voterId: data["voterId"],
        isValid: data["isValid"],
        comment: data["comment"],
      );
    }).toList();
  }
}
