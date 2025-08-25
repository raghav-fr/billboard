import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:page_transition/page_transition.dart';
import 'package:sizer/sizer.dart';
import 'package:technova_billboard/screens/cameraScreen/cameraPage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Image(image: AssetImage("assets/images/circle2.png")),
          Container(
            padding: EdgeInsets.only(top: 10.h),
            child: Text(
              textAlign: TextAlign.center,
              "Detect Unauthorized Billboards",
              style: GoogleFonts.poppins(
                fontSize: 25.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.only(top: 10.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('assets/images/getstarted.png'),
                    height: 18.h,
                  ),
                  SizedBox(height: 4.h),
                  SizedBox(
                    width: 60.w,
                    child: Text(
                      textAlign: TextAlign.center,
                      "Find and report Billboards that  violate the rules",
                      style: GoogleFonts.poppins(fontSize: 15.sp),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.only(bottom: 15.h),
              width: 80.w,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(builder: (context) => const Camerapage()),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                    Color.fromRGBO(83, 40, 225, 1),
                  ),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
