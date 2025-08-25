import 'dart:io';
import 'dart:ui';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/constants/constant.dart';
import 'package:technova_billboard/models/locationModel.dart';
import 'package:technova_billboard/models/previewReportModel.dart';
import 'package:technova_billboard/models/reportModel.dart';
import 'package:technova_billboard/provider/getReportsProvider/GetReportProvider.dart';
import 'package:technova_billboard/provider/imageProvider/bannerImageProvider.dart';
import 'package:technova_billboard/services/publicReviewServices/publicReviewServices.dart';
import 'package:technova_billboard/services/reportCRUDServices/ReportCRUDServices.dart';
import 'package:technova_billboard/utils/colors.dart';

class ReportPage extends StatefulWidget {
  final String imagePath;
  final String address;
  final double latitude;
  final double longitude;

  const ReportPage({
    super.key,
    required this.imagePath,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  CarouselSliderController carouselImgController = CarouselSliderController();
  TextEditingController descController = TextEditingController();
  late String formattedDateTime;
  bool isLoading = false; // 🔹 Loader state
  String? airesponse;

  String getFormattedDateTime() {
    DateTime now = DateTime.now();
    return DateFormat("MMM d, yyyy   h:mm a").format(now);
  }

  @override
  void initState() {
    super.initState();
    formattedDateTime = getFormattedDateTime();
    context.read<Bannerimageprovider>().reportBannerImage.add(
      File(widget.imagePath),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async{ 
        airesponse= await  context.read<Getreportprovider>().uploadAndCheckImage(File(widget.imagePath));

    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,

        // 🔹 Fixed Buttons at Bottom
        bottomNavigationBar: Container(
          padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: 35.w,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(customBlue),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // 🔹 Start loading
                    });

                    await context
                        .read<Bannerimageprovider>()
                        .updateReportBannerImageUrl(context);

                    PublicReviewModel data = PublicReviewModel(
                      userid: auth.currentUser!.uid,
                      reportId: uuid.v4(),
                      aiResponse: airesponse!,
                      locationresponse: "invalid",
                      bannerImages:
                          context
                              .read<Bannerimageprovider>()
                              .reportBannerImageUrl,
                      description: descController.text.trim(),
                      address: widget.address,
                      location: Locationmodel(
                        longitude: widget.longitude,
                        latitude: widget.latitude,
                      ),
                      datetime: formattedDateTime,
                    );

                    await PublicReviewServices.createDraft(data, context);

                    context.read<Bannerimageprovider>().setNull();

                    setState(() {
                      isLoading = false; // 🔹 Stop loading
                    });
                  },
                  child: Text(
                    "Public Review",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 35.w,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(customBlue),
                  ),
                  onPressed: () async {
                    setState(() {
                      isLoading = true; // 🔹 Start loading
                    });

                    await context
                        .read<Bannerimageprovider>()
                        .updateReportBannerImageUrl(context);

                    Reportmodel data = Reportmodel(
                      userid: auth.currentUser!.uid,
                      reportId: uuid.v4(),
                      aiResponse: airesponse!,
                      locationresponse: "invalid",
                      bannerImages:
                          context
                              .read<Bannerimageprovider>()
                              .reportBannerImageUrl,
                      description: descController.text.trim(),
                      address: widget.address,
                      location: Locationmodel(
                        longitude: widget.longitude,
                        latitude: widget.latitude,
                      ),
                      datetime: formattedDateTime,
                    );

                    print(data.toJson());
                    await Reportcrudservices.RegisterReport(data, context);

                    context.read<Bannerimageprovider>().setNull();

                    setState(() {
                      isLoading = false; // 🔹 Stop loading
                    });
                  },
                  child: Text(
                    "Submit",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

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
                  "Report",
                  style: GoogleFonts.poppins(
                    fontSize: 25.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Scrollable content
            Container(
              height: 70.h,
              margin: EdgeInsets.only(top: 20.h),
              padding: EdgeInsets.only(left: 7.w, right: 7.w),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<Bannerimageprovider>(
                      builder: (context, registrationProvider, child) {
                        List<File> bannerImages =
                            registrationProvider.reportBannerImage;

                        List<Widget> carouselItems = [
                          ...bannerImages.map(
                            (item) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(item),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              registrationProvider.getReportBannerImage(
                                context,
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              height: 20.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: customBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.white,
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
                              autoPlayAnimationDuration: const Duration(
                                milliseconds: 800,
                              ),
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
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
                                "valid",
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 3.w,
                        vertical: 1.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            color: customBlue,
                            size: 3.h,
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.address,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Invalid",
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
                    SizedBox(
                      height: 20.h,
                      child: TextField(
                        controller: descController,
                        textAlignVertical: TextAlignVertical.top,
                        maxLines: null,
                        expands: true,
                        cursorColor: customBlue,
                        cursorRadius: Radius.circular(10),
                        cursorWidth: .2.h,
                        decoration: InputDecoration(
                          hintText: "Description...",
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: customBlue,
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: customBlue,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: customBlue,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(12),
                        ),
                      ),
                    ),

                    // Date Time
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 1.w,
                        vertical: 1.h,
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        formattedDateTime,
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
                onPressed: () {
                  context.read<Bannerimageprovider>().reportBannerImage = [];
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.black,
                ),
              ),
            ),

            // 🔹 Loader Overlay with Blur
            if (isLoading)
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: customBlue),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
