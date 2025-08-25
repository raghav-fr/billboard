import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/previewReportModel.dart';
// import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/provider/getReportsProvider/GetReportProvider.dart';
// import 'package:technova_billboard/screens/publicReviewScreen/SpecificReviewPage,dart';
import 'package:technova_billboard/screens/publicReviewScreen/SpecificReviewPage.dart';
import 'package:technova_billboard/services/publicReviewServices/publicReviewServices.dart';
import 'package:technova_billboard/utils/colors.dart';
// import 'package:technova_billboard/services/publicReviewServices/publicReviewServices.dart';

class PublicReviewPage extends StatefulWidget {
  const PublicReviewPage({super.key});

  @override
  State<PublicReviewPage> createState() => _PublicReviewPageState();
}

class _PublicReviewPageState extends State<PublicReviewPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Fetch all reports in 1 km radius
      await context.read<Getreportprovider>().fetchNearbyReviews(auth.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<Getreportprovider>();
    List<PublicReviewModel> reports = provider.nearbyReviews;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Image(image: AssetImage("assets/images/circle2.png")),

            /// Fixed Header
            Positioned(
              top: 7.h,
              left: 0,
              right: 0,
              child: Text(
                textAlign: TextAlign.center,
                "Nearby Public Reviews",
                style: GoogleFonts.poppins(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            /// Scrollable List of Cards
            Container(
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                child: Column(
                  children: reports.map((report) {
                    bool hasVoted = provider.votedReports.contains(report.reportId);

                    return InkWell(
                      onTap: () async{
                        List<PublicVoteModel> vote = await PublicReviewServices.getVotesForReport(report.reportId);

                        Navigator.of(context,rootNavigator: true).push(
                                MaterialPageRoute(builder: (context)=> Specificreviewpage(reviewreport: report, vote: vote))
                              );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Colors.deepPurple.shade200,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.deepPurple.shade100,
                              blurRadius: 10,
                              offset: const Offset(2, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Banner Image
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(13),
                                topRight: Radius.circular(13),
                              ),
                              child: Image.network(
                                report.bannerImages[0],
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                      
                            /// Location + DateTime + Description
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    report.address,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    report.datetime,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    report.description,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                      
                            /// Buttons OR "Already Voted"
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              child: hasVoted
                                  ? Row(
                                    children: [
                                      Icon(Icons.check_circle, color: customBlue,),
                                      SizedBox(width: 2.w,),
                                      Text(
                                          "You already voted on this banner",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                    ],
                                  )
                                  : Row(
                                      children: [
                                        // ✅ Valid Button
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _showFeedbackPopup(
                                                context,
                                                report,
                                                true,
                                              );
                                            },
                                            child: Container(
                                              height: 45,
                                              margin: const EdgeInsets.only(right: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                border: Border.all(
                                                  color: Colors.green,
                                                  width: 2,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Valid",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.green,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                      
                                        // ❌ Invalid Button
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              _showFeedbackPopup(
                                                context,
                                                report,
                                                false,
                                              );
                                            },
                                            child: Container(
                                              height: 45,
                                              margin: const EdgeInsets.only(left: 8),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                                border: Border.all(
                                                  color: Colors.red,
                                                  width: 2,
                                                ),
                                                color: Colors.white,
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  "Invalid",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show feedback bottom sheet
  void _showFeedbackPopup(BuildContext context, PublicReviewModel report, bool isValid) {
    final TextEditingController feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isValid ? "Why is this banner is valid?" : "Why is this banner is invalid?",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter your feedback...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: 50.w,
                child: ElevatedButton(
                  onPressed: () {
                    String feedback = feedbackController.text.trim();
                    if (feedback.isNotEmpty) {
                      context.read<Getreportprovider>().submitVote(
                            reportId: report.reportId,
                            voterId: auth.currentUser!.uid,
                            isValid: isValid,
                            comment: feedback,
                          );
                      Navigator.pop(context);
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(customBlue)
                  ),
                  child:  Text("Submit", style: GoogleFonts.poppins(fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white),),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
