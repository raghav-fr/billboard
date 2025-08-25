import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:technova_billboard/screens/homeScreen/bottomNavigation.dart';

class Getstartedpage extends StatefulWidget {
  const Getstartedpage({super.key});

  @override
  State<Getstartedpage> createState() => _GetstartedpageState();
}

class _GetstartedpageState extends State<Getstartedpage> {
  bool isLocationGranted = false;
  bool isCameraGranted = false;

  // Request Camera Permission
  Future<void> requestCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied || status.isRestricted ) {
      status = await Permission.camera.request(); // request again
    }

    if (status.isGranted) {
      setState(() {
        isCameraGranted = true;
      });
    }
  }

  // Request Location Permission
  Future<void> requestLocationPermission() async {
    var status = await Permission.locationWhenInUse.status;

    if (status.isDenied || status.isRestricted) {
      status = await Permission.locationWhenInUse.request(); // request again
    }

    if (status.isGranted) {
      setState(() {
        isLocationGranted = true;
      }); /*  */
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await requestCameraPermission();
      await requestLocationPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraGranted == false) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image(image: AssetImage("assets/images/circle2.png")),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                textAlign: TextAlign.center,
                "Access Your Camera",
                style: GoogleFonts.poppins(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                // padding: EdgeInsets.only(top: .h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/campermission.png'),
                      // height: 18.h,
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please allow us to access your Camera Services  ",
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
                  onPressed: () async {
                    await requestCameraPermission();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromRGBO(83, 40, 225, 1),
                    ),
                  ),
                  child: Text(
                    "Enable Camera Service",
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
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
    if (isLocationGranted == false) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Image(image: AssetImage("assets/images/circle2.png")),
            Container(
              padding: EdgeInsets.only(top: 10.h),
              child: Text(
                textAlign: TextAlign.center,
                "Access Your Location",
                style: GoogleFonts.poppins(
                  fontSize: 25.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                // padding: EdgeInsets.only(top: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('assets/images/locationpermission.png'),
                      // height: 18.h,
                    ),
                    SizedBox(height: 4.h),
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        textAlign: TextAlign.center,
                        "Please allow us to access your Location Services  ",
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
                  onPressed: () async {
                    await requestLocationPermission();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      Color.fromRGBO(83, 40, 225, 1),
                    ),
                  ),
                  child: Text(
                    "Enable Location Service",
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
    } else {
      return Bottomnavigation();
    }
  }
}
