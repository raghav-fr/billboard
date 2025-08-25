import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/locationModel.dart';
import 'package:technova_billboard/models/previewReportModel.dart';
import 'package:technova_billboard/models/reportModel.dart';

class Getreportservice {
  static fetchReports(String userId) async {
    List<Reportmodel> reportItems = [];
    try {
      // Navigate to AllReports/{userId}/Reports
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('AllReports')
          .doc(userId)
          .collection('Reports')
          .get();

      for (var doc in snapshot.docs) {
        Reportmodel reportItem = Reportmodel.fromMap(doc.data());
        reportItems.add(reportItem);
      }

      log("Report Items: $reportItems");
      return reportItems;
    } catch (e) {
      log("Error fetching reports: ${e.toString()}");
      return [];
    }
  }

  static Future<List<PublicReviewModel>> fetchUserReviewReports(String userId) async {
  List<PublicReviewModel> reviewItems = [];
  try {
    final snapshot = await firestore
        .collection('PublicReviews')
        .where('userid', isEqualTo: userId) // ✅ filter by userid
        .get();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      PublicReviewModel reviewItem = PublicReviewModel(
        reportId: data['reportId'],
        userid: data['userid'],
        bannerImages: List<String>.from(data['bannerImages'] ?? []),
        description: data['description'],
        aiResponse: data['aiResponse'],
        address: data['address'],
        location: Locationmodel.fromMap(data['location']), // ✅ map location
        datetime: data['datetime'],
        locationresponse: data['locationresponse'],
        status: data['status'] ?? "pending",
      );
      reviewItems.add(reviewItem);
    }

    log("✅ Fetched ${reviewItems.length} reviews for user $userId");
    return reviewItems;
  } catch (e) {
    log("❌ Error fetching user reviews: ${e.toString()}");
    return [];
  }
}

}
