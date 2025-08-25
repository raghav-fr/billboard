import 'dart:ui';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/provider/imageProvider/bannerImageProvider.dart';
import 'package:technova_billboard/utils/colors.dart';

class SpecificReportPage extends StatefulWidget {
  final Reportmodel report;
  const SpecificReportPage({
    super.key,
    required this.report,
    
  });

  @override
  State<SpecificReportPage> createState() => _SpecificReportPageState();
}

class _SpecificReportPageState extends State<SpecificReportPage> {
  CarouselSliderController carouselImgController = CarouselSliderController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            const Image(image: AssetImage("assets/images/circle2.png")),

            // Fixed Header
            Positioned(
              top: 10.h,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Report Details",
                  style: GoogleFonts.poppins(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Container(
              height: 80.h,
              margin: EdgeInsets.only(top: 25.h),
              padding: EdgeInsets.only(left: 7.w, right: 7.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<Bannerimageprovider>(
                      builder: (context, registrationProvider, child) {
                        List<String> bannerImages = widget.report.bannerImages;

                        List<Widget> carouselItems = [
                          ...bannerImages.map(
                            (item) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: NetworkImage(item),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ];

                        return Container(
                          height: 40.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: CarouselSlider(
                            carouselController: carouselImgController,
                            items: carouselItems,
                            options: CarouselOptions(
                              height: 35.h,
                              autoPlay: false,
                              autoPlayInterval: const Duration(seconds: 3),
                              autoPlayAnimationDuration: const Duration(milliseconds: 800),
                              autoPlayCurve: Curves.fastOutSlowIn,
                              pauseAutoPlayOnTouch: true,
                              enableInfiniteScroll: false,
                              initialPage: 0,
                              viewportFraction: 1.0,
                            ),
                          ),
                        );
                      },
                    ),

                    // Model Prediction
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.4.w, color: Colors.green),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      child: Row(
                        children: [
                          Image.asset("assets/images/Vector.png", height: 2.h),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Model Prediction",
                                style: GoogleFonts.poppins(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.report.aiResponse!,
                                style: GoogleFonts.poppins(fontSize: 16.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Address Box
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 0.4.w, color: Colors.red),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                      child: Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: customBlue, size: 3.h),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.report.address!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget.report.locationresponse!,
                                  style: GoogleFonts.poppins(fontSize: 16.sp),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 2.h),

                    // Description Box
                    Container(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Container(
                        child: Text(widget.report.description!, style: GoogleFonts.poppins(fontSize: 17.sp,color: Colors.black),),
                      )
                    ),

                    // Date Time
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 1.w, vertical: 1.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.report.datetime!,
                        style: GoogleFonts.poppins(fontSize: 16.sp),
                      ),
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ),

            // Back button
            Positioned(
              top: 5.h,
              left: 8.w,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
