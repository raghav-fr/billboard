import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/screens/homeScreen/bottomNavigation.dart';

class Reportcrudservices {
  static RegisterReport(Reportmodel data, BuildContext context) async {
    try {
      await firestore
          .collection("AllReports")
          .doc(auth.currentUser!.uid).collection("Reports")
          .doc(data.reportId!)
          .set(data.toMap())
          .whenComplete(() {
            Navigator.pushAndRemoveUntil(
              context,
              PageTransition(
                type: PageTransitionType.rightToLeft,
                child: Bottomnavigation(),
              ),
              (route) => false,
            );
          });
    } catch (e) {
      print("Error in report registration: $e");
    }
  }
}