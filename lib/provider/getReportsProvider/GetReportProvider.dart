// import 'dart:developer';

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/previewReportModel.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/services/getReportsServices/getReportService.dart';
import 'package:technova_billboard/services/publicReviewServices/publicReviewServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Getreportprovider extends ChangeNotifier {
  List<Reportmodel> reports = [];
  List<PublicReviewModel> reviewreports = [];

  addReport(String userid) async {
    reports = [];
    List<Reportmodel> data = await Getreportservice.fetchReports(userid);
    reports.addAll(data);
    notifyListeners();
    print("reports added: ${reports[0].reportId}");
  }

  addReviewReport(String userid) async {
    reviewreports = [];
    List<PublicReviewModel> data =
        await Getreportservice.fetchUserReviewReports(userid);
    reviewreports.addAll(data);
    notifyListeners();
    print("reports added: ${reports[0].reportId}");
  }

  List<PublicReviewModel> _nearbyReviews = [];
  List<PublicReviewModel> get nearbyReviews => _nearbyReviews;

  List<String> _votedReports = [];
  List<String> get votedReports => _votedReports;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  /// Fetch all public reviews within 1 km radius of user
  Future<void> fetchNearbyReviews(String currentUserId) async {
    try {
      _isLoading = true;
      notifyListeners();

      Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<PublicReviewModel> allReviews =
          await PublicReviewServices.getAllPublicReviews();

      _nearbyReviews = [];
      _votedReports.clear();

      for (var review in allReviews) {
        // Skip owner’s own reviews
        if (review.userid == currentUserId) continue;

        double distanceInMeters = Geolocator.distanceBetween(
          pos.latitude,
          pos.longitude,
          review.location.latitude!,
          review.location.longitude!,
        );

        if (distanceInMeters <= 1000) {
          _nearbyReviews.add(review);

          // 🔹 Check if current user already voted
          final voteDoc =
              await FirebaseFirestore.instance
                  .collection("PublicReviews")
                  .doc(review.reportId)
                  .collection("Votes")
                  .doc(currentUserId)
                  .get();

          if (voteDoc.exists) {
            _votedReports.add(review.reportId);
          }
        }
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint("Error fetching nearby reviews: $e");
    }
  }

  Future<void> submitVote({
    required String reportId,
    required String voterId,
    required bool isValid,
    required String comment,
  }) async {
    try {
      PublicVoteModel vote = PublicVoteModel(
        voterId: voterId,
        isValid: isValid,
        comment: comment,
      );
      await PublicReviewServices.addVote(reportId, vote);
      _votedReports.add(reportId);
      notifyListeners();
    } catch (e) {
      debugPrint("Error submitting vote: $e");
    }
  }

  Future<String> uploadAndCheckImage(File imageFile) async {
    try {
      // API endpoint
      var uri = Uri.parse("https://2e187309b292.ngrok-free.app/send");

      // Create multipart request
      var request = http.MultipartRequest('POST', uri);

      // Attach file with key "file"
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send request
      var response = await request.send();

      // Convert response to string
      var responseBody = await response.stream.bytesToString();
      var jsonData = json.decode(responseBody);

      print("API Response: $jsonData");

      // Extract status (legal / illegal)
      if (jsonData["predictions"] != null &&
          jsonData["predictions"]["detections"] != null &&
          jsonData["predictions"]["detections"].isNotEmpty) {
        String detectedClass =
            jsonData["predictions"]["detections"][0]["class"] ?? "unknown";
        return detectedClass; // will return "legal" or "illegal"
      }

      return "unknown";
    } catch (e) {
      print("Error uploading image: $e");
      return "error";
    }
  }

  Future<String> checkLocation(double latitude, double longitude) async {
  try {
    var uri = Uri.parse("https://2e187309b292.ngrok-free.app/location");

    var body = jsonEncode({
      "latitude": latitude,
      "longitude": longitude,
    });

    var response = await http.post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      return jsonData["status"]; // only return status string
    } else {
      return "error";
    }
  } catch (e) {
    return "error";
  }
}}
