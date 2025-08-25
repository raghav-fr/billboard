import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/provider/getReportsProvider/GetReportProvider.dart';
import 'package:technova_billboard/screens/reportScreens/SpecificReportPage.dart';

class Reporthistory extends StatefulWidget {
  const Reporthistory({super.key});

  @override
  State<Reporthistory> createState() => _ReporthistoryState();
}

class _ReporthistoryState extends State<Reporthistory> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<Getreportprovider>().addReport(auth.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Reportmodel> reports = context.watch<Getreportprovider>().reports;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Image(image: AssetImage("assets/images/circle2.png")),

            /// Header
            Positioned(
              top: 7.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Personal Reports",
                  style: GoogleFonts.poppins(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            /// Reports List
            Container(
              margin: EdgeInsets.only(top: 10.h),
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child:
                  reports.isEmpty
                      ? Center(
                        child: Text(
                          "No reports available",
                          style: GoogleFonts.poppins(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey,
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: reports.length,
                        itemBuilder: (context, index) {
                          final report = reports[index];
                          return InkWell(
                            onTap: (){
                              Navigator.of(context,rootNavigator: true).push(
                                MaterialPageRoute(builder: (context)=> SpecificReportPage(report: report))
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 1.5.h),
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
                                    blurRadius: 8,
                                    offset: Offset(2, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Billboard Image
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      topRight: Radius.circular(13),
                                    ),
                                    child: Image.network(
                                      report.bannerImages[0],
                                      height: 20.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                            
                                  /// Location & Date
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 12,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          report.address?.toUpperCase() ??
                                              "LOCATION",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),const SizedBox(height: 4),
                                        Text(
                                          maxLines: 3,
                                          report.datetime!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          maxLines: 3,
                                          report.description!,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            
                                  /// Buttons
                                //   Padding(
                                //     padding: const EdgeInsets.symmetric(
                                //       horizontal: 16,
                                //       vertical: 8,
                                //     ),
                                //     child: Row(
                                //       children: [
                                //         // Valid Button
                                //         Expanded(
                                //           child: Container(
                                //             height: 45,
                                //             margin: const EdgeInsets.only(
                                //               right: 8,
                                //             ),
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(
                                //                 25,
                                //               ),
                                //               border: Border.all(
                                //                 color: Colors.green,
                                //                 width: 2,
                                //               ),
                                //               color: Colors.white,
                                //             ),
                                //             child: const Center(
                                //               child: Text(
                                //                 "Valid",
                                //                 style: TextStyle(
                                //                   fontSize: 14,
                                //                   fontWeight: FontWeight.w600,
                                //                   color: Colors.green,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                            
                                //         // Invalid Button
                                //         Expanded(
                                //           child: Container(
                                //             height: 45,
                                //             margin: const EdgeInsets.only(
                                //               left: 8,
                                //             ),
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.circular(
                                //                 25,
                                //               ),
                                //               border: Border.all(
                                //                 color: Colors.red,
                                //                 width: 2,
                                //               ),
                                //               color: Colors.white,
                                //             ),
                                //             child: const Center(
                                //               child: Text(
                                //                 "Invalid",
                                //                 style: TextStyle(
                                //                   fontSize: 14,
                                //                   fontWeight: FontWeight.w600,
                                //                   color: Colors.red,
                                //                 ),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       ],
                                //     ),
                                //   ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
